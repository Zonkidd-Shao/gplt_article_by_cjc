// L1-028 判断素数 - trial division up to sqrt
import std.env.*
import std.convert.*
import std.math.*
func isPrime(n: Int64): Bool {
    if (n <= 1) { return false }
    if (n == 2) { return true }
    if (n % 2 == 0) { return false }
    let fn = Float64(n)
    let r = sqrt(fn)
    var limit = Int64(r) + 1
    var i: Int64 = 3
    while (i <= limit) {
        if (n % i == 0) { return false }
        i += 2
    }
    return true
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
    if (toks.size == 0) { return }
    let n = Int64.parse(toks[0])
    var i: Int64 = 1
    var cnt: Int64 = 0
    while (cnt < n && i < toks.size) {
        let v = Int64.parse(toks[i])
        if (isPrime(v)) { println("Yes") } else { println("No") }
        cnt += 1
        i += 1
    }
}
