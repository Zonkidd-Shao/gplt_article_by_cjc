// L2-029 特立独行的幸福 - 幸福数迭代
import std.env.*
import std.collection.*
import std.convert.*
import std.sort.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let toks = tokenize(all)
    var idx: Int64 = 0
    func next(): String { let v = toks[idx]; idx++; return v }
    let A = Int64.parse(next())
    let B = Int64.parse(next())
    let isHappy = HashMap<Int64, Bool>()
    let chainMap = HashMap<Int64, ArrayList<Int64>>()
    let lenMap = HashMap<Int64, Int64>()
    for (n in A..B+1) {
        let res = checkHappy(n)
        let happy = res[0]
        let chain = res[1]
        if (happy) {
            isHappy[n] = true
            chainMap[n] = chain
            lenMap[n] = chain.size
        } else {
            isHappy[n] = false
        }
    }
    let dependent = HashSet<Int64>()
    for ((m, ch) in chainMap) {
        for (i in 1..ch.size) { dependent.add(ch[i]) }
    }
    let resList = ArrayList<(Int64,Int64)>()
    for (n in A..B+1) {
        if (!(isHappy.get(n) ?? false)) { continue }
        if (dependent.contains(n)) { continue }
        var cnt = lenMap.get(n) ?? 0
        if (isPrime(n)) { cnt *= 2 }
        resList.add((n, cnt))
    }
    if (resList.size == 0) {
        println("SAD")
    } else {
        sort(resList, by: { a,b => if (a[0] < b[0]) {Ordering.LT} else if (a[0] > b[0]) {Ordering.GT} else {Ordering.EQ} })
        for ((n,c) in resList) { println("${n} ${c}") }
    }
}

func checkHappy(n: Int64): (Bool, ArrayList<Int64>) {
    var cur = n
    let seen = HashSet<Int64>()
    let chain = ArrayList<Int64>()
    while (true) {
        if (cur == 1) { return (true, chain) }
        if (seen.contains(cur)) { return (false, chain) }
        seen.add(cur)
        chain.add(cur)
        cur = digitSquareSum(cur)
        if (chain.size > 1000) { return (false, chain) }
    }
    return (false, chain)
}

func digitSquareSum(n: Int64): Int64 {
    var s: Int64 = 0
    var x = n
    if (x == 0) { return 0 }
    while (x > 0) {
        let d = x % 10
        s += d * d
        x /= 10
    }
    return s
}

func isPrime(n: Int64): Bool {
    if (n < 2) { return false }
    if (n == 2) { return true }
    if (n % 2 == 0) { return false }
    var i: Int64 = 3
    while (i * i <= n) {
        if (n % i == 0) { return false }
        i += 2
    }
    return true
}

func tokenize(s: String): Array<String> {
    let res = ArrayList<String>()
    var cur = StringBuilder()
    for (r in s.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) { res.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(rs) }
    }
    if (cur.size > 0) { res.add(cur.toString()) }
    return res.toArray()
}
