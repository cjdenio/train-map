const std = @import("std");
const net = std.Io.net;
const msgpack = @import("msgpack");

const RpcType = enum(u8) {
    request = 0,
    response = 1,
    notification = 2,
};

pub const ArduinoRouter = struct {
    stream: net.Stream,
    io: std.Io,

    pub fn connect(io: std.Io) !@This() {
        const address = try net.UnixAddress.init("/var/run/arduino-router.sock");
        const stream = try address.connect(io);

        return .{ .stream = stream, .io = io };
    }

    pub fn notify(self: ArduinoRouter, allocator: std.mem.Allocator, method: []const u8, args: []const msgpack.Payload) !void {
        var request = try msgpack.Payload.arrPayload(3, allocator);
        defer request.free(allocator);

        try request.setArrElement(0, msgpack.Payload.intToPayload(@backingInt(RpcType.notification)));

        const methodPayload = try msgpack.Payload.strToPayload(method, allocator);
        defer methodPayload.free(allocator);
        try request.setArrElement(1, methodPayload);

        var argsPayload = try msgpack.Payload.arrPayload(args.len, allocator);
        defer argsPayload.free(allocator);

        for (args, 0..) |arg, i| {
            try argsPayload.setArrElement(i, arg);
        }

        try request.setArrElement(2, argsPayload);

        var buffer: [1024]u8 = undefined;
        var writer = self.stream.writer(self.io, &buffer);

        const encoder: msgpack.Encoder = .{ .writer = &writer.interface };

        try encoder.write(request);

        try writer.interface.flush();
    }

    pub fn deinit(self: @This()) void {
        self.stream.close(self.io);
    }
};
