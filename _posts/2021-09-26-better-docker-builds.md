---
layout: post
title: Faster, Smaller, and More Secure Docker Builds
short_description: Some simple steps for improved Docker builds
---

For this post, I'd like to highlight some Docker features and techniques that are useful but often left out of entry level tutorials, or that you may have missed if you learned Docker more than a couple years ago and haven't closely followed the latest releases. I'm using Docker Desktop 20.10.8 in this post but as long as you're within a couple major versions of that I wouldn't expect any compatibility issues.

I created an example application that we're going to use to test out the steps; you can find it on GitHub at [jemisonf/docker_builds](https://github.com/jemisonf/docker_builds/). For the final version, check out the `master` branch of the repo, or start with the `start-here` tag to follow along with the post.

_Note: this post uses a Go app as an example, but should be applicable to non-Go apps as well. If you're familiar with Docker but not Go, you can just skip over the Go-specific parts._

Our example service is a Go web server. It has a single route, `/serialize`, that accepts a Kubernetes resource in the body, validates it, and returns it serialized into protobuf. To try it out:
* Clone the repository and check out the first commit with 
```shell
git clone git@github.com:jemisonf/docker_builds.git 
cd docker_builds 
git checkout start-here
```
* Run `go run .` in one terminal
* In a second, run `curl localhost:3333/serialize --data-binary @./examples/deployment.yaml --output output.proto`

That last command will send the yaml file located in `examples/deployment.yaml` to the server and then save the output in `output.proto`. You can check that it worked with `cat output.proto`; the result should be a more or less meaningless jumble of binary text.

_Note: the example service is a little contrived, but it simulates a "real" application by pulling in a number of dependencies via the `k8s.io/apimachinery` and `k8s.io/client-go` packages_

If we want to package this service into a Docker image, the "naive" approach would look something like this:

```Dockerfile
FROM golang:1.16

WORKDIR /app

COPY . ./

RUN go build .

CMD ./docker_builds
``` 

We can build and run our docker file with

```shell
docker build . -t docker_builds
docker run -p 3333:3333 docker_builds
```

Our build output should look something like this, if you're using the newest version of Docker:
```
 => [internal] load build definition from Dockerfile                                                                                                                                                    0.0s
 => => transferring dockerfile: 113B                                                                                                                                                                    0.0s
 => [internal] load .dockerignore                                                                                                                                                                       0.0s
 => => transferring context: 2B                                                                                                                                                                         0.0s
 => [internal] load metadata for docker.io/library/golang:1.16                                                                                                                                          1.4s
 => [auth] library/golang:pull token for registry-1.docker.io                                                                                                                                           0.0s
 => [internal] load build context                                                                                                                                                                       0.1s
 => => transferring context: 11.82kB                                                                                                                                                                    0.0s
 => [1/4] FROM docker.io/library/golang:1.16@sha256:0056b049979bfcf13ac2ede60b810349396fab1d510cb60701503dccd01f9153                                                                                    0.0s
 => => resolve docker.io/library/golang:1.16@sha256:0056b049979bfcf13ac2ede60b810349396fab1d510cb60701503dccd01f9153                                                                                    0.0s
 => CACHED [2/4] WORKDIR /app                                                                                                                                                                           0.0s
 => [3/4] COPY . ./                                                                                                                                                                                     0.2s
 => [4/4] RUN go build .                                                                                                                                                                               13.2s
 => exporting to image                                                                                                                                                                                  1.6s 
 => => exporting layers                                                                                                                                                                                 1.6s 
 => => writing image sha256:e7e90943fba98c38660bc8361e8c520e07b71fb69d22b6b0a3be2b9189c5d941     
 ```

 If you scroll to the right, notice that the time to complete each step in our build is listed, in seconds. We spend the most time on `RUN go build` -- no surprise there. 

 Let's make a small code change -- for example, we can make the port configurable in `main.go`:
 ```go
 	port := ":3333"
	if len(os.Args) > 1 {
		port = os.Args[1]
	}

	err := server.StartServer(port)
```

