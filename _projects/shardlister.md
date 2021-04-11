---
title: Shardlister
short_description: A CLI tool for working with sharded Argo CD controllers
github: https://github.com/jemisonf/shardlister
layout: project
---

In November 2020, the Argo CD maintainers [released Argo CD 1.8](https://blog.argoproj.io/please-welcome-argo-cd-v1-8-rc-5799850cb2b6) with some major new features, including one in particular that my team was looking forward to:

> Last but not least, we’ve improved *argocd-application-controller* scalability. Until the v1.8 release, the *argocd-application-controller* is the only component that could not be scaled horizontally. Among other things, the controller is responsible for maintaining the target Kubernetes cluster cache and application reconciliations which requires memory and CPU. This becomes a bottleneck if your Argo CD instance manages more than a hundred Kubernetes clusters. The v1.8 Argo CD release introduces cluster shards and allows running multiple instances of *argocd-application-controller*.

This was a big deal for us; our production instance of Argo CD was managing over 5000 applications at once, which meant it had to do memory and CPU intensive operations like generating and applying Kubernetes manifests at a very high rate, which in turn led us to have to run a single pod that reserved over 40 gigabytes of memory on a single dedicated node, with no option for scaling except doubling the size of the dedicated instance.

With the switch to the sharded controller, we got a lot of relief from our scaling issues. Instead of a single instance, we were able to use 12 more reasonably sized pods, each of which managed a subset of the clusters registered with our Argo CD instance. This was a huge improvement, but it had a couple shortcomings. In particular, the tooling didn't exist to answer questions like:

* How many applications does each shard have to manage?
* How many clusters does each shard have to manage?
* What clusters are causing the most load on a given shard?

These questions all become fairly important to answer in the event that you have one shard overloaded and you need to offload some of its load to other shards. This wasn't a theoretical issue; because our clusters are fairly heterogeneous, we have shards running from 5-10% utilization to over 90% utilization at any given moment, and we needed to be prepared to rebalance the cluster allocation in the event of an incident.

My attempt to make this process easier turned into a tool called [shardlister](https://github.com/jemisonf/shardlister), which I initially published internally and later mirrored to a public repository. It takes advantage of some internal Argo CD go packages, including the API clients for `Applications` and the `sharding` package, which has a utility for computing the shard a cluster should be assigned to.

The repo uses a pretty typical setup for go CLI apps built with `cobra`, a popular CLI library. The base package imports the settings from the `cmd` package, where `cmd` mostly handles input validation and presentation and relies on `lister` for the actual logic of fetching `Application` and `Cluster` resources. Since it's designed for use by a person and not for automated use, it defaults to fetching your kubernetes and Argo CD context from `~/.kube/config` and `~/.argocd/config` instead of requiring a separate token; you can login normally with `kubectl` and `argocd` and use `shardlister` without any extra effort, which is a major usability win.

Overall, I was really happy with how this project turned out. We have it incorporated into our runbook for scaling Argo CD, and usability and performance definitely seem acceptable for the intended use case. I would expect to see some of these features eventually incorporated into the main `argocd` CLI, but for the time being this has been an excellent stopgap solution.