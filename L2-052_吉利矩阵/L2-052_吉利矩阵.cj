// L2-052 吉利矩阵 - 计数
import std.env.*
import std.collection.*
import std.convert.*

func genRows(L: Int64, N: Int64, res: ArrayList<Array<Int64>>): Unit {
    var cur = Array<Int64>(N, repeat: 0)
    func dfs(pos: Int64, rem: Int64): Unit {
        if (pos == N-1) {
            cur[pos]=rem
            var copy = Array<Int64>(N, repeat: 0)
            for (i in 0..N) { copy[i]=cur[i] }
            res.add(copy)
            return
        }
        for (v in 0..=rem) {
            cur[pos]=v
            dfs(pos+1, rem - v)
        }
    }
    dfs(0, L)
}

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.size==0) { return }
    var toks = ArrayList<String>()
    var curSb = StringBuilder()
    for (r in all.toRuneArray()) {
        let s = r.toString()
        if (s==" "||s=="\n"||s=="\r"||s=="\t") {
            if (curSb.toString().size>0) { toks.add(curSb.toString()); curSb=StringBuilder() }
        } else { curSb.append(s) }
    }
    if (curSb.toString().size>0) { toks.add(curSb.toString()) }
    let L = Int64.parse(toks[0]); let N = Int64.parse(toks[1])
    var ans: Int64 = 0
    if (N == 2) {
        ans = L + 1
    } else if (N == 3) {
        var rows = ArrayList<Array<Int64>>()
        genRows(L, N, rows)
        for (r0 in rows) {
            for (r1 in rows) {
                var c0 = r0[0]+r1[0]; var c1 = r0[1]+r1[1]; var c2 = r0[2]+r1[2]
                if (c0 <= L && c1 <= L && c2 <= L) { ans+=1 }
            }
        }
    } else if (N == 4) {
        var rows = ArrayList<Array<Int64>>()
        genRows(L, N, rows)
        for (r0 in rows) {
            for (r1 in rows) {
                let c0_01 = r0[0]+r1[0]; let c1_01 = r0[1]+r1[1]; let c2_01 = r0[2]+r1[2]; let c3_01 = r0[3]+r1[3]
                if (c0_01 > L || c1_01 > L || c2_01 > L || c3_01 > L) { continue }
                for (r2 in rows) {
                    let c0 = c0_01 + r2[0]; let c1 = c1_01 + r2[1]; let c2 = c2_01 + r2[2]; let c3 = c3_01 + r2[3]
                    if (c0 <= L && c1 <= L && c2 <= L && c3 <= L) { ans+=1 }
                }
            }
        }
    }
    println("${ans}")
}
