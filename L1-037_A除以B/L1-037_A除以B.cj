// L1-037 A除以B - formatted division with 2 decimals
import std.env.*
import std.convert.*
func format2(q: Float64): String {
    var scaled: Int64 = 0
    if (q >= 0.0) {
        scaled = Int64(q * 100.0 + 0.5 + 1e-9)
    } else {
        scaled = Int64(q * 100.0 - 0.5 - 1e-9)
    }
    var neg = false
    if (scaled < 0) { neg = true; scaled = -scaled }
    let intPart = scaled / 100
    let fracPart = scaled % 100
    var fracStr = "${fracPart}"
    if (fracPart < 10) { fracStr = "0" + fracStr }
    var res = "${intPart}.${fracStr}"
    if (neg) { res = "-" + res }
    return res
}
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    var norm = ""
    for (c in all.toRuneArray()) {
        if (c == r'\n' || c == r'\r' || c == r'\t') { norm += " " } else { norm += c.toString() }
    }
    let parts = norm.split(" ")
    var toks = Array<String>(0, repeat: "")
    for (p in parts) {
        if (p.trimAscii().size > 0) {
            var tmp = Array<String>(toks.size + 1, repeat: "")
            var i: Int64 = 0
            while (i < toks.size) { tmp[i] = toks[i]; i += 1 }
            tmp[toks.size] = p.trimAscii()
            toks = tmp
        }
    }
    if (toks.size < 2) { return }
    let a = Int64.parse(toks[0])
    let b = Int64.parse(toks[1])
    if (b == 0) {
        println("${a}/0=Error")
        return
    }
    let q = Float64(a) / Float64(b)
    let qs = format2(q)
    if (b > 0) {
        println("${a}/${b}=${qs}")
    } else {
        println("${a}/(${b})=${qs}")
    }
}
