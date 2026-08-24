// L1-078 吉老师的回归 - 过滤含 qiandao/easy 的题目
import std.env.*
import std.collection.*
import std.convert.*

func containsSub(s: String, sub: String): Bool {
    let a = s.toRuneArray()
    let b = sub.toRuneArray()
    if (b.size == 0) { return true }
    if (b.size > a.size) { return false }
    var i = 0
    while (i <= a.size - b.size) {
        var j = 0
        while (j < b.size && a[i + j] == b[j]) { j++ }
        if (j == b.size) { return true }
        i++
    }
    return false
}

main() {
    let cin = getStdIn()
    var lines = ArrayList<String>()
    while (let Some(line) <- cin.readln()) {
        lines.add(line)
    }
    if (lines.size == 0) { return }
    let first = lines[0].trimAscii()
    // split first by spaces using replace method to normalize
    let cleaned = first.replace("\t", " ")
    var raw = cleaned.split(" ")
    var toks = ArrayList<String>()
    for (p in raw) { if (p.size > 0) { toks.add(p) } }
    if (toks.size < 2) { return }
    let n = Int64.parse(toks[0])
    let m = Int64.parse(toks[1])
    var valid = ArrayList<String>()
    var idx = 1
    while (idx <= n && idx < Int64(lines.size)) {
        let prob = lines[idx]
        if (!containsSub(prob, "qiandao") && !containsSub(prob, "easy")) {
            valid.add(prob)
        }
        idx++
    }
    if (m < Int64(valid.size)) {
        println(valid[m])
    } else {
        println("Wo AK le")
    }
}
