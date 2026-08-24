// L1-039 古风排版 - vertical right-to-left layout
import std.env.*
import std.convert.*
main() {
    let cin = getStdIn()
    var firstLine = ""
    var secondLine = ""
    var idx: Int64 = 0
    while (let Some(line) <- cin.readln()) {
        var s = line
        if (s.size > 0) {
            let ra = s.toRuneArray()
            if (ra[ra.size - 1] == r'\r') {
                var t = ""
                var k: Int64 = 0
                while (k < ra.size - 1) { t += ra[k].toString(); k += 1 }
                s = t
            }
        }
        if (idx == 0) { firstLine = s }
        else if (idx == 1) { secondLine = s; break }
        idx += 1
    }
    if (firstLine.trimAscii().size == 0) { return }
    let n = Int64.parse(firstLine.trimAscii())
    let runes = secondLine.toRuneArray()
    let len = runes.size
    let cols: Int64 = (Int64(len) + n - 1) / n
    let nInt = Int64(n)
    // grid
    var grid = Array<Array<Rune>>(n, { _ => Array<Rune>(cols, repeat: r' ') })
    var p: Int64 = 0
    var col: Int64 = cols - 1
    while (col >= 0) {
        var row: Int64 = 0
        while (row < n) {
            if (p < Int64(len)) {
                grid[row][col] = runes[p]
                p += 1
            }
            row += 1
        }
        col -= 1
    }
    var r: Int64 = 0
    while (r < n) {
        var line = ""
        var c: Int64 = 0
        while (c < cols) {
            line += grid[r][c].toString()
            c += 1
        }
        println(line)
        r += 1
    }
}
