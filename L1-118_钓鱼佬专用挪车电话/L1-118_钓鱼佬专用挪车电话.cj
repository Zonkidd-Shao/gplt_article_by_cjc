// L1-118 钓鱼佬专用挪车电话 - count m per line
import std.env.*
import std.collection.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    var norm = StringBuilder()
    let cr: Rune = '\r'
    for (ch in all.toRuneArray()) {
        if (ch == cr) { continue }
        norm.append(ch)
    }
    let s = norm.toString()
    var lines = ArrayList<String>()
    var cur = StringBuilder()
    let nl: Rune = '\n'
    for (ch in s.toRuneArray()) {
        if (ch == nl) {
            lines.add(cur.toString())
            cur = StringBuilder()
        } else {
            cur.append(ch)
        }
    }
    if (s.size == 0) {
    } else {
        let lastIsNl = s.toRuneArray()[s.size-1] == nl
        if (!lastIsNl) {
            lines.add(cur.toString())
        }
    }
    var out = StringBuilder()
    let mChar: Rune = 'm'
    var countLines: Int64 = 0
    for (i in 0..lines.size) {
        if (countLines >= 11) { break }
        let line = lines[i]
        var cnt: Int64 = 0
        for (ch in line.toRuneArray()) {
            if (ch == mChar) { cnt += 1 }
        }
        out.append(cnt)
        countLines += 1
    }
    while (countLines < 11) {
        out.append(0)
        countLines += 1
    }
    println(out.toString())
}
