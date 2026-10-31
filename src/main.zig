const std = @import("std");
const Io = std.Io;

const Vehicle = struct {
    id: []u8,
};

const Feed = struct {
    vehicles: []Vehicle,
};

fn get_vehicles(client: *std.http.Client, allocator: std.mem.Allocator) !std.json.Parsed(Feed) {
    var response: [10000]u8 = undefined;

    var writer = std.Io.Writer.fixed(&response);

    const resp = try client.fetch(.{
        .location = .{ .url = "http://uta-insecure.host.calebdenio.me/api.json?route_types=0" },
        .response_writer = &writer,
    });
    if (resp.status != .ok) {
        return error.RequestFailed;
    }

    const parsed = try std.json.parseFromSlice(Feed, allocator, writer.buffer[0..writer.end], .{
        .ignore_unknown_fields = true,
    });

    try writer.flush();

    return parsed;
}

pub const std_options: std.Options = .{
    .http_disable_tls = true,
};

pub fn main(init: std.process.Init) !void {
    var client: std.http.Client = .{ .allocator = init.arena.allocator(), .io = init.io };
    defer client.deinit();

    while (true) {
        var arena = std.heap.ArenaAllocator.init(init.gpa);
        const allocator = arena.allocator();
        defer arena.deinit();

        const feed = try get_vehicles(&client, allocator);
        defer feed.deinit();

        for (feed.value.vehicles) |vehicle| {
            std.debug.print("new vehicle: {s}\n", .{vehicle.id});
        }

        try init.io.sleep(.fromSeconds(1), .real);
    }
}
