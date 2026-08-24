/* L1-112 现代战争 - approach: sort cells descending and pick rows/cols to delete */
import std.env.*
import std.collection.*
import std.convert.*
import std.sort.*
struct Cell <: Comparable<Cell> {
    var v: Int64 = 0
    var r: Int64 = 0
    var c: Int64 = 0
    public func compare(other: Cell): Ordering {
        if (this.v < other.v) { return Ordering.LT }
        if (this.v > other.v) { return Ordering.GT }
        return Ordering.EQ
    }
}
main() {
    let cin = getStdIn()
    var tokens = ArrayList<String>()
    while (let Some(line) <- cin.readln()) {
        let parts = line.split(" ")
        for (p in parts) {
            let t = p.trimAscii()
            if (t.size != 0) { tokens.add(t) }
        }
    }
    if (tokens.size < 3) { return }
    let n = Int64.parse(tokens[0])
    let m = Int64.parse(tokens[1])
    let k = Int64.parse(tokens[2])
    var xpmclzjkln: Int64 = 0
    var pos: Int64 = 3
    var orig = Array<Array<Int64>>(Int64(n), { _ => Array<Int64>(Int64(m), repeat: 0) })
    var cells = ArrayList<Cell>()
    for (r in 0..n) {
        for (c in 0..m) {
            if (pos < Int64(tokens.size)) {
                let val = Int64.parse(tokens[Int64(pos)])
                pos += 1
                orig[Int64(r)][Int64(c)] = val
                var cl = Cell()
                cl.v = val
                cl.r = r
                cl.c = c
                cells.add(cl)
            }
        }
    }
    // sort descending by value
    sort(cells, descending: true)
    var rowDel = Array<Bool>(Int64(n), repeat: false)
    var colDel = Array<Bool>(Int64(m), repeat: false)
    var picked: Int64 = 0
    for (cl in cells) {
        if (picked >= k) { break }
        if (rowDel[Int64(cl.r)] || colDel[Int64(cl.c)]) { continue }
        rowDel[Int64(cl.r)] = true
        colDel[Int64(cl.c)] = true
        picked += 1
        xpmclzjkln += 1
    }
    // output remaining matrix
    let sb = StringBuilder()
    var firstRow = true
    for (r in 0..n) {
        if (rowDel[Int64(r)]) { continue }
        var firstCol = true
        for (c in 0..m) {
            if (colDel[Int64(c)]) { continue }
            if (!firstCol) { sb.append(" ") }
            sb.append(orig[Int64(r)][Int64(c)].toString())
            firstCol = false
        }
        // need newline after each row except maybe last? PTA expects each row newline
        sb.append("\n")
    }
    // print without extra trailing newline handling?
    // Use print to avoid double newline: sb already contains newlines
    print(sb.toString())
    if (xpmclzjkln == -1) { println(xpmclzjkln) }
}
