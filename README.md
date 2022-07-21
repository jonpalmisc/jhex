# Jhex

Jhex is a simple CLI tool and Zig library for creating and formatting hex dumps.

```
0007:be20   30 e8 79 28  e0 36 1d c5  81 6e 1b 9c  dc 7e a2 64   0.y(.6...n...~.d
0007:be30   43 0d b3 03  05 fb 6d 11  f9 31 83 e8  07 54 0a ae   C.....m..1...T..
0007:be40   39 d4 aa 4c  fe 6f 26 02  44 ce 41 6d  f8 27 6e 4b   9..L.o&.D.Am.'nK
0007:be50   7f e2 9b fd  d7 13 fe b4  03 22 8c 03  53 49 78 f3   ........."..SIx.
0007:be60   10 38 ca 8a  94 ce ac 79  45 bd 53 93  94 ed 37 92   .8.....yE.S...7.
0007:be70   fc cd 67 77  f1 2b dd 54  16 49 b5 c4  20 88 c5 70   ..gw.+.T.I.. ..p
0007:be80   ea a2 c2 4f  a6 54 0d 35  2d ba 27 6d  c9 56 69 b1   ...O.T.5-.'m.Vi.
0007:be90   dc 40 9d 4d  ce c7 36 7b  aa 25 fc c4  55 35 e2 32   .@.M..6{.%..U5.2
0007:bea0   3f 99 d2 09  b6 52 74 66  1c 24 a2 af  d2 82 22 3e   ?....Rtf.$....">
0007:beb0   c5 1b 34 4a  ef 16 8b b7  46 09 0b 55  b2 45 5c 06   ..4J....F..U.E\.
0007:bec0   77 f5 7d 7f  17 28 bc a7  3d a3 88 42  52 ff 89 f3   w.}..(..=..BR...
0007:bed0   97 d1 0f 9a  06 b0 e7 57  fb f7 10 e1  8c 87 d3 81   .......W........
0007:bee0   87 9e 76 5b  10 d5 94 7e  56 03 84 57  95 f6 52 3d   ..v[...~V..W..R=
0007:bef0   e5 19 ef 7a  af 85 0d 26  d4 2a f0 50  fc 97 a1 d8   ...z...&.*.P....
0007:bf00   4b 01 9b 0d  b3 8f 79 c2  63 31 c8 c6  4a 6e 33 4a   K.....y.c1..Jn3J
0007:bf10   6f f0 3e 64  d5 e0 74 fd  03 75 d2 06  bb 31 81 48   o.>d..t..u...1.H
0007:bf20   bf c8 ce c0  3d aa d5 be  00 0b 2f c0  e8 9e 15 1b   ....=...../.....
0007:bf30   c4 fe 3c 9c  9e bb 6b 5c  8f 90 21 04  b4 94 49 33   ..<...k\..!...I3
0007:bf40   3b c9 36 9d  2a 9c 8d 3e  f4 95 35 d3  fe 94 fc 95   ;.6.*..>..5.....
0007:bf50   f3 a2 03 07  16 16 a0 aa  a8 6f 18 97  8d 47 77 90   .........o...Gw.
0007:bf60   36 64 50 de  9a 3e 52 65  72 00 c5 69  eb 22 66 8a   6dP..>Rer..i."f.
0007:bf70   55 bd 9a 22  16 91 66 ce  8d 74 94 db  62 d9 86 cf   U.."..f..t..b...
0007:bf80   28 f7 9e c1  58 7c 87 a9  1e b5 0a 2f  e9 9e 3c e7   (...X|...../..<.
0007:bf90   47 b0 3b a2  00 00 00 00                             G.;.....
```
> A portion of the output of Jhex dumping itself.

## Usage

### CLI Tool

Running `zig build` will produce the `jhex` CLI tool. It works similarly to the
classic `xxd` program.

### Zig Library

All of the code for creating hex dumps is contained in `src/hexdump.zig`. Easy
integration with other Zig programs has been a design goal from the start. To
use, simply build `src/hexdump.zig` with your project and use the `HexDumper`
interface. See `src/main.zig` for a usage example.

## License

Copyright &copy; 2022 Jon Palmisciano; licensed under the BSD-3-Clause license.
