/* L1-104 九宫格 - approach: check rows/cols/boxes contain 1..9 exactly once */
import std.env.*
import std.collection.*
import std.convert.*
func isValid(arr: Array<Int64>): Bool {
    var seen = Array<Bool>(10, repeat: false)
    for (num in arr) {
        if (num < 1 || num > 9) { return false }
        let idx = Int64(num)
        if (seen[idx]) { return false }
        seen[idx] = true
    }
    return true
}
func checkSudoku(grid: Array<Array<Int64>>): Bool {
    for (row in grid) {
        if (!isValid(row)) { return false }
    }
    for (col in 0..9) {
        var column = Array<Int64>(9, repeat: 0)
        for (row in 0..9) {
            column[row] = grid[row][col]
        }
        if (!isValid(column)) { return false }
    }
    for (br in 0..3) {
        for (bc in 0..3) {
            var box = Array<Int64>(9, repeat: 0)
            var idx = 0
            for (i in 0..3) {
                for (j in 0..3) {
                    box[idx] = grid[br*3 + i][bc*3 + j]
                    idx += 1
                }
            }
            if (!isValid(box)) { return false }
        }
    }
    return true
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
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    var pos: Int64 = 1
    for (_ in 0..n) {
        var grid = Array<Array<Int64>>(9, { _ => Array<Int64>(9, repeat: 0) })
        for (r in 0..9) {
            for (c in 0..9) {
                if (pos < Int64(tokens.size)) {
                    grid[r][c] = Int64.parse(tokens[Int64(pos)])
                    pos += 1
                }
            }
        }
        if (checkSudoku(grid)) {
            println(1)
        } else {
            println(0)
        }
    }
}
