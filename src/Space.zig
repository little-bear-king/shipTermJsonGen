const std = @import("std");
pub const numStars: u64 = 1000001;
pub const Star = struct {
    id: u64,
    name: []u8,
    planet_count: u8,
    description: []u8,
    x: f32,
    y: f32,
    // neighbors: ?[]*Star = null,

    pub fn init(allocator: std.mem.Allocator, id: u64, name: []u8, planet_count: u8, x: f32, y: f32) !Star {
        const description = "A Star with some Properties";
        return .{ .id = id, .name = try allocator.dupe(u8, name), .description = try allocator.dupe(u8, description), .planet_count = planet_count, .x = x, .y = y };
    }

    pub fn format(
        self: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;

        try writer.print("star:\nname: \"{s}\"\tx: {d:1.1}, y: {d:1.1}\n", .{ self.name, self.x, self.y });
    }
    // pub fn addNeighbor() !void {
    //     std.debug.print("NOT IMPLEMENTED: addNeighbor()", .{});
    // }
    //
    // pub fn deinit(self: *Star) !void {
    //     self.allocator.free(self.name);
    //     self.planets.deinit();
    // }
};

pub const Planet = struct {
    allocator: std.mem.Allocator,
    name: []u8,
    star: *Star,
    dist: u8,

    pub fn init(allocator: std.mem.Allocator, name: []u8, star: *Star, dist: u8) !Planet {
        return .{ .allocator = allocator, .name = try allocator.dupe(u8, name), .star = star, .dist = dist };
    }

    pub fn deinit(self: *Planet) !void {
        self.allocator.free(self.name);
    }

    pub fn format(
        self: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;

        try writer.print("Planet:\nname: \"{s}\"\tStar: {d}, distance from star: {d}\n", .{ self.name, self.star.name, self.dist });
    }
};

pub fn generateStars(self: *std.StringHashMap(Star), alloc: std.mem.Allocator) !void {
    var random = std.rand.DefaultPrng.init(0);
    for (1..numStars) |i| {
        var buff: [15]u8 = undefined;
        const starName = try std.fmt.bufPrint(&buff, "Star{}", .{i});
        const stddev_x: f32 = 100.0;
        const stddev_y: f32 = 100.0;
        const x = random.random().floatNorm(f32) * stddev_x;
        const y = random.random().floatNorm(f32) * stddev_y;
        const id = @as(u64, i);
        const planet_count = random.random().uintLessThan(u8, 10);
        const starInit = try Star.init(alloc, id, starName, planet_count, x, y);
        try self.put(starInit.name, starInit);
        buff = undefined;
    }
}
