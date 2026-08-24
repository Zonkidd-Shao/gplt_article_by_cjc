// L2-010 排座位
import std.env.*
import std.collection.*
import std.convert.*
func find(par: ArrayList<Int64>, x: Int64): Int64 {
    let p = par[x]
    if (p != x) {
        let r = find(par, p)
        par[x] = r
        return r
    }
    return p
}
func union(par: ArrayList<Int64>, a: Int64, b: Int64) {
    let ra = find(par, a)
    let rb = find(par, b)
    if (ra != rb) { par[rb] = ra }
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
    if (tokens.size < 3) { return }
    let n = Int64.parse(tokens[0])
    let m = Int64.parse(tokens[1])
    let k = Int64.parse(tokens[2])
    var par = ArrayList<Int64>()
    for (i in 0..(n+1)) { par.add(i) }
    // enemy matrix: use ArrayList<ArrayList<Bool>>
    var enemy = ArrayList<ArrayList<Bool>>()
    for (_ in 0..(n+1)) {
        var row = ArrayList<Bool>()
        for (_ in 0..(n+1)) { row.add(false) }
        enemy.add(row)
    }
    var pos: Int64 = 3
    for (_ in 0..m) {
        if (pos+2 >= tokens.size) { break }
        let a = Int64.parse(tokens[pos]); let b = Int64.parse(tokens[pos+1]); let r = Int64.parse(tokens[pos+2]); pos+=3
        if (r == 1) { union(par, a, b) }
        else { enemy[a][b] = true; enemy[b][a] = true }
    }
    for (_ in 0..k) {
        if (pos+1 >= tokens.size) { break }
        let a = Int64.parse(tokens[pos]); let b = Int64.parse(tokens[pos+1]); pos+=2
        let isFriend = find(par, a) == find(par, b)
        let isEnemy = enemy[a][b]
        if (isFriend && !isEnemy) {
            println("No problem")
        } else if (!isFriend && !isEnemy) {
            println("OK")
        } else if (isEnemy) {
            var hasCommon = false
            for (c in 1..(n+1)) {
                if (c == a || c == b) { continue }
                let fa = find(par, a) == find(par, c)
                let fb = find(par, b) == find(par, c)
                if (fa && fb) { hasCommon = true; break }
            }
            if (hasCommon) { println("OK but...") } else { println("No way") }
        } else {
            // isFriend && isEnemy already handled? Actually isEnemy true case above covers
            println("OK")
        }
    }
}
