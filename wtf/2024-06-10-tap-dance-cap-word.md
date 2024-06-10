---
title: Tap dance and Caps word
---

If you're into mechanical keyboards, you probably know about Tap
dances and Caps words already. If not, well these are two features of
[QMK][qmk]:

- a *tap dance* allows you to remap rapid successive taps on a key to a
  different function ([ref](https://docs.qmk.fm/features/tap_dance)), and
- *caps word* is a function that turns on CAPS but only for the next
  word you'll type ([ref](https://docs.qmk.fm/features/caps_word)).

As the Tap dance docs clearly state, a Tap dance can trigger basic key
codes only: meaning letters, modifiers, etc., but *not* Caps words. I
briefly experimented on my Preonic, trying to get the backtick key to
turn on Caps word, using the basic Tap dance macros, but it failed to
trigger anything. Frustrating.

Either I'm holding it wrong, or the docs are correct. Both things are
equally possible. :)

But fear not dear reader! Of course you *can* trigger Caps word from
a Tap dance. You'll just need to write a bit of C, to customize the
board's keymap.

Let's look into this here.

First, change `rules.mk` to enable both features, adding:

```
CAPS_WORD_ENABLE = yes
TAP_DANCE_ENABLE = yes
```

I also like to have an explicit tapping-term, which defines how long
the board waits for your taps to decide what to do next... I'm not sure
whether that's a good definition, but that's how my brain explains it.

Change `config.h` to define this as needed, for example:

```
#define TAPPING_TERM 200
```

This means you have 200ms to double-tap your keys. This tapping term is
also shared with Tap-or-hold custom keycodes, so maybe you will need to
figure out per-key tap terms later. YMMV.

The meat of this little hack lives inside `keymap.c`.

Let's add a `cur_dance` helper that will tell use where we're at in our
Tap dance:

```
// Some Tap Dance states
enum {
	SINGLE_TAP = 1,
	SINGLE_HOLD = 2,
	DOUBLE_TAP = 3,
	DOUBLE_HOLD = 4
};

int cur_dance(tap_dance_state_t *state) {
	if ((state->count == 1) && (!state->pressed)) return SINGLE_TAP;
	else if ((state->count == 1) && (state->pressed)) return SINGLE_HOLD;
	else if ((state->count == 2) && (!state->pressed)) return DOUBLE_TAP;
	else if ((state->count == 2) && (state->pressed)) return DOUBLE_HOLD;

	// magic number. At some point this method could expand to work for more presses
	else return 5;
}
```

The logic is pretty simple. For our use case, we also need 2 functions
to hook in the *finished* and *reset* callbacks of a Tap dance. Let's
add these next:

```
// Tap-dance is over.
void dance_cw_finished(tap_dance_state_t *state, void *user_data) {
	int dance = cur_dance(state);

	if (dance == SINGLE_TAP) {
		register_code(KC_GRV); // single tap -> backtick key
		reset_tap_dance(state);
		return;
	}
	if (dance == DOUBLE_TAP) {
		caps_word_on(); // double tap -> caps words
		return;
	}
}

// Clear the tap-dance floor.
void dance_cw_reset(tap_dance_state_t *state, void *user_data) {
	if (state->count == 1) {
		unregister_code(KC_GRV); // Stop sending backtick.
	}
}
```

What's left is some boiler-plate to register our handlers as a Tap
dance, named `TD_GRV_CW`, which is a pretty bad name if you try to
pronounce it. It did made sense at the time:

```
// Backtick or Caps-word tap-dance.
enum {
	TD_GRV_CW,
};

tap_dance_action_t tap_dance_actions[] = {
	// Tap once for ` (backtick), twice for Caps-word.
	[TD_GRV_CW] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, dance_cw_finished, dance_cw_reset),
};
```

On your board configuration, you can replace `KC_GRV` with
`TD(TD_GRV_CW)`, then compile and flash as usual, now double tapping the
backtick key will activate *Caps-word*, rejoice.

Done?

Dancing is nice(r) with music. My rev3 Preonic has a (~~possibly~~
annoying) speaker. Wouldn't it be nice to play a few notes as you
activate a tap dance? I'm sure everybody around would love it.

Also, what if I want to have a Tap dance on a different key like *Left
Control* or something?

So many possibilities... Maybe I'll write about that here next, in a
couple of years if this site's post frequency is stable.

Thanks for reading.

[qmk]: https://qmk.fm
