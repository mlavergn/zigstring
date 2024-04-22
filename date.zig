const std = @import("std");

pub const Date = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !Date {
        return .{ .allocator = allocator };
    }

    pub fn deinit(self: Date) void {
        self.allocator.free(self._);
        self.allocator = undefined;
    }

    pub fn epoch(self: Date) i64 {
        _ = self;
        return std.time.timestamp();
    }

    pub fn description(self: Date) void {
        std.debug.print("\nEpoch: {}\n", .{self.epoch()});
    }
};

test "date" {
    const allocator = std.testing.allocator;
    var date = try Date.init(allocator);
    date.description();
}
