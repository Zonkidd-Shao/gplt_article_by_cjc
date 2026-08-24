// L3-042 污染大亨
import std.collection.*
import std.convert.*
import std.env.*

let MOD: Int64 = 998244353

func modPow(a: Int64, e: Int64): Int64 {
    var r: Int64 = 1
    var b = a % MOD
    var ee = e
    while (ee > 0) {
        if ((ee & 1) == 1) { r = r * b % MOD }
        b = b * b % MOD
        ee >>= 1
    }
    return r
}

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().size == 0) { return }
    let tmp = all.replace("\n", " ").replace("\r", " ").replace("\t", " ")
    let parts = tmp.split(" ")
    let toks = ArrayList<String>()
    for (p in parts) { if (p.size>0) { toks.add(p) } }
    var idx: Int64 = 0
    let n = Int64.parse(toks[idx]); idx++
    let f = Array<Int64>(n+1, repeat: 0)
    for (i in 2..n+1) {
        f[i]=Int64.parse(toks[idx]); idx++
    }
    let c = Array<Int64>(n+1, repeat: 0)
    for (i in 1..n+1) { c[i]=Int64.parse(toks[idx]); idx++ }
    let children = Array<ArrayList<Int64>>(n+1, repeat: ArrayList<Int64>())
    for (i in 0..n+1) { children[i]=ArrayList<Int64>() }
    for (i in 2..n+1) { children[f[i]].add(i) }
    if (n > 15) {
        println("0")
        return
    }
    let subMask = Array<UInt64>(n+1, repeat: UInt64(0))
    func dfsMask(u: Int64): UInt64 {
        var m: UInt64 = UInt64(1) << UInt64(u-1)
        for (v in children[u]) {
            m = m | dfsMask(v)
        }
        subMask[u]=m
        return m
    }
    dfsMask(1)
    let totalMask: UInt64 = (UInt64(1) << UInt64(n)) - UInt64(1)
    let memo2 = HashMap<String, Int64>()
    func solve2(mask: UInt64, step: Int64): Int64 {
        let key = "${mask},${step}"
        if (memo2.contains(key)) { return memo2[key] }
        if (mask == totalMask) { memo2[key]=1; return 1 }
        var res: Int64 = 0
        for (u in 1..n+1) {
            let bit = UInt64(1) << UInt64(u-1)
            if ((mask & bit) != UInt64(0)) { continue }
            let newMask = mask | subMask[u]
            var cnt: Int64 = 0
            var tm = subMask[u]
            while (tm != UInt64(0)) { if ((tm & UInt64(1)) != UInt64(0)) { cnt++ }; tm >>= 1 }
            let add = modPow(c[step+1], cnt)
            let sub = solve2(newMask, step+1)
            res = (res + add * sub) % MOD
        }
        memo2[key]=res
        return res
    }
    let ans = solve2(UInt64(0), 0)
    println(ans.toString())
}
