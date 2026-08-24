// L1-024 后天 - (D+2) mod 7
import std.env.*
import std.convert.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    var norm = ""
    for (c in all.toRuneArray()) {
        if (c == r'\n' || c == r'\r' || c == r'\t') { norm += " " } else { norm += c.toString() }
    }
    let parts = norm.split(" ")
    var tok = ""
    for (p in parts) { if (p.trimAscii().size > 0) { tok = p.trimAscii(); break } }
    if (tok.size == 0) { return }
    let d = Int64.parse(tok)
    let ans = (d + 2 - 1) % 7 + 1
    println(ans)
}
