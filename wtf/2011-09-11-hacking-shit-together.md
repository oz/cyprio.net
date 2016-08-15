---
title: "Hacking shit together"
---

A few weeks ago, we got an Arduino board connected to the front door of the
office. The thing itself is hooked to a Seagate Dockstar stripped from every
of its plastic attributes. There's a decent looking box that we should wrap
around all the mess in a few days. But that's not the important thing really.
Let Apple care about apparences.

Once you have a system to open the door, you need an IRC bot lurking on your
#social-channel to control it. Check, thanks to
[Cinch](https://github.com/cinchrb/cinch).

Once you have got an IRC bot that everybody can interact with, many geeky
(more or less useful) modules start popping here and there: like having
weather reports, room-reservation notifications, food suggestions, etc.

A few weeks ago I also left my old Eee-PC at the office, installed a
pulseaudio service to be able to stream music to it, and hooked the thing to
speakers. No need to look for speakers' jacks in the evenings to play music
from a random laptop. Yay!

Wait... No! It sucks! What's better was giving the root password to the other
AF83 geeks, and see another plugin pop on the IRC bot to control the [LastFM
player daemon](https://github.com/jkramer/shell-fm) now running on the little
Eee. :)

This afternoon, I needed to take a break from the meticulous <s>slacking</s>
packing I was absorbed into. One way to _not_ pack your stuff, is taking it to
the office, and let it rot here. So I grabbed my Wii. While commuting, I
started thinking about how boring it was to have to get to a keyboard to issue
specific commands to a bot to love/hate Last-fm tracks: not good enough.

After a bit of coding, here it is: [the wiird](https://github.com/oz/wiird)!
The name's so stupid <s>I should check if it's not already used</s> it is
already used, so I ended up naming the thing
[wiisl](http://github.com/oz/wiisl) instead. A few lines of Python that reacts
to a Wiimote's events to launch programs. IMHO That's a hell lotta better than
talking to an IRC bot (and we got the choice anyway).

So yeah, basically we have built a radio, with a bluetooth remote control. But
it's geekier this way. Next step, putting the kinect that's rotting in a
corner of the office to good use!

