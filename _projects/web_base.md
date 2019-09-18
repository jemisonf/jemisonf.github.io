---
title: Web base
short_description: A base set of styles for new web projects
github: https://github.com/jemisonf/web_base
layout: project
---

This was one of the smaller projects I've done, but also one of the more useful ones. It's a pretty simple npm repository that uses `npm-sass` to build a base stylesheet from about 8 Sass files (as of writing), arranged in the [7-1 pattern](https://sass-guidelin.es/#the-7-1-pattern). The base styles can be built into a new project fairly easily, reducing start-up time and making it easier to build a stylesheet from scratch without using Bootstrap or Foundation.

I originally made the repository after I had to copy a bunch of flexbox styles from a work project into the first iteration of this site. I also noticed I was pretty frequently copying code for other basic styles too, like resetting the margins on `<body>`. The original repository had:

* Base reset styles--margin, background for the body tag
* A set of exposed flexbox classes, like `.flex-row` and `.justify-center` to create a row justified center
* Color variables
* A single font stack and base font size
* A 7-1 style directory structure and `main.scss` file

I used it for the first time with [msgr](/projects/msgr) and it worked great. I didn't find myself overwriting a bunch of styles, and the structure worked really well for the project. I was skeptical initially about how useful this project was going to be, but saving myself probably an hour of work on a homework assignment was a huge success and I felt really vindicated for putting in the initial work.

The project came in handy again for this site, although I had a few more growing pains. For one, the typography on fgj.codes is a lot more complicated than I originally envisioned when I was setting up the base styles, with different header, subheader, body, and code typefaces. I also had had a philosophical shift with flex styles; instead of exposing them directly to the user, I wanted to use them as mixins within the code to create a simpler interface. I also used some additional variables in the code for this site, and wanted to save the [link style](.) I used on this site. The new update added:

* Mixins, including flex mixins and a mixin for the heavy underline used in links
* More variables, including separate code, header, and body font stacks
* The system font stack, courtesy [CSS-tricks](https://css-tricks.com/snippets/css/system-font-stack/)
* Row and column styles 

I'm going to continue updating the repository as new issues come up, but I'm fairly happy with it so far.
