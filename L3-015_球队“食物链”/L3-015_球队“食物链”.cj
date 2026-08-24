// L3-015 球队食物链 - Hamiltonian cycle lex smallest, N<=20
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let toks = tokenize(all)
    var p: Int64 = 0
    func next(): String { let v = toks[p]; p++; return v }
    let N = Int64.parse(next())
    var win = Array<Array<Bool>>(N, { _ => Array<Bool>(N, repeat: false) })
    for (i in 0..N) {
        let line = next()
        let arr = line.toRuneArray()
        for (j in 0..N) {
            if (j < arr.size) {
                let ch = arr[j].toString()
                if (ch == "W") { win[i][j] = true }
                else if (ch == "L") { win[j][i] = true }
                // D and - ignore
            }
        }
    }
    // fix start at 0 (team 1)
    let allMask: Int64 = (1 << N) - 1
    var memo = HashMap<Int64, Int64>() // 1 true 0 false
    func can(mask: Int64, last: Int64): Bool {
        if (mask == allMask) {
            return win[last][0]
        }
        let key = (mask << 5) | last // 5 bits enough for 20
        if (memo.contains(key)) {
            return memo[key] == 1
        }
        for (nxt in 0..N) {
            if (((mask >> nxt) & 1) == 0 && win[last][nxt]) {
                if (can(mask | (1 << nxt), nxt)) {
                    memo[key] = 1
                    return true
                }
            }
        }
        memo[key] = 0
        return false
    }
    if (!can(1, 0)) {
        println("No Solution")
        return
    }
    var path = ArrayList<Int64>()
    path.add(0)
    var mask: Int64 = 1
    var last: Int64 = 0
    while (path.size < N) {
        var found = false
        for (nxt in 0..N) {
            if (((mask >> nxt) & 1) != 0) { continue }
            if (!win[last][nxt]) { continue }
            if (can(mask | (1 << nxt), nxt)) {
                path.add(nxt)
                mask = mask | (1 << nxt)
                last = nxt
                found = true
                break
            }
        }
        if (!found) { break }
    }
    if (path.size != N) {
        println("No Solution")
        return
    }
    // check final edge to start (already ensured by can)
    let sb = StringBuilder()
    for (i in 0..path.size) {
        if (i != 0) { sb.append(" ") }
        sb.append(path[i] + 1)
    }
    println(sb.toString())
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
