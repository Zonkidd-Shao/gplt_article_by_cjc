// L1-051 打折 — 计算折后价保留2位
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
    let price = Int64.parse(toks[0])
    let disc = Int64.parse(toks[1])
    let val = Float64(price) * Float64(disc) / 10.0
    println(fmt2(val))
}
