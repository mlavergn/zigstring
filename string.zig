const std = @import("std");

pub const String = struct {
    _: []u8,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, value: []const u8) !String {
        const slice = try String._copy(allocator, value);
        return .{ ._ = slice, .allocator = allocator };
    }

    pub fn deinit(self: String) void {
        self.allocator.free(self._[0..self.len]);
        self.allocator = undefined;
        self._ = undefined;
    }

    pub fn count(self: String) u64 {
        return self._.len;
    }

    pub fn isEmpty(self: String) bool {
        return self._.len == 0;
    }

    pub fn hasPrefix(self: String, value: []const u8) bool {
        return std.mem.startsWith(u8, self._, value);
    }

    pub fn hasSuffix(self: String, value: []const u8) bool {
        return std.mem.endsWith(u8, self._, value);
    }

    pub fn firstIndex(self: String, value: []const u8) ?usize {
        return std.mem.indexOf(u8, self._, value);
    }

    pub fn contains(self: String, value: []const u8) bool {
        return self.firstIndex(value) != null;
    }

    pub fn description(self: String) void {
        std.debug.print("\nString[{d}]: {s}\n", .{ self._.len, self._ });
    }

    // static utility

    fn _copy(allocator: std.mem.Allocator, value: []const u8) ![]u8 {
        var slice = try allocator.alloc(u8, value.len);
        std.mem.copy(u8, slice, value);
        return slice;
    }

    // getter / setter

    pub fn string(self: String) []u8 {
        return self._;
    }

    pub fn setString(self: *String, value: String) !void {
        self.set(value._);
    }

    pub fn set(self: *String, value: []const u8) !void {
        const slice = try String._copy(self.allocator, value);
        self.allocator.free(self._);
        self._ = slice;
    }

    // mutation

    pub fn appendString(self: *String, value: String) !void {
        self.append(value._);
    }

    pub fn append(self: *String, value: []const u8) !void {
        const result = try std.mem.concat(self.allocator, u8, &[_][]const u8{ self._, value });
        self.allocator.free(self._);
        self._ = result;
    }

    pub fn reverse(self: String) void {
        std.mem.reverse(u8, self._[0..self._.len]);
    }

    pub fn lowercased(self: *String) !void {
        var result = try self.allocator.alloc(u8, self._.len);
        for (self._, 0..) |ch, i| {
            result[i] = if (ch >= 'A' and ch <= 'Z') ch + 32 else ch;
        }
        self.allocator.free(self._);
        self._ = result;
    }

    pub fn uppercased(self: *String) !void {
        var result = try self.allocator.alloc(u8, self._.len);
        for (self._, 0..) |ch, i| {
            result[i] = if (ch >= 'a' and ch <= 'z') ch - 32 else ch;
        }
        self.allocator.free(self._);
        self._ = result;
    }
};

test "string" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    var string = try String.init(allocator, "Hello world");
    string.description();

    try std.testing.expectEqualStrings("Hello world", string.string());

    string.reverse();
    try std.testing.expectEqualStrings("dlrow olleH", string.string());
    string.description();

    var expect = "Hello world foo";
    try string.set(expect);
    try std.testing.expectEqualStrings(expect, string.string());
    string.description();

    try string.append(" bar");
    try std.testing.expectEqualStrings("Hello world foo bar", string.string());
    string.description();

    try std.testing.expect(string.hasPrefix("Hello"));
    try std.testing.expect(string.contains("foo"));
    try std.testing.expect(!string.contains("what"));
    try std.testing.expect(string.hasSuffix("bar"));

    try string.set("HELLO wOrLd");
    try string.lowercased();
    try std.testing.expect(string.hasSuffix("hello world"));

    try string.uppercased();
    try std.testing.expect(string.hasSuffix("HELLO WORLD"));
}
