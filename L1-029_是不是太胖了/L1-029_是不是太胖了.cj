// L1-029 是不是太胖了 - weight = (H-100)*1.8, one decimal
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
    let h = Int64.parse(tok)
    let w = (Float64(h) - 100.0) * 1.8
    let scaled = Int64(w * 10.0 + 0.5)
    let intPart = scaled / 10
    let decPart = scaled % 10
    println("${intPart}.${decPart}")
}
