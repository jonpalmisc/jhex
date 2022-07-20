const std = @import("std");

/// Sanitize a byte for use in the ASCII preview.
fn asciiSanitize(byte: u8) u8 {
    if (byte >= 0x20 and byte < 0x7f) {
        return byte;
    }

    return '.';
}

/// Hex dump writer.
///
/// Configurable interface for formatting and writing hex dumps.
pub const HexDumper = struct {

    /// Show addresses/offsets before each line?
    show_address: bool,

    /// Show the ASCII preview at the end of each line?
    show_ascii: bool,

    /// Number of bytes in a column.
    column_width: u32,

    /// Number of bytes on a line; must be divisible by `column_width`, maximum of 64.
    line_width: u32,

    /// Separator to divide high and low part of addresses.
    address_separator: []const u8,

    /// Padding used between individual bytes.
    byte_separator: []const u8,

    /// Padding used between columns.
    column_separator: []const u8,

    /// Padding used around main content.
    margin_separator: []const u8,

    /// Determines if separators should be shown past the end of stream content.
    show_separators_past_end: bool,

    const Self = @This();

    /// Create a default `HexDumper`.
    pub fn default() Self {
        return Self{
            .show_address = true,
            .show_ascii = true,
            .column_width = 4,
            .line_width = 16,
            .address_separator = ":",
            .byte_separator = " ",
            .column_separator = "-",
            .margin_separator = " | ",
            .show_separators_past_end = false,
        };
    }

    /// Format and write `address` to `out`.
    ///
    /// The produced address may include a separator character between the high
    /// and low part of the address.
    fn writeAddress(self: Self, out: anytype, address: u64) anyerror!void {
        try out.print("{x:0>4}{s}{x:0>4}{s}", .{
            address >> 16,
            self.address_separator,
            address & 0xffff,
            self.margin_separator,
        });
    }

    /// Write an atom using the appropriate spacing.
    ///
    /// An "atom" refers to either a hex-formatted byte or two consecutive
    /// spaces used in place of an absent byte. This method exists such that
    /// column alignment is maintained in the absence of a value. Column padding
    /// is inserted at the appropriate intervals as determined by the row index.
    fn writeAtom(self: Self, out: anytype, atom: ?u8, index: u32) anyerror!void {
        if (atom) |byte| {
            try out.print("{x:0>2}", .{byte});
        } else {
            _ = try out.write("  ");
        }

        // No need to add specific padding if this is the last item in the line.
        if (index + 1 == self.line_width) {
            return;
        }

        // Choose the appropriate separator given the column index.
        var separator: []const u8 = undefined;
        if ((index + 1) % self.column_width == 0) {
            separator = self.column_separator;
        } else {
            separator = self.byte_separator;
        }

        // Draw the separator if data was just written OR if separators have
        // been configured to be drawn past the end of the stream; otherwise,
        // write spaces to fill the width of the missing separator.
        if (atom != null or self.show_separators_past_end) {
            _ = try out.write(separator);
        } else {
            for (separator) |_| {
                _ = try out.writeByte(' ');
            }
        }
    }

    /// Write a single hex dump line to `out`.
    fn writeLine(self: Self, out: anytype, address: u64, data: []const u8) anyerror!void {
        var ascii_preview: [64]u8 = undefined;
        var i: u32 = 0;

        if (self.show_address) {
            try writeAddress(self, out, address);
        }

        // Write each byte in the line and add it to the ASCII preview.
        while (i < data.len) {
            const byte = data[i];
            try writeAtom(self, out, byte, i);

            ascii_preview[i] = asciiSanitize(byte);
            i += 1;
        }

        // Write padding until the end of the line and fill the rest of the
        // ASCII preview if this line was smaller than a chunk.
        while (i < self.line_width) {
            try writeAtom(self, out, null, i);

            ascii_preview[i] = ' ';
            i += 1;
        }

        if (self.show_ascii) {
            _ = try out.write(self.margin_separator[0..]);
            _ = try out.write(ascii_preview[0..self.line_width]);
        }

        _ = try out.writeByte('\n');
    }

    /// Write a complete hex dump of `data` to `out`.
    ///
    /// The `address` parameter is treated as the starting address/offset of the
    /// data being printed and is shown if the `show_address` option is enabled.
    pub fn write(self: Self, out: anytype, start: u64, data: []const u8) anyerror!void {
        const chunks = data.len / self.line_width;
        var offset: u64 = 0;

        // Write all complete chunks.
        while (offset < chunks * self.line_width) {
            try writeLine(self, out, start + offset, data[offset .. offset + self.line_width]);
            offset += self.line_width;
        }

        // Write the final, partial line if there is one.
        if (offset < data.len) {
            try writeLine(self, out, start + offset, data[offset..]);
        }
    }
};
