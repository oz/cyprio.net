---
title: "Parsing locations in Aguaxaca"
---

The little [Aguaxaca](https://agua.cypr.io) project has been humming
along for a month now. Ingesting data as it comes, and I decided to take
30 minutes to take a look at the mess I'm now in. \*starts panicking\*

Lots of things here are mostly for my own sake. Sorry if that's noise in
your RSS reader.

# Where were we?

Currently, I get a list of water-delivery spots (locations) from
"@SOAPA_Oax"'s images on X/Twitter, and store lots of stringy data as a
result. I'm gathering data, so the schema is 💩 on purpose. I should
probably ~~trash~~ alter it once I'm more confident about the shape of
the "source material", and how to parse this stuff properly.

For each new delivery report, I create a new `deliveries` record with
the location name as a string. Lots of duplication. This will obviously
not scale, but it's fine for the initial exploration phase and volume of
data. The goal is to build a clean directory of locations and child
locations, and store deliveries with a foreign key from locations for
example...

# Where we got

This is a small overview of locations names, after ±1 month of
collecting raw data. This should be a full panorama of all the locations
(or 99% of them, hopefully?) that get water deliveries in the city of
Oaxaca. Yay. 🎉

You can follow along on [agua.cypr.io](https://agua.cypr.io),
just to see how bad things are, and feel some Schadenfreude at my
expense.

We can already see that locations are further divided in
"sub-locations". For example the *Infonavit* location includes *1a
etapa*, *2a etapa*, (...), each with distinct delivery schedules, most
of the time. Oh boy. 🥲

The same pattern is repeated for the *Guadalupe Victoria* location,
and many others. For all these, we could have a simple parent-child
relation. For example, the location *Infonavit* would have several
sub-locations like *1a etapa*, *2a etapa*, etc. Sub-locations are
optional, and sometimes a "parent" location will also be advertised in a
delivery schedule, without more details. I mean, it could be "Yay!
everyone gets water today!", or "meh... typing these names is annoying".

All locations have a distinct *type*, like *colonia*, *ejido*,
*fraccionamiento*, *unidad*, etc. This is usually coherent, good. We
can keep that as is, or spawn a separate table. I doubt we'll see more
than 10 different location types though, so it's more about DB size and
performance than anything (I mean storing a foreign-key integer instead
of a string).

So, what do we know?

1. As I mentioned, lots of location names have sub-locations. These are
usually appended between parens in the delivery announcement.
consistency here.
2. The guiding rule could be that the "top" location is whatever is
*not* inside parens, and then extract details about sub-locations to be
as thorough as possible.
3. I should probably capitalize/downcase all names to get a semblance of
4. Different sub-locations can get deliveries on different days, so we
do need the granularity of location and sub-location.

The parent-child relation would still allow some sort of tree-like
structure, and granularity if we want to make something out of the data,
for example send notifications when a specific sub-location gets water,
or is likely to get water in the coming days.

# Show us the data

Here's some select data for a few locations, if you wanted a more
concrete overview.

## 📍 **Yalalag (parte baja)**

Location would be "Yalalag", with a sub-location like "Parte Baja".

## 📍 **Reforma (parte baja)**, and **Reforma (parte alta)**

Location would be "Reforma", with 2 sub-locations like "Parte Alta", and "Parte Baja".

Now, some less obvious ones, that would require a better parser.

## 📍 **Circuito Panorámica del Fortín (sectores 1, 2 y 3)**

Location would be "Circuito Panorámica del Fortín", with 3 sub-locations here:

- **Sector 1**,
- **Sector 2**, and
- **Sector 3**.

## 📍 **Circuito Madero (de la Iglesia del Ex Marquezado a la Av. Tecnológico)**

Location: **Circuito Madero**

Sub-location: **de la Iglesia del Ex Marquezado a la Av. Tecnológico** 

These are street or landmarks names, no use in trying to parse this further.

## 📍For the **Guadalupe Victoria** location, we get a lot of variants:

- Guadalupe Victoria (sectores 3 y 4 parte baja)
- Guadalupe Victoria (sector 5 parte baja)
- Guadalupe Victoria (sectores 3, 4, 5 y 6 parte alta)
- Guadalupe Victoria (sector 6 parte baja)
- Guadalupe Victoria (sección Oeste sector 2)
- Guadalupe Victoria (2ª sección Oeste sector 1)
- Guadalupe Victoria (sector 1, 2ª sección Oeste)

It looks like we have a bunch of "sectors". Some sectors have additional distinctions like "parte alta" and "parte baja". From this list, I gather:

Location: **Guadalupe Victoria**
Sub-locations:

- Sector 1
- Sector 2
- (...)
- Sector 6
- sección Oeste
- 2ª sección Oeste

💭 I'd auto-create sub-locations by parsing the text (splitting
on commas, "y" conjunctions, etc.), but there's probably not much
use trying to go beyond one level: meaning "sector 6", "sector 6
parte baja" and "sector 6 parte alta" are 3 sub-locations of "Guadalupe
Victoria".

## 📍 **Dolores**

- Dolores (zona Oriente parte baja)
- Dolores (sector Poniente parte baja)
- Dolores (sector Poniente parte alta)
- Dolores (parte baja)

Location: **Dolores**

Sub-locations (so far...):

- Zona Oriente Parte Baja
- Sector Poniente Parte Baja
- Sector Poniente Parte Alta
- Parte Baja

I guess some days you write "sector", and some other days "zona". It's probably the same thing. Just great.

## 📍América Sur

We get the usual "parte alta" and "parte baja" sub-locations, but with a small twist:

- América Sur (parte baja)
- América Sur (parte baja y alta)

Location: **América Sur**

Sub-locations: **Parte Baja**, and **Parte Alta**

(Yes, there's also América *Norte*, it's a different location.)

## 📍San Juan Chapultepec

San Juan Chapultepec was both advertised as *agencia* when it comes without sub-locations, and a *colonia* when it comes with several sub-locations. Let's focus on the latter here.

- San Juan Chapultepec y sus Barrios
- San Juan Chapultepec (parte baja)
- San Juan Chapultepec (parte media)
- San Juan Chapultepec (parte alta y sus Barrios)

That last one is 🏆. I guess we could have this hierarchy:

Location: **San Juan Chapultepec**

Sub-locations: "Parte Baja", "Parte Media", "Parte Alta", and well… "Barrios" 😑.

This breaks the assumption that sub-locations are always between
parentheses. Damn it.

## 📍Centro

The central district locations are also all over the
place. Here's a list of locations we get [searching for
"centro"](https://agua.cypr.io/?name=centro):

- Centro Sur y Medio (de la calle Abasolo a Periférico Sur)
- Centro Sur y Medio (de la calle Abasolo a Periférico Sur)
- Centro Sur Poniente
- Centro Sur Poniente
- Centro Norte (de Constitución a Calzada Niños Héroes de Chapultepec)
- Centro Norte (de Constitución a Calzada Niños Héroes de Chapultepec)
- Centro Sur Poniente (sector Huzares)
- Centro Medio (de calle Colón a Abasolo)

Locations:

- **Centro Sur**,
- **Centro Norte**,
- **Centro Medio**, and probably
- **Centro Sur Poniente**.

Sub-Locations (again street names and landmarks):

- de la calle Abasolo a Periférico Sur
- de Constitución a Calzada Niños Héroes de Chapultepec
- sector Huzares
- de calle Colón a Abasolo

## 📍Volcanes

Here's a list of locations names we've seen:

- Volcanes (sector 3 zona norte)
- Volcanes (sectores 4 y 5)
- Volcanes (sector 1 parte baja)
- Volcanes (sector 1 parte baja)
- Volcanes (sectores 4 y 5)
- Volcanes (zona Norte, sector 3)

Location: **Volcanes**

Sub-Locations:

- Sector 1 Parte Baja
- Sector 3
- Sector 3 Zona Norte
- Sector 4
- Sector 5
- Zona Norte

In this case as with others, I wonder whether these are actually 3
different locations: "sector 3", "sector 3 zona norte", and "zona
norte"... The delivery schedules mention both at different dates:

- Aug 27: Volcanes (sector 3 zona norte)
- Aug 1st: Volcanes (zona Norte, sector 3)

Given the delivery interval this could be a single location, where the
publisher used a different name format. 🤷‍♂️

# Next steps of my Now You're An ETL Programmer phase

1. Write a parser to extract the sub-locations, from location "names".
2. Store locations and sub-locations properly in a `locations` table.
3. Cleanup and migrate the existing data.
4. Make a useful "product" (plot delivery dates per location(s), provide
   notifications, etc.).

If you've read through all of this, sorry there's no big insight. Just
my brain trying to map real world stuff to bytes. Part of me wants to
see if I can offload task #1 to an LLM: with a sufficiently intricate
prompt, it could work, but I'm not sure I can trust the machine here,
because the text is sometimes quite ambiguous. Being surprised would be
nice, because the alternative is a hand-written parser with lots of unit
tests.
