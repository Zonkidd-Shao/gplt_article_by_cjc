// L3-033 教科书般的亵渎 - 概率计算
import std.collection.*
import std.convert.*
import std.env.*

let MOD: Int64 = 998244353

func modPow(a: Int64, e: Int64): Int64 {
    var res: Int64 = 1
    var base = a % MOD
    var exp = e
    while (exp > 0) {
        if ((exp & 1) == 1) { res = res * base % MOD }
        base = base * base % MOD
        exp = exp >> 1
    }
    return res
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
    let K = Int64.parse(toks[idx]); idx++
    let a = Array<Int64>(n, repeat: 0)
    for (i in 0..n) { a[i]=Int64.parse(toks[idx]); idx++ }
    let maxA: Int64 = 50
    let fact = Array<Int64>(maxA+1, repeat: 0)
    fact[0]=1
    for (i in 1..maxA+1) { fact[i]=fact[i-1]*Int64(i)%MOD }
    let invFact = Array<Int64>(maxA+1, repeat: 0)
    invFact[maxA]=modPow(fact[maxA], MOD-2)
    var i = maxA
    while (i > 0) {
        invFact[i-1]=invFact[i]*i%MOD
        i--
    }
    var dp = Array<HashMap<UInt64, Int64>>(K+1, repeat: HashMap<UInt64, Int64>())
    for (i in 0..K+1) { dp[i]=HashMap<UInt64, Int64>() }
    dp[0][UInt64(0)]=1
    for (idxA in 0..n) {
        let ai = a[idxA]
        var ndp = Array<HashMap<UInt64, Int64>>(K+1, repeat: HashMap<UInt64, Int64>())
        for (i in 0..K+1) { ndp[i]=HashMap<UInt64, Int64>() }
        for (rem in 0..K+1) {
            for ((mask, w) in dp[rem]) {
                let maxC = if (ai-1 < K-rem) { ai-1 } else { K-rem }
                for (c in 0..maxC+1) {
                    let b = ai - c
                    let bit: UInt64 = UInt64(1) << UInt64(b-1)
                    let nmask = mask | bit
                    let nrem = rem + c
                    let nw = w * invFact[c] % MOD
                    let cur = if (ndp[nrem].contains(nmask)) { ndp[nrem][nmask] } else { 0 }
                    ndp[nrem][nmask] = (cur + nw) % MOD
                }
            }
        }
        dp = ndp
    }
    var total: Int64 = 0
    for ((mask, w) in dp[K]) {
        if (mask == UInt64(0)) { continue }
        if ((mask & UInt64(1)) == UInt64(0)) { continue }
        if ((mask & (mask + 1)) != UInt64(0)) { continue }
        total = (total + w) % MOD
    }
    let fk = fact[K]
    let invN = modPow(n % MOD, MOD-2)
    let invNPow = modPow(invN, K)
    let ans = total * fk % MOD * invNPow % MOD
    println(ans.toString())
}
