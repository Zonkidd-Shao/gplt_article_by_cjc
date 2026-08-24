// L1-043 阅览室 — 统计借阅次数和平均时长
import std.env.*
import std.collection.*
import std.convert.*
func toMin(s: String): Int64 {
    let p = s.split(":")
    let h = Int64.parse(p[0].trimAscii())
    let m = Int64.parse(p[1].trimAscii())
    return h*60+m
}
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    // split into lines by \n
    var rawLines = all.split("\n")
    // clean \r
    var lines = ArrayList<String>()
    for (l in rawLines) {
        var t = l
        // remove \r if present
        let nr = t.split("\r")
        var merged = ""
        var first = true
        for (x in nr) {
            if (first) { merged = x; first = false } else { merged = merged + x }
        }
        lines.add(merged)
    }
    // skip empty at start to find N
    var idx: Int64 = 0
    while (idx < lines.size && lines[idx].trimAscii().isEmpty()) { idx += 1 }
    if (idx >= lines.size) { return }
    let n = Int64.parse(lines[idx].trimAscii())
    idx += 1
    let sb = StringBuilder()
    var day: Int64 = 0
    var borrow = Array<Int64>(1001, repeat: -1)
    var cnt: Int64 = 0
    var total: Int64 = 0
    while (day < n) {
        if (idx >= lines.size) {
            let avg: Int64 = if (cnt == 0) { 0 } else { (total + cnt/2)/cnt }
            sb.append("${cnt} ${avg}\n")
            day += 1
            if (day < n) {
                borrow = Array<Int64>(1001, repeat: -1)
                cnt = 0; total = 0
            }
            continue
        }
        let raw = lines[idx]
        idx += 1
        if (raw.trimAscii().isEmpty()) { continue }
        // token split
        var partsA = raw.split(" ")
        var toks = ArrayList<String>()
        for (p in partsA) {
            let q = p.split("\t")
            for (r in q) {
                let s = r.trimAscii()
                if (!s.isEmpty()) { toks.add(s) }
            }
        }
        if (toks.size < 3) { continue }
        let bookId = Int64.parse(toks[0])
        let key = toks[1]
        let timeS = toks[2]
        if (bookId == 0) {
            let avg: Int64 = if (cnt == 0) { 0 } else { (total + cnt/2)/cnt }
            sb.append("${cnt} ${avg}\n")
            borrow = Array<Int64>(1001, repeat: -1)
            cnt = 0; total = 0
            day += 1
        } else {
            let mins = toMin(timeS)
            let bi = bookId
            if (key == "S") {
                borrow[bi] = mins
            } else if (key == "E") {
                let st = borrow[bi]
                if (st != -1) {
                    total += mins - st
                    cnt += 1
                    borrow[bi] = -1
                }
            }
        }
    }
    print(sb.toString())
}
