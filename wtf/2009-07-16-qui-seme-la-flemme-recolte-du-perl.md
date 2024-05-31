---
title: "qui sème la flemme récolte du perl"
---

C'est tout bête, mais bien pratique parfois... qui me dit ce que fait ce petit
bout de perl en forme d'alias pour irssi? :)

    
    
    /alias chutchut /script exec use Irssi; $_->command("window close") for \
      
        ( grep { $_->{active}->{type} eq 'QUERY' } Irssi::windows() );

Perl caibon mangezan.

