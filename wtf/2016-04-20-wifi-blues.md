---
title: "Wifi blues"
---

Yesterday, with the guidance of my dear friend [jer0me][jer0me], I unscrewed
most of my trusty [X220][x220]. We proceeded to blow the dust out of it, and
change the CPU and GPU's thermal paste so that they would cool better, and be
less noisy as these things tend to be. I bought the machine 5 years ago, so it
was a welcome cleanup.

I should have taken a few pictures of the process because you don't get to gut
your laptop so often (well, I don't). I am sure you can find videos on youtube
with better explanations, and a less approximative English anyway.

The cool thing (see what I did here?) is that it is now a lot less noisy: the
heat is better dissipated, which means that the fan does not need to run so
often, nor so fast. I'm really happy about _this_.

# Fat paws

The part I'm _a lot_ less happy about is breaking a pin of the mini-PCI Express
slot where you normally plug the WLAN card. It means that I have a silent
laptop, with no wifi: back to Ethernet! Well, not entirely, since I have one of
those cheap USB dongles that has poor reception and slow transmission speeds.
Meh.

Actually, the X220 has a really nice hardware design, and has a second mini-PCI
slot. It remained unused because I did not buy the 3G-card option at the time.
“Problem solved!” we thought, but merely changing the WLAN card from one slot to
another does not work. The card is apparently not detected.

After a little reading around [ThinkWiki][thinkwiki], and [BIOS-Mods][biosmods],
it could very well be due to a software design. Lenovo limits the cards that can
be plugged in one or the other slot with a white-list: this way, they can
recommend third-party vendors (and charge them).

# Flashing what?

Luckily, the list of allowed hardware is saved inside the BIOS, and BIOS-es can
be flashed.

I will probably end up doing just that during my holidays in May. I spotted
patched BIOS images running wild on the Interwebs, without that annoying
white-list bug (thanks again Lenovo).

This could be just what I need _if_ the BIOS is the only thing that prevents the
laptop from running a WLAN card on the second slot.

On the other hand, it seems that the [Coreboot][coreboot-x220] project also
supports the X220 laptops nicely. Being a geeky creature, the idea of running a
free BIOS, to boot a [free OS][arch] makes me all warm and fuzzy inside.

I ~~want~~ need to run a WLAN card on the slot dedicated to WAN cards, so it
will involve some hacks anyway. I will try to write more about this soon-ish.
Meanwhile, I'll be using USB adapters. :p

[jer0me]: http://blog.jardinmagique.info/
[x220]: https://en.wikipedia.org/wiki/ThinkPad_X_Series#X220
[thinkwiki]: http://www.thinkwiki.org/
[biosmods]: https://www.bios-mods.com/
[coreboot-x220]: https://www.coreboot.org/Board:lenovo/x220
[arch]: http://archlinux.org/
