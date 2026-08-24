// L1-031 到底是不是太胖了 - compare with 10% tolerance
import std.env.*
import std.convert.*
import std.math.*
main() {
    let cin = getStdIn()
    var lines = Array<String>(0, repeat: "")
    while (let Some(line) <- cin.readln()) {
        if (line.trimAscii().size == 0) { continue }
        var tmp = Array<String>(lines.size + 1, repeat: "")
        var i: Int64 = 0
        while (i < lines.size) { tmp[i] = lines[i]; i += 1 }
        tmp[lines.size] = line.trimAscii()
        lines = tmp
    }
    if (lines.size == 0) { return }
    let n = Int64.parse(lines[0])
    var idx: Int64 = 1
    var cnt: Int64 = 0
    while (cnt < n && idx < lines.size) {
        let line = lines[idx]
        var parts = Array<String>(0, repeat: "")
        var norm = ""
        for (c in line.toRuneArray()) {
            if (c == r'\t') { norm += " " } else { norm += c.toString() }
        }
        let toks = norm.split(" ")
        for (p in toks) {
            if (p.trimAscii().size > 0) {
                var tmp2 = Array<String>(parts.size + 1, repeat: "")
                var k: Int64 = 0
                while (k < parts.size) { tmp2[k] = parts[k]; k += 1 }
                tmp2[parts.size] = p.trimAscii()
                parts = tmp2
            }
        }
        if (parts.size >= 2) {
            let h = Int64.parse(parts[0])
            let w = Int64.parse(parts[1])
            let stdW = (Float64(h) - 100.0) * 0.9 * 2.0
            let diff = Float64(w) - stdW
            let tol = stdW * 0.1
            let ad = abs(diff)
            if (ad < tol) {
                println("You are wan mei!")
            } else if (diff > 0.0) {
                println("You are tai pang le!")
            } else {
                println("You are tai shou le!")
            }
        }
        cnt += 1
        idx += 1
    }
}
