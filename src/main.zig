const std = @import("std");
const HexDumper = @import("hexdump.zig").HexDumper;

var work_buffer: [0x400]u8 = undefined;

/// Write a hex dump until no more input from `stream` is available.
fn dumpUntilEnd(dumper: HexDumper, out: anytype, stream: anytype) anyerror!void {
    var offset: u64 = 0;

    var eof = false;
    while (!eof) {
        var bytes_read = try stream.read(&work_buffer);
        try dumper.write(out, offset, work_buffer[0..bytes_read]);

        offset += bytes_read;
        if (bytes_read < work_buffer.len) {
            eof = true;
        }
    }
}

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    const out = std.io.getStdOut().writer();

    var args = try std.process.argsAlloc(alloc);
    if (args.len < 2) {
        try out.print("Usage: zxd <file>\n", .{});
        return;
    }

    const dumper = HexDumper.default();

    const input_path = args[1];
    const source = if (std.mem.eql(u8, input_path, "-"))
        std.io.getStdIn().reader()
    else block: {
        const file = try std.fs.cwd().openFile(input_path, .{});
        break :block file.reader();
    };

    try dumpUntilEnd(dumper, out, source);

    std.process.argsFree(alloc, args);
    _ = gpa.deinit();
}
