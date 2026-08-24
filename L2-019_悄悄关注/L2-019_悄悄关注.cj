// L2-019 悄悄关注 - 平均点赞过滤
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
    let follows = HashSet<String>()
    for (_ in 0..N) { follows.add(next()) }
    let M = Int64.parse(next())
    let likes = HashMap<String, Int64>()
    var total: Int64 = 0
    for (_ in 0..M) {
        let id = next()
        let cnt = Int64.parse(next())
        likes[id] = cnt
        total += cnt
    }
    let avg = if (M == 0) { 0.0 } else { Float64(total) / Float64(M) }
    let suspects = ArrayList<String>()
    for ((k, v) in likes) {
        if (!follows.contains(k) && Float64(v) > avg) { suspects.add(k) }
    }
    if (suspects.size == 0) { println("Bing Mei You"); return }
    sort(suspects)
    for (s in suspects) { println(s) }
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
