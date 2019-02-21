---
name: fgj.codes
short_description: This website!
github: https://github.com/jemisonf.github.io
layout: project
---

This site was the result of a pretty long process of research and compromise. I originally started making it in fall 2018, with some pretty lofty goals. Here's the extremely optimistic entry I put in my resume for the project:

> Raspberry Pi Web Server, Personal Project (in progress) 

> - Installed Alpine Linux on a Raspberry pi and set up remote access using OpenSSH

> - Set up DNS, port-forwarding, and a custom domain 

> - Created a custom home page from scratch using SASS and React.js

> - Built a continuous deployment pipeline for my home site using CircleCI and Github

All of these components existed, but some were pretty rough; the react page existed but didn't have any content, and I hadn't really used the circleCI deploy in practice. A couple problems jumped out as I started working on integrating them into a fully functioning website:

1. Per my terms of service with Comcast, I wasn't allowed to host a web server in my apartment. I also had to consider that I didn't any guarantees about my IP address, so if I continued with self-hosting I'd have to deal with my server periodically going down because DNS couldn't find it.
2. React is a pain to work with and doesn't have *great* static site generating tools. I was working with a custom webpack workflow I'd used in the past. It worked fine, but I wasn't sure it was the greatest solution. [Here's](https://github.com/OSU-CS290-F17/final-project-asdfas/blob/master/webpack.config.js) a link to basically the same approach being used in another project.
3. I had investigated proper static site generators, like Gatsby for React, and could see the advantages of using one of those.


As a fix to #1, I considered moving to AWS, but that was more expensive than I would've liked. Github sites jumped out as an alternative; when I started looking into that, the native Jekyll integration started to seem more appealing, since it was pretty much automatically going to be easier than whatever other solution I could come up with. I'd also used React to build [msgr](https://fgj.codes/projects/msgr), so I wasn't feeling as much pressure to add something to my portfolio there.

The final solution ended up being this:

* Static hosting on Github sites
* CDN and SSL through Cloudflare
* Custom code in SASS and Jekyll

This was cool because it was lighter-weight than a React site would've been, it had a good solution for adding custom markdown content, and it was *100% free*. I was skeptical about Jekyll at first, and I found their documentation wasn't great when you were working on a theme from scratch, but after spending some time on the project I'm really happy with how it's gone so far. 
