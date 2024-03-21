const std = @import("std");
const String = @import("string.zig").String;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    var string = try String.init(allocator, "Hello world");
    string.description();

    try string.append(", how are you");
    string.description();

    try string.uppercased();
    string.description();
}
