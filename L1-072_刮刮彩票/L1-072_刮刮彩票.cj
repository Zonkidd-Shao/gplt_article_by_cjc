// L1-072 刮刮彩票
import std.env.*
import std.collection.*
import std.convert.*

func prize(sum: Int64): Int64 {
    if (sum == 6) { return 10000 }
    if (sum == 7) { return 36 }
    if (sum == 8) { return 720 }
    if (sum == 9) { return 360 }
    if (sum == 10) { return 80 }
    if (sum == 11) { return 252 }
    if (sum == 12) { return 108 }
    if (sum == 13) { return 72 }
    if (sum == 14) { return 54 }
    if (sum == 15) { return 180 }
    if (sum == 16) { return 72 }
    if (sum == 17) { return 180 }
    if (sum == 18) { return 119 }
    if (sum == 19) { return 36 }
    if (sum == 20) { return 306 }
    if (sum == 21) { return 1080 }
    if (sum == 22) { return 144 }
    if (sum == 23) { return 1800 }
    if (sum == 24) { return 3600 }
    return 0
}

main() {
    let all = (getStdIn().readToEnd() ?? "")
    var vals = ArrayList<Int64>()
    var cur = StringBuilder()
    var has = false
    var neg = false
    let ra = all.toRuneArray()
    for (i in 0..Int64(ra.size)) {
        let c = ra[i]
        if (c == r'-') { neg = true }
        else if (c >= r'0' && c <= r'9') { cur.append("${c}"); has = true }
        else {
            if (has) {
                var v = Int64.parse(cur.toString())
                if (neg) { v = -v }
                vals.add(v)
                cur = StringBuilder(); has = false; neg = false
            } else { neg = false }
        }
    }
    if (has) {
        var v = Int64.parse(cur.toString())
        if (neg) { v = -v }
        vals.add(v)
    }
    if (vals.size < 16) { return }
    var grid = Array<Array<Int64>>(3, {i => Array<Int64>(3, repeat: 0)})
    var sumKnown: Int64 = 0
    var zx: Int64 = 0
    var zy: Int64 = 0
    for (i in 0..3) {
        for (j in 0..3) {
            let v = vals[(i*3+j)]
            grid[i][j] = v
            if (v == 0) { zx = i; zy = j } else { sumKnown += v }
        }
    }
    let zeroVal = 45 - sumKnown
    grid[zx][zy] = zeroVal
    var outIdx: Int64 = 9
    for (_ in 0..3) {
        let x = vals[outIdx] - 1
        let y = vals[outIdx+1] - 1
        outIdx += 2
        println(grid[x][y])
    }
    let dir = vals[vals.size - 1]
    var s: Int64 = 0
    if (dir == 1) { s = grid[0][0]+grid[0][1]+grid[0][2] }
    else if (dir == 2) { s = grid[1][0]+grid[1][1]+grid[1][2] }
    else if (dir == 3) { s = grid[2][0]+grid[2][1]+grid[2][2] }
    else if (dir == 4) { s = grid[0][0]+grid[1][0]+grid[2][0] }
    else if (dir == 5) { s = grid[0][1]+grid[1][1]+grid[2][1] }
    else if (dir == 6) { s = grid[0][2]+grid[1][2]+grid[2][2] }
    else if (dir == 7) { s = grid[0][0]+grid[1][1]+grid[2][2] }
    else if (dir == 8) { s = grid[0][2]+grid[1][1]+grid[2][0] }
    println(prize(s))
}
