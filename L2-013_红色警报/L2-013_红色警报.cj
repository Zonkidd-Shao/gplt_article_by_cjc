// L2-013 红色警报
import std.env.*
import std.collection.*
import std.convert.*
func find(par: ArrayList<Int64>, x: Int64): Int64 {
    var cur = x
    var root = cur
    while (par[root] != root) { root = par[root] }
    // path compress
    while (par[cur] != root) {
        let nxt = par[cur]
        par[cur] = root
        cur = nxt
    }
    return root
}
func countComp(n: Int64, edges: ArrayList<ArrayList<Int64>>, destroyed: ArrayList<Bool>): Int64 {
    var par = ArrayList<Int64>()
    for (i in 0..n) {
        if (destroyed[i]) { par.add(-1) } else { par.add(i) }
    }
    for (e in edges) {
        let a = e[0]
        let b = e[1]
        if (destroyed[a] || destroyed[b]) { continue }
        let ra = find(par, a)
        let rb = find(par, b)
        if (ra != rb) { par[rb] = ra }
    }
    var cnt: Int64 = 0
    for (i in 0..n) {
        if (!destroyed[i] && par[i] == i) { cnt+=1 }
    }
    return cnt
}
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let sp: Rune = ' '
    let nl: Rune = '\n'
    let cr: Rune = '\r'
    let tab: Rune = '\t'
    var tokens = ArrayList<String>()
    var sb = StringBuilder()
    var inTok = false
    for (ch in all.toRuneArray()) {
        let isSpace = (ch == sp) || (ch == nl) || (ch == cr) || (ch == tab)
        if (isSpace) { if (inTok) { tokens.add(sb.toString()); sb=StringBuilder(); inTok=false } }
        else { sb.append(ch); inTok=true }
    }
    if (inTok) { tokens.add(sb.toString()) }
    if (tokens.size < 2) { return }
    let n = Int64.parse(tokens[0])
    let m = Int64.parse(tokens[1])
    var edges = ArrayList<ArrayList<Int64>>()
    var pos: Int64 = 2
    for (_ in 0..m) {
        if (pos+1 >= tokens.size) { break }
        let a = Int64.parse(tokens[pos]); let b = Int64.parse(tokens[pos+1]); pos+=2
        var e = ArrayList<Int64>()
        e.add(a); e.add(b)
        edges.add(e)
    }
    if (pos >= tokens.size) { return }
    let k = Int64.parse(tokens[pos]); pos+=1
    var attacks = ArrayList<Int64>()
    for (_ in 0..k) {
        if (pos >= tokens.size) { break }
        attacks.add(Int64.parse(tokens[pos])); pos+=1
    }
    var destroyed = ArrayList<Bool>()
    for (_ in 0..n) { destroyed.add(false) }
    var prev = countComp(n, edges, destroyed)
    for (i in 0..k) {
        let city = attacks[i]
        if (city >= 0 && city < n) { destroyed[city] = true }
        let cur = countComp(n, edges, destroyed)
        if (cur > prev) {
            println("Red Alert: City ${city} is lost!")
        } else {
            println("City ${city} is lost.")
        }
        prev = cur
    }
    // Game Over if all cities lost
    var allLost = true
    for (i in 0..n) { if (!destroyed[i]) { allLost = false; break } }
    if (allLost && n > 0) {
        println("Game Over.")
    } else if (k == n && n != 0) {
        // fallback per spec
        // if not allLost but k==n maybe still? but above covers
    }
}
