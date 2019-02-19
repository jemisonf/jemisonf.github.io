---
name: msgr
short_description: An app for posting messages
github: https://github.com/jemisonf/cs340_final_project
layout: project
---

msgr (pronounced "messenger") is an app developed by myself and [Ian Brown](ianbrown9475) for our final project for Introduction to Databases at OSU. It is a web application that allows user to post Twitter-style "messages", comment on "messages" and follow other users. At one time it was hosted on [msgr.fgj.codes](http://msgr.fgj.codes); someday it may appear there again.

Here's a basic overview of the architecture, which is based on the [JAM stack](https://jamstack.org/):

![Msgr architecture overview](/assets/msgr_overview.svg)    
(made by me in LucidChart)


Basically, the app uses three services:

* An api server that serves data to the user, built in Flask
* A static content server that serves static content, using Nginx
* A mariadb database running on Amazon RDS


Ian, who had much more experience than me with APIs, built the API server, and we collaborated on the database. I built the frontend using React.

There's nothing mind-blowingly cool happening anywhere in this project; the experience of standing up an entire web application was enough excitement for me. It was fun to get to play around with asynchronous loading on the frontend; I used a [Container Component](https://www.javascriptstuff.com/react-ajax-best-practices/#2-container-components) pattern for async loading content to render a placeholder while loading, then swap in the content loaded from the API server once it returned. This was very necessary, as the combination of Flask in development mode plus EC2 micro servers makes for a veeeery slow load time. 

I was also pretty proud of the overall look-and-feel of the app, which I designed in Figma before starting development. Here's a picture from the design:

![Msgr user interface picture](/assets/Home.png)

Overall, this was a fun project that taught me a lot about React development and infrastructure design.
