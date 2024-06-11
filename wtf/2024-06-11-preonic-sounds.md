---
title: Random Preonic sounds
---

I kind of [warned you][tap-dance-post] about making sounds with the
Preonic keyboard, because 80s beeps will never go out of fashion, and
these clicky switches aren't noisier enough anyway. Check [the previous
post][tap-dance-post] if you need to, this is a follow up.

Playing sounds is very simple with QMK, thanks to the cute `PLAY_SONG`
macro, to make the board play very geeky boops.

Since we started from the default keymap and config for the v3 preonic,
we already have audio enabled on the board. There's nothing else to
configure: as far as I know we can already beep to our heart's content.

In QMK, we have a C macro `SONG(list of notes)`. It gives us back an
array, that we can feed to `PLAY_SONG` to actually play sounds. Of
course *these are C macros*, so we can't really inline things like this:
`PLAY_SONG(SONG(TADAAA))`. NOPE!

No big deal. We'll use an intermediate variable to store the "song",
and feed that to `PLAY_SONG`. For our purpose, let's reuse a song from
`song_list.h` ([this file][song-list]). Writing your own stuff is fun,
but it'll keep this post short.

I'll use the `CAPS_LOCK_ON_SOUND` (and off) sounds, which seem
half-appropriate.

Let's declare these two songs in `keymap.c`:

```c
#ifdef AUDIO_ENABLE
static float caps_word_on_song[][2] = SONG(CAPS_LOCK_ON_SOUND);
static float caps_word_off_song[][2] = SONG(CAPS_LOCK_OFF_SOUND);
#endif
```

Now, we could update the previous post's tap-dance callback to play
sounds, but the caps-word feature is more ergonomic than that. Just
use the `caps_word_set_user` [callback][qmk-docs]. It gets a "bool" to
indicate the current state. Again, in `keymap.c`:

```c
#ifdef AUDIO_ENABLE
void caps_word_set_user(bool active) {
	if (active) {
		PLAY_SONG(caps_word_on_song);
	} else {
		PLAY_SONG(caps_word_off_song);
	}
}
#endif
```

The whole `#ifdef` wrapping isn't essential here, but the function
only matters when audio is enabled in my case. YMMV.

That's it. See, THAT WAS NOT THAT HARD. Sorry, just testing. :)

[tap-dance-post]: ./2024-06-10-tap-dance-cap-word.html
[song-list]: https://github.com/qmk/qmk_firmware/blob/8b5cdfabf5d05958a607efa174e64377d36e4b64/quantum/audio/song_list.h
[qmk-docs]: https://docs.qmk.fm/features/caps_word#representing-caps-word-state
