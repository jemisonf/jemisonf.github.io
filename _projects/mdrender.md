---
name: mdrender
short_description: A C++ library for rendering markdown to HTML
github: https://github.com/jemisonf/mdrender
layout: project
---

Mdrender was developed as part of OSU's Software Engineering I class in cooperation with [Sean Gillen](https://github.com/gillens) and [Sonica Gupta](https://github.com/guptaso). Inspired by my struggles with writing markdown documentation and not being able to preview its output, I wanted to build a software library that could render markdown files locally to html. Our deliverables were the library itself, as well as a command-line application that used the library. The application is used as follows:

```bash
$ mdrender $MD_SOURCE -o $HTML_OUTPUT
```

Using the mdrender library gave us a very simple interface to build the command line application on. It looks basically like this:
```cpp
// sets the markdown file
MdToCpp markdownParser;
markdownParser.set_file(input_file);

// gets the data 
MdData data = markdownParser.get_md_data();

// converts data to HTML
CppToHtml markdownDataParser;	
markdownDataParser.set_data(&data);
string output_html = markdownDataParser.get_html();
```

Two basic steps are happening here:

1. `markdownParser` takes `input_file` and creates an `MdData` object based on the file contents
2. `markdownDataParser` takes the output data and converts it to an output string

`MdData` is an data type used internally that represents paragraphs as nodes in a linked list. A user generally wouldn't have to interact with it, but a library extending mdrender could use it.   

The project wasn't perfect; we originally planned to be able to convert to PDF, but scrapped that because of the complexities of converting to PDF without using an external library. We also have limited handling for complex features like tables or syntax higlighting because of the limits of the structure of `MdData`. This is something that could be pretty easily extended on later, but we decided it was out of scope for the original product.
