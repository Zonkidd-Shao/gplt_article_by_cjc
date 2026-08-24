// L1-055 谁是赢家 — 判断赢家
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
    if (toks.size < 5) { return }
    let pa = Int64.parse(toks[0])
    let pb = Int64.parse(toks[1])
    let v0 = Int64.parse(toks[2])
    let v1 = Int64.parse(toks[3])
    let v2 = Int64.parse(toks[4])
    var ca: Int64 = 0
    var cb: Int64 = 0
    if (v0 == 0) { ca += 1 } else { cb += 1 }
    if (v1 == 0) { ca += 1 } else { cb += 1 }
    if (v2 == 0) { ca += 1 } else { cb += 1 }
    var winner: String = ""
    var p1: Int64 = 0
    var p2: Int64 = 0
    if (pa > pb) {
        if (ca >= 1) { winner = "a"; p1 = pa; p2 = ca } else { winner = "b"; p1 = pb; p2 = cb }
    } else {
        if (cb >= 1) { winner = "b"; p1 = pb; p2 = cb } else { winner = "a"; p1 = pa; p2 = ca }
    }
    println("The winner is ${winner}: ${p1} + ${p2}")
}
