// L1-054 福到了 — 倒置输出
import std.env.*
import std.collection.*
import std.convert.*
main() {
    let cin = getStdIn()
    var firstLine = ""
    while (let Some(l) <- cin.readln()) {
        // keep raw line not trimmed fully for char parsing? but first line is "<char> <N>"
        if (!l.trimAscii().isEmpty()) { firstLine = l; break }
        if (!l.isEmpty()) { firstLine = l; break }
    }
    if (firstLine.isEmpty()) {
        let all = cin.readToEnd() ?? ""
        firstLine = all.split("\n")[0]
    }
    // parse char and N
    let ft = firstLine.trimAscii()
    var toks = ft.split(" ")
    var clean = ArrayList<String>()
    for (p in toks) {
        let s = p.trimAscii()
        if (!s.isEmpty()) { clean.add(s) }
        // also handle tab
        let sub = p.split("\t")
        if (sub.size > 1) {
            for (q in sub) {
                let t = q.trimAscii()
                if (!t.isEmpty() && t != s) { clean.add(t) }
            }
        }
    }
    // fallback simple: split by whitespace manual
    if (clean.size < 2) {
        // try split by last space
        var lastSpace: Int64 = -1
        var idx: Int64 = 0
        let runes = firstLine.toRuneArray()
        while (idx < runes.size) {
            if (runes[idx] == ' '.toRuneArray()[0]) { lastSpace = idx }
            idx += 1
        }
        if (lastSpace != -1) {
            clean = ArrayList<String>()
            // construct strings via rune slices? easier use substring not available
            // fallback parse via split again
        }
    }
    var chStr = ""
    var nStr = ""
    if (clean.size >= 2) {
        chStr = clean[0]
        nStr = clean[1]
    } else {
        // alternative: first non-space char is ch
        let trimmed = firstLine.trimAscii()
        if (!trimmed.isEmpty()) {
            chStr = trimmed.split(" ")[0]
            // find number part
            var parts2 = trimmed.split(" ")
            for (p in parts2) {
                let t = p.trimAscii()
                if (t.isEmpty()) { continue }
                if (t == chStr) { continue }
                nStr = t
            }
        }
    }
    if (chStr.isEmpty() || nStr.isEmpty()) { return }
    // new char is first rune of chStr
    let newRunes = chStr.toRuneArray()
    let newRune = newRunes[0]
    let n = Int64.parse(nStr.trimAscii())
    // read n grid lines, preserving spaces, each exactly N characters
    var grid = Array<Array<Rune>>(n, { _ => Array<Rune>(n, repeat: ' '.toRuneArray()[0]) })
    var row: Int64 = 0
    // we have already consumed firstLine, need to read next n lines via readln
    while (row < n) {
        var lineOpt = cin.readln()
        var line: String = ""
        if (let Some(l) <- lineOpt) {
            line = l
        } else {
            let rest = cin.readToEnd() ?? ""
            let restLines = rest.split("\n")
            var ri: Int64 = 0
            while (row < n && ri < restLines.size) {
                line = restLines[ri]
                ri += 1
                // process this line
                let ra = line.toRuneArray()
                var col: Int64 = 0
                while (col < n) {
                    if (col < ra.size) { grid[row][col] = ra[col] } else { grid[row][col] = ' '.toRuneArray()[0] }
                    col += 1
                }
                row += 1
            }
            break
        }
        let ra = line.toRuneArray()
        var col: Int64 = 0
        while (col < n) {
            if (col < ra.size) { grid[row][col] = ra[col] } else { grid[row][col] = ' '.toRuneArray()[0] }
            col += 1
        }
        row += 1
    }
    // If we didn't get enough rows due to empty read, try readToEnd fallback
    if (row < n) {
        let rest = cin.readToEnd() ?? ""
        let restLines = rest.split("\n")
        var ri: Int64 = 0
        while (row < n && ri < restLines.size) {
            let line = restLines[ri]
            ri += 1
            if (line.isEmpty() && row < n-1) { continue }
            let ra = line.toRuneArray()
            var col: Int64 = 0
            while (col < n) {
                if (col < ra.size) { grid[row][col] = ra[col] } else { grid[row][col] = ' '.toRuneArray()[0] }
                col += 1
            }
            row += 1
        }
    }
    // check palindrome: grid[i][j] vs grid[n-1-i][n-1-j]
    var pal = true
    var i: Int64 = 0
    while (i < n) {
        var j: Int64 = 0
        while (j < n) {
            if (grid[i][j] != grid[n-1-i][n-1-j]) { pal = false; break }
            j += 1
        }
        if (!pal) { break }
        i += 1
    }
    if (pal) { println("bu yong dao le") }
    // build reversed grid with substitution
    var outIdx: Int64 = 0
    while (outIdx < n) {
        let sb = StringBuilder()
        var j: Int64 = 0
        while (j < n) {
            // reversed position
            let ri = n - 1 - outIdx
            let rj = n - 1 - j
            let c = grid[ri][rj]
            let atRune = '@'.toRuneArray()[0]
            if (c == atRune) {
                sb.append(newRune.toString())
            } else {
                sb.append(c.toString())
            }
            j += 1
        }
        println(sb.toString())
        outIdx += 1
    }
}
