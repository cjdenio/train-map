const std = @import("std");
const Io = std.Io;
const msgpack = @import("msgpack");

const ArduinoRouter = @import("./arduino_router.zig").ArduinoRouter;
const led_map_pkg = @import("./led_map.zig");
const Led = led_map_pkg.Led;
const build_led_map = led_map_pkg.build_led_map;

const Station = struct {
    id: []u8,
};

const Vehicle = struct {
    id: []u8,
    nearest_station: Station,
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

const App = struct {
    router: ArduinoRouter,
    client: std.http.Client,
    current_frame: u1 = 0,
    led_map: *const std.StaticStringMap(Led),

    fn run_loop(self: *App, allocator: std.mem.Allocator, io: std.Io) !void {
        const feed = try get_vehicles(&self.client, allocator);
        defer feed.deinit();

        var regs: [0xB4]u8 = @splat(0x00);

        for (feed.value.vehicles) |vehicle| {
            const thing = self.led_map.get(vehicle.nearest_station.id);

            if (thing) |value| {
                std.debug.print("train at {s}, setting reg {} to {}\n", .{ vehicle.nearest_station.id, value.column, value.row });
                regs[value.led_reg()] |= (@as(u8, 1) << (value.column));
                if (regs[value.pwm_reg()] == 0) {
                    regs[value.pwm_reg()] = 50;
                } else {
                    regs[value.pwm_reg()] = 127;
                }
            }
        }

        try self.router.notify(allocator, "clearFrame", &.{msgpack.Payload.intToPayload(~self.current_frame)});

        for (regs, 0..) |value, reg| {
            try self.router.notify(allocator, "setRegister", &.{
                msgpack.Payload.uintToPayload(~self.current_frame), // page
                msgpack.Payload.uintToPayload(reg), // register
                msgpack.Payload.uintToPayload(value), // value
            });
            try io.sleep(.fromMilliseconds(5), .real);

            std.debug.print("{x} IS {x}\n", .{ reg, value });
        }

        try self.router.notify(allocator, "displayFrame", &.{msgpack.Payload.intToPayload(~self.current_frame)});

        self.current_frame = ~self.current_frame;
    }
};

pub fn main(init: std.process.Init) !void {
    const led_map = build_led_map();

    var router = try ArduinoRouter.connect(init.io);
    defer router.deinit();
    var client: std.http.Client = .{ .allocator = init.arena.allocator(), .io = init.io };
    defer client.deinit();

    var app: App = .{ .router = router, .client = client, .led_map = &led_map };

    try router.notify(init.arena.allocator(), "clearFrame", &.{msgpack.Payload.intToPayload(0)});
    try router.notify(init.arena.allocator(), "displayFrame", &.{msgpack.Payload.intToPayload(0)});

    while (true) {
        var arena = std.heap.ArenaAllocator.init(init.gpa);
        const allocator = arena.allocator();
        defer arena.deinit();

        app.run_loop(allocator, init.io) catch |e| std.debug.print("ERROR OCCURED: {s}\n", .{@errorName(e)});

        try init.io.sleep(.fromSeconds(5), .real);
    }
}
