const std = @import("std");
const Io = std.Io;
const msgpack = @import("msgpack");

const ArduinoRouter = @import("./arduino_router.zig").ArduinoRouter;

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

const Led = struct {
    row: u3,
    column: u3,
};

pub fn main(init: std.process.Init) !void {
    var led_map: std.hash_map.StringHashMap(Led) = .init(init.arena.allocator());

    try led_map.put("18377", .{ .column = 0, .row = 6 }); // Library Station
    try led_map.put("18378", .{ .column = 0, .row = 6 }); // Library Station
    try led_map.put("18379", .{ .column = 0, .row = 5 }); // Trolley Station
    try led_map.put("18380", .{ .column = 0, .row = 5 }); // Trolley Station
    try led_map.put("18383", .{ .column = 0, .row = 3 }); // Stadium Station
    try led_map.put("18384", .{ .column = 0, .row = 3 }); // Stadium Station
    try led_map.put("18397", .{ .column = 4, .row = 0 }); // Midvale Fort Union Station
    try led_map.put("18398", .{ .column = 4, .row = 0 }); // Midvale Fort Union Station
    try led_map.put("18399", .{ .column = 4, .row = 1 }); // Midvale Center Station
    try led_map.put("18400", .{ .column = 4, .row = 1 }); // Midvale Center Station
    try led_map.put("18401", .{ .column = 4, .row = 2 }); // Historic Sandy Station
    try led_map.put("18402", .{ .column = 4, .row = 2 }); // Historic Sandy Station
    try led_map.put("18403", .{ .column = 4, .row = 4 }); // Sandy Civic Center Station
    try led_map.put("18404", .{ .column = 4, .row = 4 }); // Sandy Civic Center Station
    try led_map.put("19166", .{ .column = 0, .row = 2 }); // University South Campus Station
    try led_map.put("19167", .{ .column = 0, .row = 2 }); // University South Campus Station
    try led_map.put("19168", .{ .column = 0, .row = 1 }); // Fort Douglas Station
    try led_map.put("19169", .{ .column = 0, .row = 1 }); // Fort Douglas Station
    try led_map.put("19170", .{ .column = 0, .row = 0 }); // University Medical Center
    try led_map.put("19171", .{ .column = 0, .row = 0 }); // University Medical Center
    try led_map.put("21225", .{ .column = 4, .row = 3 }); // Sandy Expo Station
    try led_map.put("21226", .{ .column = 4, .row = 3 }); // Sandy Expo Station
    try led_map.put("21761", .{ .column = 2, .row = 2 }); // Salt Lake Central Station
    try led_map.put("21762", .{ .column = 2, .row = 0 }); // Planetarium Station
    try led_map.put("21763", .{ .column = 2, .row = 1 }); // Old Greektown Station
    try led_map.put("21799", .{ .column = 2, .row = 2 }); // Salt Lake Central Station
    try led_map.put("21800", .{ .column = 2, .row = 0 }); // Planetarium Station
    try led_map.put("21801", .{ .column = 2, .row = 1 }); // Old Greektown Station
    try led_map.put("22620", .{ .column = 6, .row = 0 }); // Daybreak Parkway Station
    try led_map.put("22621", .{ .column = 5, .row = 7 }); // South Jordan Parkway Station
    try led_map.put("22622", .{ .column = 5, .row = 7 }); // South Jordan Parkway Station
    try led_map.put("22623", .{ .column = 5, .row = 6 }); // 5600 W. Old Bingham Hwy Station
    try led_map.put("22624", .{ .column = 5, .row = 6 }); // 5600 W. Old Bingham Hwy Station
    try led_map.put("22625", .{ .column = 5, .row = 5 }); // 4800 W. Old Bingham Hwy Station
    try led_map.put("22626", .{ .column = 5, .row = 5 }); // 4800 W. Old Bingham Hwy Station
    try led_map.put("22627", .{ .column = 5, .row = 4 }); // Jordan Valley Station
    try led_map.put("22628", .{ .column = 5, .row = 4 }); // Jordan Valley Station
    try led_map.put("22629", .{ .column = 5, .row = 3 }); // 2700 W. Sugar Factory Rd Station
    try led_map.put("22630", .{ .column = 5, .row = 3 }); // 2700 W. Sugar Factory Rd Station
    try led_map.put("22631", .{ .column = 5, .row = 2 }); // West Jordan City Center Station
    try led_map.put("22632", .{ .column = 5, .row = 2 }); // West Jordan City Center Station
    try led_map.put("22633", .{ .column = 5, .row = 1 }); // Historic Gardner Station
    try led_map.put("22634", .{ .column = 5, .row = 1 }); // Historic Gardner Station
    try led_map.put("22635", .{ .column = 5, .row = 0 }); // Bingham Junction Station
    try led_map.put("22636", .{ .column = 5, .row = 0 }); // Bingham Junction Station
    try led_map.put("22639", .{ .column = 6, .row = 0 }); // Daybreak Parkway Station
    try led_map.put("22645", .{ .column = 2, .row = 3 }); // RIVER TRAIL STATION
    try led_map.put("22646", .{ .column = 2, .row = 3 }); // River Trail Station
    try led_map.put("22647", .{ .column = 2, .row = 4 }); // Redwood Junction Station
    try led_map.put("22648", .{ .column = 2, .row = 4 }); // Redwood Junction Station
    try led_map.put("22649", .{ .column = 2, .row = 5 }); // Decker Lake Station
    try led_map.put("22650", .{ .column = 2, .row = 5 }); // Decker Lake Station
    try led_map.put("22651", .{ .column = 2, .row = 6 }); // West Valley Central Station
    try led_map.put("22652", .{ .column = 2, .row = 6 }); // West Valley Central Station
    try led_map.put("23039", .{ .column = 1, .row = 0 }); // North Temple Bridge/Guadalupe
    try led_map.put("23040", .{ .column = 1, .row = 0 }); // North Temple Bridge/Guadalupe
    try led_map.put("23041", .{ .column = 1, .row = 1 }); // Jackson/Euclid Station
    try led_map.put("23042", .{ .column = 1, .row = 1 }); // Jackson/Euclid Station
    try led_map.put("23043", .{ .column = 1, .row = 2 }); // Fairpark Station
    try led_map.put("23044", .{ .column = 1, .row = 2 }); // Fairpark Station
    try led_map.put("23045", .{ .column = 1, .row = 3 }); // Power Station
    try led_map.put("23046", .{ .column = 1, .row = 3 }); // Power Station
    try led_map.put("23047", .{ .column = 1, .row = 4 }); // 1940 W. North Temple Station
    try led_map.put("23048", .{ .column = 1, .row = 4 }); // 1940 W. North Temple Station
    try led_map.put("23049", .{ .column = 1, .row = 5 }); // Airport Station
    try led_map.put("23050", .{ .column = 1, .row = 5 }); // Airport Station
    try led_map.put("23318", .{ .column = 4, .row = 5 }); // Crescent View Station
    try led_map.put("23319", .{ .column = 4, .row = 5 }); // Crescent View Station
    try led_map.put("23320", .{ .column = 4, .row = 6 }); // Kimballs Lane Station
    try led_map.put("23321", .{ .column = 4, .row = 6 }); // Kimballs Lane Station
    try led_map.put("23322", .{ .column = 4, .row = 7 }); // Draper Town Center Station
    try led_map.put("23323", .{ .column = 4, .row = 7 }); // Draper Town Center Station
    try led_map.put("23565", .{ .column = 6, .row = 2 }); // Central Pointe Station
    try led_map.put("23566", .{ .column = 3, .row = 5 }); // South Salt Lake City Station
    try led_map.put("23567", .{ .column = 3, .row = 4 }); // 300 East Station
    try led_map.put("23568", .{ .column = 3, .row = 3 }); // 500 East Station
    try led_map.put("23569", .{ .column = 3, .row = 2 }); // 700 East Station
    try led_map.put("23570", .{ .column = 3, .row = 1 }); // Sugarmont Station
    try led_map.put("23571", .{ .column = 3, .row = 0 }); // Fairmont Station
    try led_map.put("25479", .{ .column = 6, .row = 1 }); // South Jordan Downtown Station
    try led_map.put("25480", .{ .column = 6, .row = 1 }); // South Jordan Downtown Station

    const router = try ArduinoRouter.connect(init.io);
    defer router.deinit();
    var client: std.http.Client = .{ .allocator = init.arena.allocator(), .io = init.io };
    defer client.deinit();

    var currentFrame: u1 = 0;

    try router.notify(init.arena.allocator(), "clearFrame", &.{msgpack.Payload.intToPayload(0)});
    try router.notify(init.arena.allocator(), "displayFrame", &.{msgpack.Payload.intToPayload(0)});

    while (true) {
        var arena = std.heap.ArenaAllocator.init(init.gpa);
        const allocator = arena.allocator();
        defer arena.deinit();

        const feed = try get_vehicles(&client, allocator);
        defer feed.deinit();

        var regs: [9]u8 = @splat(0);

        for (feed.value.vehicles) |vehicle| {
            const thing = led_map.get(vehicle.nearest_station.id);

            if (thing) |value| {
                std.debug.print("train at {s}, setting reg {} to {}\n", .{ vehicle.nearest_station.id, value.row, value.column });
                regs[value.column] |= (@as(u8, 1) << (value.row));
            }
        }

        try router.notify(arena.allocator(), "clearFrame", &.{msgpack.Payload.intToPayload(~currentFrame)});

        for (regs, 0..) |value, reg| {
            try router.notify(arena.allocator(), "setRegister", &.{
                msgpack.Payload.uintToPayload(~currentFrame), // page
                msgpack.Payload.uintToPayload(reg * 2), // register
                msgpack.Payload.uintToPayload(value), // value
            });
            try init.io.sleep(.fromMilliseconds(100), .real);

            std.debug.print("{x} IS {x}\n", .{ reg * 2, value });
        }

        try router.notify(arena.allocator(), "displayFrame", &.{msgpack.Payload.intToPayload(~currentFrame)});

        currentFrame = ~currentFrame;

        try init.io.sleep(.fromSeconds(5), .real);
    }
}
