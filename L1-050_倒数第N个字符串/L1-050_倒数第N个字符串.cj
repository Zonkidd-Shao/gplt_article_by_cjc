// L1-050 倒数第N个字符串 — 26进制转换
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
    let L = Int64.parse(toks[0])
    let N = Int64.parse(toks[1])
    var total: Int64 = 1
    var i: Int64 = 0
    while (i < L) { total *= 26; i += 1 }
    var num = total - N
    var chars = Array<String>(L, repeat: "")
    var pos = L - 1
    while (pos >= 0) {
        let d = num % 26
        // 0->a
        let code = 97 + d // 'a' ascii
        // build char string
        // use rune conversion via StringBuilder? simple mapping
        var ch: String = ""
        if (d == 0) { ch = "a" } else if (d == 1) { ch = "b" } else if (d == 2) { ch = "c" } else if (d == 3) { ch = "d" } else if (d == 4) { ch = "e" } else if (d == 5) { ch = "f" } else if (d == 6) { ch = "g" } else if (d == 7) { ch = "h" } else if (d == 8) { ch = "i" } else if (d == 9) { ch = "j" } else if (d == 10) { ch = "k" } else if (d == 11) { ch = "l" } else if (d == 12) { ch = "m" } else if (d == 13) { ch = "n" } else if (d == 14) { ch = "o" } else if (d == 15) { ch = "p" } else if (d == 16) { ch = "q" } else if (d == 17) { ch = "r" } else if (d == 18) { ch = "s" } else if (d == 19) { ch = "t" } else if (d == 20) { ch = "u" } else if (d == 21) { ch = "v" } else if (d == 22) { ch = "w" } else if (d == 23) { ch = "x" } else if (d == 24) { ch = "y" } else { ch = "z" }
        chars[pos] = ch
        num = num / 26
        pos -= 1
    }
    let sb = StringBuilder()
    var k: Int64 = 0
    while (k < L) { sb.append(chars[k]); k += 1 }
    println(sb.toString())
}
