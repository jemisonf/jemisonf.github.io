---
name: fgj.codes
short_description: This website!
github: https://github.com/jemisonf.github.io
layout: project
---

### Tech

This site was the result of a long process of research and compromise. I originally started making it in fall 2018, with some pretty lofty goals. Here's the extremely optimistic entry I put in my resume for the project:

> Raspberry Pi Web Server, Personal Project (in progress) 

> - Installed Alpine Linux on a Raspberry pi and set up remote access using OpenSSH

> - Set up DNS, port-forwarding, and a custom domain 

> - Created a custom home page from scratch using SASS and React.js

> - Built a continuous deployment pipeline for my home site using CircleCI and Github

All of these components existed, but some were pretty rough; the react page existed but didn't have any content, and I hadn't really used the circleCI deploy in practice. A couple problems jumped out as soon I started working on integrating them into a fully functioning website:

1. Per my terms of service with Comcast, I wasn't allowed to host a web server in my apartment. I also had to consider that I didn't any guarantees about my IP address, so if I continued with self-hosting I'd have to deal with my server periodically going down because DNS couldn't find it.
2. React is a pain to work with and doesn't have *great* static site generating tools. I was working with a custom webpack workflow I'd used in the past. It worked fine, but I wasn't sure it was the greatest solution. [Here's](https://github.com/OSU-CS290-F17/final-project-asdfas/blob/master/webpack.config.js) a link to basically the same approach being used in another project.
3. I had investigated proper static site generators, like Gatsby for React, and could see the advantages of using one of those.


As a fix to #1, I considered moving to AWS, but that was more expensive than I would've liked. Github sites jumped out as an alternative; when I started looking into that, the native Jekyll integration started to seem more appealing, since it was pretty much automatically going to be easier than whatever other solution I could come up with. I'd also used React to build [msgr](https://fgj.codes/projects/msgr), so I wasn't feeling as much pressure to add something to my portfolio there.

The final solution ended up being this:

* Static hosting on Github sites
* CDN and SSL through Cloudflare
* Custom code in SASS and Jekyll

This was cool because it was lighter-weight than a React site would've been, it had a good solution for adding custom markdown content, and it was *100% free*. I was skeptical about Jekyll at first, and I found their documentation wasn't great when you were working on a theme from scratch, but after spending some time on the project I'm really happy with how it's gone so far. 

### Design

The design process for this site was really challenging, and part of the reason it took me so long to get it up and running was because of the challenges of creating a comprehensive design. I wanted something that:

* Had an edgy, but functional design vision
* Represented my design voice
* Could serve as a kind of playground for design ideas I couldn't implement at the library because of OSU brand restrictions
* Looked nothing like a bootstrap site

One idea I was really fixated on was monospace fonts, which I've been enamored with lately. The original design was all monospace, with a black text on a red background. It was edgy, but not functional; monospace is actually really hard to read in big blocks of text, and bold colored backgrounds were a little *too* edgy. I was also initially working only in HTML and CSS for the design, a process I've since moved away from.

Realizing that this wasn't working, I went back to basics and started trying to build the site in [Figma](https://figma.com), a tool I've used at the library for design prototyping. I worked out some rough initial designs, none of which really resonated with me:

<iframe style="border: none;" width="800" height="450" src="https://www.figma.com/embed?embed_host=share&url=https%3A%2F%2Fwww.figma.com%2Ffile%2FZuZuA5YmWn5N6yxUO0rxM42E%2FHomepage%3Fnode-id%3D0%253A1" allowfullscreen></iframe>

While I was struggling with the design process, I started collecting examples of sites I liked. A non exhaustive list is:

* [The Boston Review](http://bostonreview.net/)
* [Timbuk2](https://www.timbuk2.com/)
* [vgpena.github.io](https://vgpena.github.io/)
* [Wired](https://www.wired.com/)

Some features I pulled out from those were:

* Flat designs that don't have an appearance of height
* Use of monospace (<3) fonts for subtext and emphasis
* Offset, wonky colored backgrounds
* Bold use of color

I really liked the 3D text effect that the BR uses for their title text, but I couldn't find a way to work it into the final design. You can see some attempts in the drafts. I struggled a lot with color schemes, going between red, green, and black, and using a purple color for the main site color when I initially built the design. I found [Adobe Color](https://color.adobe.com) to be really helpful in working out color schemes once I started incorporating multiple colors into the design. 


This current design was the first time I actually really fell in love with a prototype, although even this needed a lot of tweaking to add enough visual interest to make it seem like a "real" website. I'm still searching for a free sans serif font that I love as much as the typeface [TechTown PDX](https://techtownportland.com/) uses, but Montserrat is a happy medium for me right now. I experimented wtih the [system font stack](https://css-tricks.com/snippets/css/system-font-stack/) for the body font, but went back to Lato after seeing Google Chrome absolutely butcher the font weight on Linux Mint. Overall, the type styles are definitely still in flux. I'm continuing to experiment with colors as well, although I'm fairly happy with the triadic scheme I have going on the front page of the site.
