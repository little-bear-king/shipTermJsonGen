const std = @import("std");
const json = std.json;
const Space = @import("Space.zig");
const Galaxy = @import("graph.zig").GalaxyGraph;

pub fn generateJson(galaxy: Galaxy) !void {
    _ = try std.fs.cwd().makeDir("json");
    var file = try std.fs.cwd().createFile("json/stars.json", .{});
    defer file.close();

    // const options = std.json.StringifyOptions{
    //     .whitespace = .{
    //         .indent_level = 0,
    //         .indent = .{ .Space = 4 },
    //         .separator = true,
    //     },
    // };

    const options = std.json.StringifyOptions{};

    for (0..Space.numStars) |i| {
        var buf: [15]u8 = undefined;
        const key = try std.fmt.bufPrint(buf[0..], "Star{}", .{i});
        const StarObject = galaxy.nodes.getPtr(key);
        if (StarObject != null) {
            try std.json.stringify(StarObject, options, file.writer());
        }
        _ = try file.write("\n");
        if (i % 100 == 0) {
            std.debug.print("Struct #{}/{} Processed\n", .{ i, Space.numStars });
        }
        buf = undefined;
    }
}

test "json generateJson" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    var galaxy = Galaxy.init(alloc);
    try Space.generateStars(&galaxy.nodes, alloc);

    try generateJson(galaxy);
}
