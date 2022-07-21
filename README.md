# Jhex

Jhex is a simple CLI tool and Zig library for creating and formatting hex dumps.

## Usage

### CLI Tool

Running `zig build` will produce the `jhex` CLI tool. It works similarly to the
classic `xxd` program, just with less options.

### Zig Library

All of the code for creating hex dumps is contained in `src/hexdump.zig`. Easy
integration with other Zig programs has been a design goal from the start. To
use, simply build `src/hexdump.zig` with your project and use the `HexDumper`
interface. See `src/main.zig` for a usage example.

## License

Copyright &copy; 2022 Jon Palmisciano; licensed under the BSD-3-Clause license.