If we run `docker build .` again, we should get about the same build time. This isn't a huge problem for our relatively small app, but as you may have noticed a lot of that time is just spent downloading dependencies. This is true for a lot of languages -- in general, the build for a service in almost any language is going to look like:

1. Download depencies. 
    
    **Requires**: package management files, like `go.mod` and `go.sum` or `package.json` or `requirements.txt`.
2. In some languages, build or bundle the application code into a binary (like in Go) or a single script bundle (like in Node). 

    **Requires**: application code
3. Copy the application code into the Docker file. 

    **Requires**: the artifact from step 2.

When you build a Docker image, each line in your `Dockerfile` is broken out into a "layer". Docker understands which files (either inside in the Docker image or in your file system) are required to create the layer, and will use a cached version of the layer if no changes are detected in those files from the previous build. You can [read more about layers here](https://docs.docker.com/storage/storagedriver/).

We can take advantage of this behavior in order to cache our dependencies and save that time in each repeated build. This is not possible in our current approach because we're copying all of the code in our repo at once, and then running `go build`, which combines downloading dependencies and building application code into one command. 

To make caching our dependencies possible, let's first copy our dependency files (`go.mod` and `go.sum`), then download our dependencies with `go mod download`, then build our application code with `go build`:

```Dockerfile
FROM golang:1.16

WORKDIR /app

COPY go.mod go.sum .

RUN go mod download

COPY . ./

RUN go build .
CMD ./docker_builds
```

This pattern is not specific to Go. In a node app, it would look like:

```Dockerfile
FROM node:16

WORKDIR /app

COPY package.json package-lock.json .

RUN npm install

COPY . ./

# build your app ...
```

This should work for most apps, regardless of language: copy your dependency files, download your dependencies, then copy your application files and build your application.

An even more general way to put this is: place the commands in your Dockerfile in order from least likely to change to most likely to change. For example, if you had to install a system dependency first via a package manager, you'd do that before copying any of your dependency files or application code.

If we try running `docker image ls`, we'll see another potential problem:

```
REPOSITORY   TAG       IMAGE ID       CREATED             SIZE
<none>       <none>    e7e90943fba9   15 minutes ago      1.05GB
```

Our image is pretty large; Go compiles down to static files, so why do we need a whole gigabyte for our image? This presents a couple problems:
* It uses more space on your hard drive
* Large docker images are slower to download, which can slow down your deploy time
* Larger docker images present a larger "attack surface". If someone gains access to the running container there are more scripts they can run to potentially gain access to the underlying host running the container

Fortunately, we have a relatively simple solution that can address all of these problems at once: ["distroless images"](https://github.com/GoogleContainerTools/distroless), a project maintained by Google, give you a minimal base image with every unnecessary tool stripped out. 

This is not the only option for minimal docker builds; you can use a small Linux distribution like Alpine Linux as your base image, or start from the empty `scratch` Docker image. I would recommend [this talk from Matthew Moore](https://www.youtube.com/watch?v=lviLZFciDv4) as an introduction to the limitations of those approaches and why distroless is the most flexible approach out of all the available options.

We can introduce a distroless base image for our app using a tool called [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/), which lets us specify different "stages" for our build that each have their own base image. That way we can use a larger base image to build our application code, and then copy the resulting binary into the distroless base image:

```Dockerfile
FROM golang:1.16 AS builder

WORKDIR /app

COPY go.mod go.sum .

RUN go mod download

COPY . ./

RUN go build . 

FROM gcr.io/distroless/base

WORKDIR /app

COPY --from=builder /app/docker_builds .

CMD ["/app/docker_builds"]
```

Now if we run `docker image ls`, we should see our latest image, with a much smaller size of 46 MB:

```
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
<none>       <none>    40ebe2a35240   2 hours ago    46.3MB
```

For examples of how this works with other languages and runtimes, check out the [distroless](https://github.com/GoogleContainerTools/distroless) GitHub repo linked above.

Now we have a secure, minimal image that's quick to build locally. We can set up a GitHub action to build our image using the example from Docker's [Build and Push Docker Images](https://github.com/marketplace/actions/build-and-push-docker-images#git-context) Action. To get that set up:
1. Set up a Docker Hub account and create an access token
2. Create a `.github/workflows/build.yaml` file containing the sample
3. Change all references to `user/app` to `${your Docker Hub username}/docker_builds`
4. Add your Docker Hub username to the `DOCKERHUB_USERNAME` secret in your GitHub repo and and your Docker Hub access token to the `DOCKERHUB_TOKEN` secret.

I'd also recommend changing the default tag to push two tags, one for the commit SHA and one `latest` tag. For my repo that looks like:
```yaml
-  name: Build and push
   id: docker_build
   uses: docker/build-push-action@v2
   with:
   with:
       push: true
       # if forking, replace `jemisonf` with your docker hub username
       tags: jemisonf/docker_builds:${{ github.sha }},jemisonf/docker_builds:latest
```

Pushing only `latest` can be OK for sample projects, but it's generally a bad idea for production applications. Using the SHA for the commit you're building means you can precisely associate Docker builds with each release of your application.

If you push this to your GitHub repo, let it build, and then re-run the action, you may notice that the build is no longer taking advantage of the docker cache. For this app, the impact isn't huge because our build should only take around a minute. For larger apps with more dependencies, this may become a more significant problem.

We can solve this problem using Docker [external caches](https://docs.docker.com/engine/reference/commandline/build/#specifying-external-cache-sources). With external caches, we can pull the cached layers of a previous image from the Docker registry during our Docker build, letting us re-use caches in between builds. This is easy to configure in GitHub actions using the `cache-from` and `cache-to` options in our build and push step:

```yaml
with:
    push: true
    # if forking, replace `jemisonf` with your docker hub username
    tags: jemisonf/docker_builds:${{ github.sha }},jemisonf/docker_builds:latest
    cache-from: type=registry,ref=jemisonf/docker_builds:latest
    cache-to: type=inline
```

See the [cache docs](https://github.com/docker/build-push-action/blob/master/docs/advanced/cache.md) for the Action for more details.

If we push this change, let the build complete, and then trigger a rebuild for the same commit we should see the Docker build complete almost instantly because it's re-using the previous build's cache. Future builds should be able to take advantage of the caching behavior we saw locally to minimize the amount of steps in the build.

_Note: because this step requires downloading layers from a remote repository, it's possible it won't save time in every case if it's slower to download those layers than to download your application dependencies. I would expect this to be worthwhile for the average project, but it's worth evaluating on an individual basis if your project actually benefits from it before using it._

## Wrap-up

A short summary of the suggestions in this post:
* You can make your Docker builds more cache-friendly by copying your dependency files and installing dependencies before copying your application files and building your application.
* In general, Docker can cache your build more easily if you run your Dockerfile commands in order of least likely to change to most likely to change
* You can make your output builds smaller and more secure using [multi-stage builds]() and a [distroless base image](https://github.com/GoogleContainerTools/distroless). Other alternatives are using Alpine Linux or `scratch` as your base image
* You can speed up CI builds by sharing your Docker build cache between builds using [external cache sources](https://docs.docker.com/engine/reference/commandline/build/#specifying-external-cache-sources), which you can enable using the [cache settings](https://github.com/docker/build-push-action/blob/master/docs/advanced/cache.md) in the Docker build and push GitHub Action

That's it! The steps in this post should be applicable to most projects using Docker for builds, and should help ensure that your Docker images are small, fast to build, and secure. I've tried to link documentation and relevent resources wherever possible, and I'd strongly recommend reading those as well; this post is intended as an introduction to each of concepts mentioned and I'll defer to linked resources to provide the depth that's missing here.

