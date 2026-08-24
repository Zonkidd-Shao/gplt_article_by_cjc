// L1-022 奇偶分家 - count odd/even
import std.env.*
import std.convert.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    var norm = ""
    for (c in all.toRuneArray()) {
        if (c == r'\n' || c == r'\r' || c == r'\t') {
            norm += " "
        } else {
            norm += c.toString()
        }
    }
    let parts = norm.split(" ")
    var tokens = Array<String>(0, repeat: "")
    // filter empties manually via iteration
    for (p in parts) {
        if (p.trimAscii().size > 0) {
            var tmp = Array<String>(tokens.size + 1, repeat: "")
            var i: Int64 = 0
            while (i < tokens.size) { tmp[i] = tokens[i]; i += 1 }
            tmp[tokens.size] = p.trimAscii()
            tokens = tmp
        }
    }
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    var odd: Int64 = 0
    var even: Int64 = 0
    var idx: Int64 = 1
    var cnt: Int64 = 0
    while (cnt < n && idx < tokens.size) {
        let v = Int64.parse(tokens[idx])
        if (v % 2 == 0) { even += 1 } else { odd += 1 }
        cnt += 1
        idx += 1
    }
    println("${odd} ${even}")
}
