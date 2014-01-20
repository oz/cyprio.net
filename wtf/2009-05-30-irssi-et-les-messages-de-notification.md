---
title: Irssi et les messages de notification...
---

J'utilise irssi pour presque tous les jours, pour tous mes besoins de
messagerie instantanee (merci [Bitlbee](http://www.bitlbee.org/)), ou tout
betement d'IRC. D'autant qu'IRC est le moyen de communication privilegie au
bureau... et aussi hors du bureau d'ailleurs.

Or mon client irssi tourne en permanence sur une petite machine a la maison
qui ne bouffe pas trop d'energie (pour ma "conscience verte"...), et je le
reattache au besoin avec screen dans un terminal... Classique. Du coup pour
avoir des notifications sous Linux ou Mac OS X, il faut ruser un peu puisque
le programme tourne sur une machine distante.

[La solution trouvee](http://thorstenl.blogspot.com/2007/01/thls-irssi-
notification-script.html) par d'autres que moi, est d'utiliser le script
[fnotify pour irssi](http://www.leemhuis.info/files/fnotify/fnotify), et a
l'aide d'un petit script sh, on peut facilement remonter les notifications
vers son bureau. Comme je suis sous Mac au bureau, et sous Linux a la maison,
j'ai ecrit vite fait une version qui fonctionne sous les deux environnements,
c'est [irssi_notify](http://cyprio.net/scripts/irssi_notify). Cadeau si ca
peut rendre service a quelqu'un d'autre. J'imagine qu'il y'a ensuite moyen de
ruser avec les `ProxyCommand` du client ssh pour le lancer automatiquement,
mais je vous laisse chercher ca de votre cote, bande de geeks.

_Edit :_ voir chez [neolao](http://blog.neolao.com/2009/05/30/75-messages-de-
notification) pour la suite. :)

