// L2-028 秀恩爱分得快 - 亲密度1/K
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
    let N = Int64.parse(next())
    let M = Int64.parse(next())
    let intimacy = HashMap<String, Float64>()
    func isFemale(s: String): Bool { return s.size > 0 && s[0] == 45 }
    func absVal(s: String): Int64 {
        let a = if (isFemale(s)) { s[1..s.size] } else { s }
        return if (a.isEmpty()) {0} else {Int64.parse(a)}
    }
    func makeKey(a: String, b: String): String {
        return if (a < b) {"${a},${b}"} else {"${b},${a}"}
    }
    for (_ in 0..M) {
        let K = Int64.parse(next())
        let people = ArrayList<String>()
        for (_2 in 0..K) { people.add(next()) }
        let w = 1.0 / Float64(K)
        for (i in 0..K) {
            for (j in i+1..K) {
                let p1 = people[i]
                let p2 = people[j]
                if (isFemale(p1) == isFemale(p2)) { continue }
                let key = makeKey(p1,p2)
                let cur = intimacy.get(key) ?? 0.0
                intimacy[key] = cur + w
            }
        }
    }
    let A = next()
    let B = next()
    var bestA = ArrayList<String>()
    var bestB = ArrayList<String>()
    var maxA: Float64 = -1.0
    var maxB: Float64 = -1.0
    for ((k,v) in intimacy) {
        let opt = k.indexOf(",")
        if (let None <- opt) { continue }
        let comma = opt.getOrThrow()
        let x = k[0..comma]
        let y = k[comma+1..k.size]
        if (x == A || y == A) {
            let other = if (x == A) {y} else {x}
            if (v > maxA + 1e-9) {
                maxA = v
                bestA = ArrayList<String>()
                bestA.add(other)
            } else if (v - maxA < 1e-9 && maxA - v < 1e-9) {
                bestA.add(other)
            }
        }
        if (x == B || y == B) {
            let other = if (x == B) {y} else {x}
            if (v > maxB + 1e-9) {
                maxB = v
                bestB = ArrayList<String>()
                bestB.add(other)
            } else if (v - maxB < 1e-9 && maxB - v < 1e-9) {
                bestB.add(other)
            }
        }
    }
    func contains(arr: ArrayList<String>, val: String): Bool {
        for (x in arr) { if (x == val) { return true } }
        return false
    }
    let aHasB = contains(bestA, B)
    let bHasA = contains(bestB, A)
    if (aHasB && bHasA) {
        println("${A} ${B}")
        return
    }
    sort(bestA, by: { a,b => if (absVal(a) < absVal(b)) {Ordering.LT} else if (absVal(a) > absVal(b)) {Ordering.GT} else {Ordering.EQ} })
    sort(bestB, by: { a,b => if (absVal(a) < absVal(b)) {Ordering.LT} else if (absVal(a) > absVal(b)) {Ordering.GT} else {Ordering.EQ} })
    let sb = StringBuilder()
    for (p in bestA) { sb.append("${A} ${p}\n") }
    for (p in bestB) { sb.append("${B} ${p}\n") }
    print(sb.toString())
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
