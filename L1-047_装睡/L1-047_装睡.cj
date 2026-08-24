// L1-047 装睡 — 找出指标异常的人
import std.env.*
import std.collection.*
import std.convert.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    var parts = all.split(" ")
    var toks = ArrayList<String>()
    for (p in parts) {
        let a = p.split("\n")
        for (q in a) {
            let b = q.split("\r")
            for (r in b) {
                let c = r.split("\t")
                for (t in c) {
                    let s = t.trimAscii()
                    if (!s.isEmpty()) { toks.add(s) }
                }
            }
        }
    }
    if (toks.size == 0) { return }
    let n = Int64.parse(toks[0])
    var idx: Int64 = 1
    let sb = StringBuilder()
    var i: Int64 = 0
    while (i < n) {
        if (idx + 2 >= toks.size) { break }
        let name = toks[idx]
        let resp = Int64.parse(toks[idx+1])
        let pulse = Int64.parse(toks[idx+2])
        idx += 3
        let abnormal = (resp < 15 || resp > 20 || pulse < 50 || pulse > 70)
        if (abnormal) { sb.append("${name}\n") }
        i += 1
    }
    print(sb.toString())
}
