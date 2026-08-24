// L1-046 整除光棍 — 找最小光棍的商和位数
import std.env.*
import std.convert.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    let t = all.trimAscii()
    if (t.isEmpty()) { return }
    // first token is x
    var xs = ""
    let parts = t.split(" ")
    for (p in parts) {
        let a = p.split("\n")
        for (q in a) {
            let b = q.split("\r")
            for (r in b) {
                let c = r.split("\t")
                for (v in c) {
                    let s = v.trimAscii()
                    if (!s.isEmpty()) { xs = s; break }
                }
                if (!xs.isEmpty()) { break }
            }
            if (!xs.isEmpty()) { break }
        }
        if (!xs.isEmpty()) { break }
    }
    if (xs.isEmpty()) { xs = t }
    let x = Int64.parse(xs)
    var rem: Int64 = 0
    var n: Int64 = 0
    let sb = StringBuilder()
    var started = false
    while (true) {
        rem = rem * 10 + 1
        n += 1
        let q = rem / x
        rem = rem % x
        if (!started) {
            if (q != 0) {
                started = true
                sb.append(q.toString())
            } else {
                // still leading zero: if rem==0 meaning single digit case x==1
                if (rem == 0) {
                    sb.append(q.toString())
                    started = true
                }
            }
        } else {
            sb.append(q.toString())
        }
        if (rem == 0) { break }
    }
    println("${sb.toString()} ${n}")
}
