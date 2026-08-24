// L1-048 矩阵A乘以B — 矩阵乘法或报错
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
    var idx: Int64 = 0
    if (toks.size < 2) { return }
    let ra = Int64.parse(toks[idx]); let ca = Int64.parse(toks[idx+1]); idx += 2
    var A = Array<Array<Int64>>(ra, { _ => Array<Int64>(ca, repeat: 0) })
    var ii: Int64 = 0
    while (ii < ra) {
        var jj: Int64 = 0
        while (jj < ca) {
            A[ii][jj] = Int64.parse(toks[idx]); idx += 1
            jj += 1
        }
        ii += 1
    }
    let rb = Int64.parse(toks[idx]); let cb = Int64.parse(toks[idx+1]); idx += 2
    var B = Array<Array<Int64>>(rb, { _ => Array<Int64>(cb, repeat: 0) })
    ii = 0
    while (ii < rb) {
        var jj: Int64 = 0
        while (jj < cb) {
            B[ii][jj] = Int64.parse(toks[idx]); idx += 1
            jj += 1
        }
        ii += 1
    }
    if (ca != rb) {
        println("Error: ${ca} != ${rb}")
        return
    }
    var C = Array<Array<Int64>>(ra, { _ => Array<Int64>(cb, repeat: 0) })
    ii = 0
    while (ii < ra) {
        var jj: Int64 = 0
        while (jj < cb) {
            var sum: Int64 = 0
            var kk: Int64 = 0
            while (kk < ca) {
                sum += A[ii][kk] * B[kk][jj]
                kk += 1
            }
            C[ii][jj] = sum
            jj += 1
        }
        ii += 1
    }
    println("${ra} ${cb}")
    ii = 0
    while (ii < ra) {
        let sb = StringBuilder()
        var jj: Int64 = 0
        while (jj < cb) {
            if (jj > 0) { sb.append(" ") }
            sb.append(C[ii][jj].toString())
            jj += 1
        }
        println(sb.toString())
        ii += 1
    }
}
