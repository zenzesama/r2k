# kaku

A small terminal text editor with a built-in Japanese input method.
Type romaji, press space, get kanji.

Version 0.1

## Install

Needs a C compiler, make, curl and iconv.

    ./install.sh

Installs to `~/.local/bin/kaku` and `~/.local/share/kaku`.
Make sure `~/.local/bin` is in your PATH.

## Use

    kaku [file]

    Ctrl-J        switch between ENGLISH and 日本語
    Space         convert (日本語 mode)
    Left / Right  previous / next candidate
    Enter         accept
    Backspace     back to kana
    Ctrl-S        save
    Ctrl-Q        quit

The mode is shown in the bottom right of the status bar.
Candidates are kanji first, then hiragana, then katakana.

## Limits

- Whole-word conversion only. No verb or adjective endings (okurigana).
- Linux only, tested on one terminal.

## Credits

- Editor core follows kilo by antirez (BSD-2) and the snaptoken tutorial.
- Lua 5.5, vendored in `vendor/lua` (MIT).
- Dictionary: SKK-JISYO.L from skk-dev/dict (GPL v2+). Downloaded at
  install time, not included in this repo.
