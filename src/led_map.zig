const std = @import("std");

pub const Led = struct {
    row: u3,
    column: u3,
};

pub fn build_led_map() std.StaticStringMap(Led) {
    return .initComptime([_]struct { []const u8, Led }{
        .{ "18377", .{ .column = 0, .row = 6 } }, // Library Station
        .{ "18378", .{ .column = 0, .row = 6 } }, // Library Station
        .{ "18379", .{ .column = 0, .row = 5 } }, // Trolley Station
        .{ "18380", .{ .column = 0, .row = 5 } }, // Trolley Station
        .{ "18381", .{ .column = 0, .row = 4 } }, // 900 East Station
        .{ "18382", .{ .column = 0, .row = 4 } }, // 900 East Station
        .{ "18383", .{ .column = 0, .row = 3 } }, // Stadium Station
        .{ "18384", .{ .column = 0, .row = 3 } }, // Stadium Station
        .{ "18397", .{ .column = 4, .row = 0 } }, // Midvale Fort Union Station
        .{ "18398", .{ .column = 4, .row = 0 } }, // Midvale Fort Union Station
        .{ "18399", .{ .column = 4, .row = 1 } }, // Midvale Center Station
        .{ "18400", .{ .column = 4, .row = 1 } }, // Midvale Center Station
        .{ "18401", .{ .column = 4, .row = 2 } }, // Historic Sandy Station
        .{ "18402", .{ .column = 4, .row = 2 } }, // Historic Sandy Station
        .{ "18403", .{ .column = 4, .row = 4 } }, // Sandy Civic Center Station
        .{ "18404", .{ .column = 4, .row = 4 } }, // Sandy Civic Center Station
        .{ "19166", .{ .column = 0, .row = 2 } }, // University South Campus Station
        .{ "19167", .{ .column = 0, .row = 2 } }, // University South Campus Station
        .{ "19168", .{ .column = 0, .row = 1 } }, // Fort Douglas Station
        .{ "19169", .{ .column = 0, .row = 1 } }, // Fort Douglas Station
        .{ "19170", .{ .column = 0, .row = 0 } }, // University Medical Center
        .{ "19171", .{ .column = 0, .row = 0 } }, // University Medical Center
        .{ "21225", .{ .column = 4, .row = 3 } }, // Sandy Expo Station
        .{ "21226", .{ .column = 4, .row = 3 } }, // Sandy Expo Station
        .{ "21761", .{ .column = 2, .row = 2 } }, // Salt Lake Central Station
        .{ "21762", .{ .column = 2, .row = 0 } }, // Planetarium Station
        .{ "21763", .{ .column = 2, .row = 1 } }, // Old Greektown Station
        .{ "21799", .{ .column = 2, .row = 2 } }, // Salt Lake Central Station
        .{ "21800", .{ .column = 2, .row = 0 } }, // Planetarium Station
        .{ "21801", .{ .column = 2, .row = 1 } }, // Old Greektown Station
        .{ "22620", .{ .column = 6, .row = 0 } }, // Daybreak Parkway Station
        .{ "22621", .{ .column = 5, .row = 7 } }, // South Jordan Parkway Station
        .{ "22622", .{ .column = 5, .row = 7 } }, // South Jordan Parkway Station
        .{ "22623", .{ .column = 5, .row = 6 } }, // 5600 W. Old Bingham Hwy Station
        .{ "22624", .{ .column = 5, .row = 6 } }, // 5600 W. Old Bingham Hwy Station
        .{ "22625", .{ .column = 5, .row = 5 } }, // 4800 W. Old Bingham Hwy Station
        .{ "22626", .{ .column = 5, .row = 5 } }, // 4800 W. Old Bingham Hwy Station
        .{ "22627", .{ .column = 5, .row = 4 } }, // Jordan Valley Station
        .{ "22628", .{ .column = 5, .row = 4 } }, // Jordan Valley Station
        .{ "22629", .{ .column = 5, .row = 3 } }, // 2700 W. Sugar Factory Rd Station
        .{ "22630", .{ .column = 5, .row = 3 } }, // 2700 W. Sugar Factory Rd Station
        .{ "22631", .{ .column = 5, .row = 2 } }, // West Jordan City Center Station
        .{ "22632", .{ .column = 5, .row = 2 } }, // West Jordan City Center Station
        .{ "22633", .{ .column = 5, .row = 1 } }, // Historic Gardner Station
        .{ "22634", .{ .column = 5, .row = 1 } }, // Historic Gardner Station
        .{ "22635", .{ .column = 5, .row = 0 } }, // Bingham Junction Station
        .{ "22636", .{ .column = 5, .row = 0 } }, // Bingham Junction Station
        .{ "22639", .{ .column = 6, .row = 0 } }, // Daybreak Parkway Station
        .{ "22645", .{ .column = 2, .row = 3 } }, // RIVER TRAIL STATION
        .{ "22646", .{ .column = 2, .row = 3 } }, // River Trail Station
        .{ "22647", .{ .column = 2, .row = 4 } }, // Redwood Junction Station
        .{ "22648", .{ .column = 2, .row = 4 } }, // Redwood Junction Station
        .{ "22649", .{ .column = 2, .row = 5 } }, // Decker Lake Station
        .{ "22650", .{ .column = 2, .row = 5 } }, // Decker Lake Station
        .{ "22651", .{ .column = 2, .row = 6 } }, // West Valley Central Station
        .{ "22652", .{ .column = 2, .row = 6 } }, // West Valley Central Station
        .{ "23039", .{ .column = 1, .row = 0 } }, // North Temple Bridge/Guadalupe
        .{ "23040", .{ .column = 1, .row = 0 } }, // North Temple Bridge/Guadalupe
        .{ "23041", .{ .column = 1, .row = 1 } }, // Jackson/Euclid Station
        .{ "23042", .{ .column = 1, .row = 1 } }, // Jackson/Euclid Station
        .{ "23043", .{ .column = 1, .row = 2 } }, // Fairpark Station
        .{ "23044", .{ .column = 1, .row = 2 } }, // Fairpark Station
        .{ "23045", .{ .column = 1, .row = 3 } }, // Power Station
        .{ "23046", .{ .column = 1, .row = 3 } }, // Power Station
        .{ "23047", .{ .column = 1, .row = 4 } }, // 1940 W. North Temple Station
        .{ "23048", .{ .column = 1, .row = 4 } }, // 1940 W. North Temple Station
        .{ "23049", .{ .column = 1, .row = 5 } }, // Airport Station
        .{ "23050", .{ .column = 1, .row = 5 } }, // Airport Station
        .{ "23318", .{ .column = 4, .row = 5 } }, // Crescent View Station
        .{ "23319", .{ .column = 4, .row = 5 } }, // Crescent View Station
        .{ "23320", .{ .column = 4, .row = 6 } }, // Kimballs Lane Station
        .{ "23321", .{ .column = 4, .row = 6 } }, // Kimballs Lane Station
        .{ "23322", .{ .column = 4, .row = 7 } }, // Draper Town Center Station
        .{ "23323", .{ .column = 4, .row = 7 } }, // Draper Town Center Station
        .{ "23565", .{ .column = 6, .row = 2 } }, // Central Pointe Station
        .{ "23566", .{ .column = 3, .row = 5 } }, // South Salt Lake City Station
        .{ "23567", .{ .column = 3, .row = 4 } }, // 300 East Station
        .{ "23568", .{ .column = 3, .row = 3 } }, // 500 East Station
        .{ "23569", .{ .column = 3, .row = 2 } }, // 700 East Station
        .{ "23570", .{ .column = 3, .row = 1 } }, // Sugarmont Station
        .{ "23571", .{ .column = 3, .row = 0 } }, // Fairmont Station
        .{ "25479", .{ .column = 6, .row = 1 } }, // South Jordan Downtown Station
        .{ "25480", .{ .column = 6, .row = 1 } }, // South Jordan Downtown Station
    });
}
