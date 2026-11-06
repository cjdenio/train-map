const std = @import("std");

pub const Led = struct {
    column: u3,
    row: u3,

    pub fn led_reg(self: Led) u8 {
        return @as(u8, self.row) * 2;
    }

    pub fn pwm_reg(self: Led) u8 {
        return @as(u8, self.row) * 0x10 + 0x24 + self.column;
    }
};

test {
    const led_map = build_led_map();
    const led = led_map.get("22625") orelse unreachable;
    try std.testing.expect(led.pwm_reg() == 0x79);
    try std.testing.expect(led.led_reg() == 0x0a);
}

pub fn build_led_map() std.StaticStringMap(Led) {
    return .initComptime([_]struct { []const u8, Led }{
        .{ "18377", .{ .row = 0, .column = 6 } }, // Library Station
        .{ "18378", .{ .row = 0, .column = 6 } }, // Library Station
        .{ "18379", .{ .row = 0, .column = 5 } }, // Trolley Station
        .{ "18380", .{ .row = 0, .column = 5 } }, // Trolley Station
        .{ "18381", .{ .row = 0, .column = 4 } }, // 900 East Station
        .{ "18382", .{ .row = 0, .column = 4 } }, // 900 East Station
        .{ "18383", .{ .row = 0, .column = 3 } }, // Stadium Station
        .{ "18384", .{ .row = 0, .column = 3 } }, // Stadium Station
        .{ "18397", .{ .row = 4, .column = 0 } }, // Midvale Fort Union Station
        .{ "18398", .{ .row = 4, .column = 0 } }, // Midvale Fort Union Station
        .{ "18399", .{ .row = 4, .column = 1 } }, // Midvale Center Station
        .{ "18400", .{ .row = 4, .column = 1 } }, // Midvale Center Station
        .{ "18401", .{ .row = 4, .column = 2 } }, // Historic Sandy Station
        .{ "18402", .{ .row = 4, .column = 2 } }, // Historic Sandy Station
        .{ "18403", .{ .row = 4, .column = 4 } }, // Sandy Civic Center Station
        .{ "18404", .{ .row = 4, .column = 4 } }, // Sandy Civic Center Station
        .{ "19166", .{ .row = 0, .column = 2 } }, // University South Campus Station
        .{ "19167", .{ .row = 0, .column = 2 } }, // University South Campus Station
        .{ "19168", .{ .row = 0, .column = 1 } }, // Fort Douglas Station
        .{ "19169", .{ .row = 0, .column = 1 } }, // Fort Douglas Station
        .{ "19170", .{ .row = 0, .column = 0 } }, // University Medical Center
        .{ "19171", .{ .row = 0, .column = 0 } }, // University Medical Center
        .{ "21225", .{ .row = 4, .column = 3 } }, // Sandy Expo Station
        .{ "21226", .{ .row = 4, .column = 3 } }, // Sandy Expo Station
        .{ "21761", .{ .row = 2, .column = 2 } }, // Salt Lake Central Station
        .{ "21762", .{ .row = 2, .column = 0 } }, // Planetarium Station
        .{ "21763", .{ .row = 2, .column = 1 } }, // Old Greektown Station
        .{ "21799", .{ .row = 2, .column = 2 } }, // Salt Lake Central Station
        .{ "21800", .{ .row = 2, .column = 0 } }, // Planetarium Station
        .{ "21801", .{ .row = 2, .column = 1 } }, // Old Greektown Station
        .{ "22620", .{ .row = 6, .column = 0 } }, // Daybreak Parkway Station
        .{ "22621", .{ .row = 5, .column = 7 } }, // South Jordan Parkway Station
        .{ "22622", .{ .row = 5, .column = 7 } }, // South Jordan Parkway Station
        .{ "22623", .{ .row = 5, .column = 6 } }, // 5600 W. Old Bingham Hwy Station
        .{ "22624", .{ .row = 5, .column = 6 } }, // 5600 W. Old Bingham Hwy Station
        .{ "22625", .{ .row = 5, .column = 5 } }, // 4800 W. Old Bingham Hwy Station
        .{ "22626", .{ .row = 5, .column = 5 } }, // 4800 W. Old Bingham Hwy Station
        .{ "22627", .{ .row = 5, .column = 4 } }, // Jordan Valley Station
        .{ "22628", .{ .row = 5, .column = 4 } }, // Jordan Valley Station
        .{ "22629", .{ .row = 5, .column = 3 } }, // 2700 W. Sugar Factory Rd Station
        .{ "22630", .{ .row = 5, .column = 3 } }, // 2700 W. Sugar Factory Rd Station
        .{ "22631", .{ .row = 5, .column = 2 } }, // West Jordan City Center Station
        .{ "22632", .{ .row = 5, .column = 2 } }, // West Jordan City Center Station
        .{ "22633", .{ .row = 5, .column = 1 } }, // Historic Gardner Station
        .{ "22634", .{ .row = 5, .column = 1 } }, // Historic Gardner Station
        .{ "22635", .{ .row = 5, .column = 0 } }, // Bingham Junction Station
        .{ "22636", .{ .row = 5, .column = 0 } }, // Bingham Junction Station
        .{ "22639", .{ .row = 6, .column = 0 } }, // Daybreak Parkway Station
        .{ "22645", .{ .row = 2, .column = 3 } }, // RIVER TRAIL STATION
        .{ "22646", .{ .row = 2, .column = 3 } }, // River Trail Station
        .{ "22647", .{ .row = 2, .column = 4 } }, // Redwood Junction Station
        .{ "22648", .{ .row = 2, .column = 4 } }, // Redwood Junction Station
        .{ "22649", .{ .row = 2, .column = 5 } }, // Decker Lake Station
        .{ "22650", .{ .row = 2, .column = 5 } }, // Decker Lake Station
        .{ "22651", .{ .row = 2, .column = 6 } }, // West Valley Central Station
        .{ "22652", .{ .row = 2, .column = 6 } }, // West Valley Central Station
        .{ "23039", .{ .row = 1, .column = 0 } }, // North Temple Bridge/Guadalupe
        .{ "23040", .{ .row = 1, .column = 0 } }, // North Temple Bridge/Guadalupe
        .{ "23041", .{ .row = 1, .column = 1 } }, // Jackson/Euclid Station
        .{ "23042", .{ .row = 1, .column = 1 } }, // Jackson/Euclid Station
        .{ "23043", .{ .row = 1, .column = 2 } }, // Fairpark Station
        .{ "23044", .{ .row = 1, .column = 2 } }, // Fairpark Station
        .{ "23045", .{ .row = 1, .column = 3 } }, // Power Station
        .{ "23046", .{ .row = 1, .column = 3 } }, // Power Station
        .{ "23047", .{ .row = 1, .column = 4 } }, // 1940 W. North Temple Station
        .{ "23048", .{ .row = 1, .column = 4 } }, // 1940 W. North Temple Station
        .{ "23049", .{ .row = 1, .column = 5 } }, // Airport Station
        .{ "23050", .{ .row = 1, .column = 5 } }, // Airport Station
        .{ "23318", .{ .row = 4, .column = 5 } }, // Crescent View Station
        .{ "23319", .{ .row = 4, .column = 5 } }, // Crescent View Station
        .{ "23320", .{ .row = 4, .column = 6 } }, // Kimballs Lane Station
        .{ "23321", .{ .row = 4, .column = 6 } }, // Kimballs Lane Station
        .{ "23322", .{ .row = 4, .column = 7 } }, // Draper Town Center Station
        .{ "23323", .{ .row = 4, .column = 7 } }, // Draper Town Center Station
        .{ "23565", .{ .row = 6, .column = 2 } }, // Central Pointe Station
        .{ "23566", .{ .row = 3, .column = 5 } }, // South Salt Lake City Station
        .{ "23567", .{ .row = 3, .column = 4 } }, // 300 East Station
        .{ "23568", .{ .row = 3, .column = 3 } }, // 500 East Station
        .{ "23569", .{ .row = 3, .column = 2 } }, // 700 East Station
        .{ "23570", .{ .row = 3, .column = 1 } }, // Sugarmont Station
        .{ "23571", .{ .row = 3, .column = 0 } }, // Fairmont Station
        .{ "25479", .{ .row = 6, .column = 1 } }, // South Jordan Downtown Station
        .{ "25480", .{ .row = 6, .column = 1 } }, // South Jordan Downtown Station
    });
}
