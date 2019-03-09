---
name: HtmlFileStripper
short_description: a library for stripping tags and characters from HTML files
github: https://github.com/jemisonf/HtmlFileStripper
layout: project
---

`HtmlFileStripper` is a tool I built while working at [Zapproved](https://zapproved.com) as part of a larger migration tool. As there isn't any confidential information in the project, I was able to put it on my github. 

The tool has a pretty straightforward interface:
```c#
var tags = new List<string>
{
    "img"
};
var characters = new Dictionary<char, char>
{
    { 'a', '\0' }
};
var FileStripper = new HtmlFileStripper(characters, tags);
FileStripper.StripFile(inputfile, outputfile, encoding);
```

`HtmlFileStripper` can either replace characters with another character, like replacing a non-breaking space with a regular space, or remove them. Tags are simply removed.

Overall, I was pretty happy with this project; it was performant enough to work without needing any real optimization, and the API was advanced enough to handle all of my needs. This is not the cleanest c# code I have ever written, but my understanding of style best practices was much better at the point that I wrote this than it was when I was initially learning the language. This was also the first time I experimented with test driven development, as you can see in the `HtmlFileStripperTest` section of the repository. That approach worked really well for me and I continued using it in later projects.
