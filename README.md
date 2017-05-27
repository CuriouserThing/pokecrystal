# Timeless Crystal

This fork of pret's Pokémon Crystal disassembly is designed as a new base for modding Crystal, with certain advantages (and one glaring disadvantage) over the original.

The defining change is the use of [**MBC5**][mbc5] instead of [**MBC3**][mbc3], which means:
- 4 MB of ROM instead 2 MB (nominally, MBC5 supports 8 MB, but not reliably in practice).
- 128 KB of SRAM instead 32 KB.
    - Bill's PC can now store the Gen VII standard of 30 mons per box within 32 boxes.
- No real-time clock!
    - In place of the RTC, Timeless Crystal uses a **world clock** which updates at a variable rate [wiki documentation forthcoming!]

This project is still in its infancy. Check out [**the wiki**][wiki] for a roadmap of what's to come.

## Note

Set up the repository per usual via [**INSTALL.md**](INSTALL.md), but note that this repo is configured to use the latest release of RGBDS, [**v0.3.1**][rgbds]. **v0.3.0** and below may not work.

The MD5 checksum of `pokecrystal.gbc` at commit `8e77335ce39004ea90977f985098055b27dac253` is `AE51B592A9912CDCD8826F7BC440B5FC`.

[rgbds]: https://github.com/rednex/rgbds/releases/tag/v0.3.1
[mbc3]: http://gbdev.gg8.se/wiki/articles/Memory_Bank_Controllers#MBC3_.28max_2MByte_ROM_and.2For_32KByte_RAM_and_Timer.29
[mbc5]: http://gbdev.gg8.se/wiki/articles/Memory_Bank_Controllers#MBC5_.28max_8MByte_ROM_and.2For_128KByte_RAM.29
[wiki]: https://github.com/TheMostCuriousThing/TimelessCrystal/wiki/The-future
