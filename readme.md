# About

This is the source code for [fgj.codes](https://fgj.codes), my homepage and portfolio site. The page is built in Jekyll, with styles in Sass using the [7-1 pattern](https://sass-guidelin.es/#architecture) by Hugo Giraudel. I used my [web_base](https://github.com/jemisonf/web_base) styles as a base for the project.

The structure of the code is fairly standard jekyll. There are no posts--yet :)--but "projects" is a collection where each element has a name, short description, and github link attribute in addition to the standard layout attribute. `create_project.rb` in the base of the directory is a script that makes creating new projects a little bit faster. It camei n handy when I had to create a bunch really early on when I first made the site.

To run the site locally, run `bundle install` and `bundle exec jekyll serve`.
