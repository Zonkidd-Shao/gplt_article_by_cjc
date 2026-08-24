// L2-027 名人堂与代金券 - 排序排名
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
    let G = Int64.parse(next())
    let K = Int64.parse(next())
    let students = ArrayList<(String, Int64)>()
    var total: Int64 = 0
    for (_ in 0..N) {
        let name = next()
        let score = Int64.parse(next())
        students.add((name, score))
        if (score >= G) { total += 50 } else if (score >= 60) { total += 20 }
    }
    sort(students, by: { a,b =>
        if (a[1] != b[1]) {
            if (a[1] > b[1]) {Ordering.LT} else {Ordering.GT}
        } else {
            if (a[0] < b[0]) {Ordering.LT} else if (a[0] > b[0]) {Ordering.GT} else {Ordering.EQ}
        }
    })
    println("${total}")
    var rank: Int64 = 0
    var prevScore: Int64 = -1
    for (i in 0..students.size) {
        let sc = students[i][1]
        if (sc != prevScore) { rank = i + 1; prevScore = sc }
        if (rank > K) { break }
        println("${rank} ${students[i][0]} ${sc}")
    }
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
