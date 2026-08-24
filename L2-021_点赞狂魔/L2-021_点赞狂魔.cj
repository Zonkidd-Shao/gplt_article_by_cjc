// L2-021 点赞狂魔 - 不同标签数排序
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
    let users = ArrayList<(String, Int64, Float64)>()
    for (_ in 0..N) {
        let name = next()
        let K = Int64.parse(next())
        let set = HashSet<String>()
        for (_2 in 0..K) { set.add(next()) }
        let distinct: Int64 = set.size
        let avg = if (distinct == 0) { 0.0 } else { Float64(K) / Float64(distinct) }
        users.add((name, distinct, avg))
    }
    sort(users, by: { a,b =>
        if (a[1] != b[1]) {
            if (a[1] > b[1]) { Ordering.LT } else { Ordering.GT }
        } else if (a[2] != b[2]) {
            if (a[2] < b[2]) { Ordering.LT } else { Ordering.GT }
        } else { Ordering.EQ }
    })
    let res = ArrayList<String>()
    for (i in 0..3) {
        if (i < users.size) { res.add(users[i][0]) } else { res.add("-") }
    }
    println("${res[0]} ${res[1]} ${res[2]}")
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
