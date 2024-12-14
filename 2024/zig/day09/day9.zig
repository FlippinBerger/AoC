const std = @import("std");

pub fn main() !void {
    const buf = try getInputBuf();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer std.debug.assert(gpa.deinit() == .ok);

    var list = try buildArrayListFromBuf(&buf, allocator);
    defer list.deinit();

    var i: usize = 0;
    while (i < 21) : (i += 1) {

        // for (list.items, 0..20) |val, _| {
        const int = std.fmt.parseInt(u8, list.items[i], 10) catch 0;

        std.debug.print("list.items[{}]: {} or {s}\n", .{ i, int, list.items[i] });
    }

    const index = list.items.len - 30;

    std.debug.print("last 30 items: {c}\n\n", .{list.items[index..]});

    const s = list.items[0..];
    std.debug.print("{s}\n", .{s});

    for (list.items) |item| {
        allocator.free(item);
    }
}

fn isEven(num: usize) bool {
    return num % 2 == 0;
}

fn buildArrayListFromBuf(buf: *const [19999]u8, allocator: std.mem.Allocator) !std.ArrayList([]u8) {
    var list = std.ArrayList([]u8).init(allocator);

    var id: usize = 0;
    for (buf, 0..) |val, i| {
        const int = try std.fmt.parseInt(u8, &[_]u8{val}, 10);

        std.debug.print("i is {} and int is {}\n", .{ i, int });
        var j: usize = 0;
        while (j < int) : (j += 1) {
            if (isEven(i)) {
                var s_buf: [10000]u8 = undefined;
                std.debug.print("id is {}\n", .{id});
                const s = try std.fmt.bufPrint(&s_buf, "{}", .{id});
                std.debug.print("s is {s} with len {}\n", .{ s, s.len });
                try list.append(try std.fmt.allocPrint(allocator, "{s}", .{s}));

                std.debug.print("item in list: {s}\n", .{list.getLast()});
            } else {
                // var dot = [_]u8{'.'};
                var s_buf: [1]u8 = undefined;
                const dot = try std.fmt.bufPrint(&s_buf, ".", .{});
                std.debug.print("s is {s} with len {}\n", .{ dot, dot.len });
                // try list.append(dot);
                try list.append(try std.fmt.allocPrint(allocator, "{s}", .{dot}));
            }
            std.debug.print("list len: {}\n", .{list.items.len});
        }

        if (isEven(i)) {
            id += 1;
        }

        if (i == 20) {
            break;
        }
    }
    var i: usize = 0;
    std.debug.print("before returning\n\n", .{});
    while (i < 21) : (i += 1) {

        // for (list.items, 0..20) |val, _| {
        const int = std.fmt.parseInt(u8, list.items[i], 10) catch 0;

        std.debug.print("list.items[{}]: {} or {s}\n", .{ i, int, list.items[i] });
    }

    return list;
}

fn getInputBuf() ![19999]u8 {
    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buf: [19999]u8 = undefined;
    const bytes_read = try file.readAll(&buf);

    std.debug.print("bytes read: {}\n", .{bytes_read});
    std.debug.print("string length: {}\n", .{buf.len});

    return buf;
}
