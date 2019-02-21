---
name: Shadowrun Dice Roller
short_description: A tool for generating dice pools rolls based on the Shadowrun rules
github: https://github.com/jemisonf/dice_roller
layout: project
---

Some background: Shadowrun is a cyperpunk pencil-and-paper role playing game, a little like Dungeons and Dragons. It has a lot of differences from D&D though; one that I ran into pretty early is how dice rolls work. In both games, you frequently use a dice rolls to figure out if your character will succeed or fail at an action. In D&D, you roll one die with a specified number of sides, usually 20 sides for an action, add a modifier, and check if you meet a "DC" value, which determines if you succeed. In shadowrun, you have a variably-sized "dice pool" of six sided dice, and you check for success in an action by rolling all of them, and counting the number of 5s and 6s that you rolled (called hits). This is kind of a pain when you have a large dice pool, and because I only own a few six sided dice I ended up using online "dice rollers" that automatically generate your dice pool rolls for you.

The problem with these dice rollers is that a lot of them are really bad; they're either slow, or really badly designed, or both. So I decided to make my own, with three goals:

1. Have a simple, clean look
3. Be fast and lightweight
2. Be mobile and desktop friendly.

1 and 2 were top priorities, and 3 was a stretch goal. You can see the result [here](https://fgj.codes/dice_roller). 1 and 2 definitely succeeded; the site scores a 99 on a Lighthouse performance audit, and the visible elements have been reduced to the bare essentials. 3 is mostly true; the site is usable on mobile, but the controls for selecting number of dice could use some work. I'm also proud to say that the site shows up on the first page of google when you search ["Shadowrun dice roller"](http://lmgtfy.com/?q=shadowrun+dice+roller). Here's a screenshot of the app:


![Shadowrun dice roller screenshot](/assets/shadowrun-dice-roller.png)
