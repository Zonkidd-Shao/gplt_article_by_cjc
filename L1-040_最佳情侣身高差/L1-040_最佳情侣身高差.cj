// L1-040 最佳情侣身高差 — 公式 女*1.09=男，保留2位小数
import std.env.*
import std.collection.*
import std.convert.*
import std.math.*
func fmt2(x: Float64): String {
    let c = Int64(round(x * 100.0))
    var neg = false
    var ac = c
    if (c < 0) { neg = true; ac = -c }
    let ip = ac / 100
    let fp = ac % 100
    var fs = fp.toString()
    if (fp < 10) { fs = "0${fs}" }
    if (neg) { return "-${ip}.${fs}" } else { return "${ip}.${fs}" }
}
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
        if (idx + 1 >= toks.size) { break }
        let g = toks[idx]; let hs = toks[idx+1]; idx += 2
        let h = Float64.parse(hs)
        var ans: Float64 = 0.0
        if (g == "M") { ans = h / 1.09 } else { ans = h * 1.09 }
        sb.append(fmt2(ans))
        sb.append("\n")
        i += 1
    }
    print(sb.toString())
}
