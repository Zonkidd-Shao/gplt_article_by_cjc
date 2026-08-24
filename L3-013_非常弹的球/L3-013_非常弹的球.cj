// L3-013 非常弹的球 - projectile with energy loss, max distance at 45deg
import std.env.*
import std.collection.*
import std.convert.*
import std.math.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let toks = tokenize(all)
    var p: Int64 = 0
    func next(): String { let v = toks[p]; p++; return v }
    let w = Float64.parse(next())
    let pp = Float64.parse(next())
    // total distance = 200000 / (m*g*p) where m=w/100, g=9.8
    // edge p may cause division, use double
    let m = w / 100.0
    let g = 9.8
    let total: Float64 = 200000.0 / (m * g * pp)
    let c = Int64(round(total * 1000.0))
    let intPart = c / 1000
    let frac = c % 1000
    var fracStr = frac.toString()
    while (fracStr.size < 3) { fracStr = "0" + fracStr }
    println("${intPart}.${fracStr}")
}

func tokenize(s: String): Array<String> {
    let res = ArrayList<String>()
    var cur = StringBuilder()
    for (r in s.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) { res.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(rs) }
    }
    if (cur.size > 0) { res.add(cur.toString()) }
    return res.toArray()
}
