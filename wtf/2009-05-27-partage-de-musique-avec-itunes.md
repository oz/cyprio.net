---
title: "Partage de musique avec iTunes"
---

Les utilisateurs d'iTunes savent qu'il est facile d'exporter sa musique
facilement avec ses voisins de reseau. La plupart des "geeks" savent que ca se
fait grace a un protocole de communication appele "zeroconf", ou "Bonjour"
(Apple etait cense avoir un copyright sur le mot... mouarf). Cela-dit Apple a
invente un autre protocole appele DAAP qui s'appuie sur "Bonjour" pour
detecter les bibliotheques de musique voisines.

Il existe meme une implementation libre de serveur DAAP
([Firefly](http://www.fireflymediaserver.org/), anciennement mt-daap) qui
imite un iTunes de fort belle maniere, et qui me permet d'ecouter toute ma
bibliotheque tranquillement tant que je reste a portee de wifi/cable : a la
maison.

Une solution pour exporter la meme bibliotheque sur le net, pour en profiter
au bureau par exemple, c'est de forwarder les ports utiilses par DAAP vers une
adresse publique, puis d'utiliser un logiciel assez intelligent (Amarok,
Songbird, etc.) pour se connecter a l'adresse en question.

Comme iTunes se contente lui d'ecouter ce qui se passe en local, pas moyen de
lui dire de se connecter a une bibliotheque publique, il faut tricher. Avec
[RendezvouzProxy](http://ileech.sourceforge.net/index.php?content
=RendezvousProxy-News), ou [NetworkBeacon](http://www.chaoticsoftware.com/Prod
uctPages/NetworkBeacon.html) par exemple.

Si vous avez la flemme de telecharger des programmes en plus j'ai bricole un
script shell tout simple qui etablit un tunnel SSH entre votre serveur de
musique, et votre Mac. Ca s'appelle
[musicgate](http://cyprio.net/scripts/musicgate), et c'est une copie
engraissee de [cet autre script](http://the.taoofmac.com/space/DAAP) trouve
sur le net. Telechargez-le, editez le, lancez-le, et hop votre bibliotheque
lointaine s'invite dans iTunes.

... Cela-dit, je prefere quand meme [Songbird](http://getsongbird.com/) a
iTunes. :)

  *[DAAP]: Digital Audio Access Protocol

