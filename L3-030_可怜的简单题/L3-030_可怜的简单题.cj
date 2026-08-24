// L3-030 可怜的简单题 - 期望长度
import std.collection.*
import std.convert.*
import std.env.*

var limit: Int64 = 1000000
var mu: Array<Int64> = []
var pref: Array<Int64> = []
var memo: HashMap<Int64, Int64> = HashMap<Int64, Int64>()

func mulMod(a: Int64, b: Int64, mod: Int64): Int64 {
    var res: Int64 = 0
    var aa = a % mod
    var bb = b
    while (bb > 0) {
        if ((bb & 1) == 1) {
            res = (res + aa) % mod
        }
        aa = (aa * 2) % mod
        bb = bb >> 1
    }
    return res
}
func powMod(a: Int64, e: Int64, mod: Int64): Int64 {
    var res: Int64 = 1 % mod
    var base = a % mod
    var exp = e
    while (exp > 0) {
        if ((exp & 1) == 1) {
            res = mulMod(res, base, mod)
        }
        base = mulMod(base, base, mod)
        exp = exp >> 1
    }
    return res
}
func mertens(n: Int64): Int64 {
    if (n <= limit) {
        return pref[n]
    }
    if (memo.contains(n)) {
        return memo[n]
    }
    var res: Int64 = 1
    var l: Int64 = 2
    while (l <= n) {
        let q = n / l
        let r = n / q
        let cnt = r - l + 1
        res -= cnt * mertens(q)
        l = r + 1
    }
    memo[n] = res
    return res
}

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().size == 0) { return }
    let tmp = all.replace("\n", " ").replace("\r", " ").replace("\t", " ")
    let parts = tmp.split(" ")
    let toks = ArrayList<String>()
    for (p in parts) {
        if (p.size > 0) { toks.add(p) }
    }
    let n = Int64.parse(toks[0])
    let p = Int64.parse(toks[1])
    if (n == 1) {
        println("1")
        return
    }
    if (n < limit) {
        limit = n
    }
    mu = Array<Int64>(limit+1, repeat: 0)
    pref = Array<Int64>(limit+1, repeat: 0)
    let isComp = Array<Bool>(limit+1, repeat: false)
    let primes = ArrayList<Int64>()
    mu[1]=1
    for (i in 2..limit+1) {
        if (!isComp[i]) {
            primes.add(Int64(i))
            mu[i] = -1
        }
        for (pr in primes) {
            let v = Int64(i) * pr
            if (v > limit) { break }
            isComp[v] = true
            if (Int64(i) % pr == 0) {
                mu[v]=0
                break
            } else {
                mu[v] = -mu[i]
            }
        }
    }
    var s: Int64 = 0
    for (i in 1..limit+1) {
        s += mu[i]
        pref[i]=s
    }
    memo = HashMap<Int64, Int64>()
    let _ = mertens(n)
    let Ls = ArrayList<Int64>()
    let Rs = ArrayList<Int64>()
    let Qs = ArrayList<Int64>()
    var l: Int64 = 2
    while (l <= n) {
        let q = n / l
        let r = n / q
        Ls.add(l)
        Rs.add(r)
        Qs.add(q)
        l = r + 1
    }
    let cnt = Ls.size
    let Ds = Array<Int64>(cnt, repeat: 0)
    for (i in 0..cnt) {
        Ds[i] = n - Qs[i]
    }
    let pref2 = Array<Int64>(cnt+1, repeat: 0)
    pref2[0]=1 % p
    for (i in 0..cnt) {
        pref2[i+1]= mulMod(pref2[i], Ds[i] % p, p)
    }
    let invAll = powMod(pref2[cnt], p-2, p)
    let invs = Array<Int64>(cnt, repeat: 0)
    var cur = invAll
    var i = cnt - 1
    while (i >= 0) {
        invs[i] = mulMod(cur, pref2[i], p)
        cur = mulMod(cur, Ds[i] % p, p)
        i--
    }
    var ans: Int64 = 0
    for (i in 0..cnt) {
        let sumMu = mertens(Rs[i]) - mertens(Ls[i]-1)
        if (sumMu == 0) { continue }
        let q = Qs[i]
        let inv = invs[i]
        var sumMuMod = sumMu % p
        if (sumMuMod < 0) { sumMuMod += p }
        let term = mulMod(mulMod(sumMuMod, q % p, p), inv, p)
        ans = (ans + term) % p
    }
    var E = (1 - ans) % p
    if (E < 0) { E += p }
    println(E.toString())
}
