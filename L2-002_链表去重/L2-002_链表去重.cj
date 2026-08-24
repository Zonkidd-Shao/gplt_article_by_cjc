// L2-002 链表去重
import std.env.*
import std.collection.*
import std.convert.*
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
        if (isSpace) {
            if (inTok) { tokens.add(sb.toString()); sb=StringBuilder(); inTok=false }
        } else { sb.append(ch); inTok=true }
    }
    if (inTok) { tokens.add(sb.toString()) }
    if (tokens.size < 2) { return }
    let head = tokens[0]
    let n = Int64.parse(tokens[1])
    var mapKey = HashMap<String, Int64>()
    var mapNext = HashMap<String, String>()
    var pos: Int64 = 2
    for (_ in 0..n) {
        if (pos + 2 >= tokens.size) { break }
        let addr = tokens[pos]
        let key = Int64.parse(tokens[pos+1])
        let nxt = tokens[pos+2]
        pos += 3
        mapKey[addr] = key
        mapNext[addr] = nxt
    }
    var seen = HashSet<Int64>()
    var keep = ArrayList<String>()
    var del = ArrayList<String>()
    var cur = head
    while (cur != "-1") {
        if (!mapKey.contains(cur)) { break }
        let k = mapKey[cur]
        let nxt = mapNext[cur]
        let absK = if (k < 0) { -k } else { k }
        if (!seen.contains(absK)) {
            seen.add(absK)
            keep.add(cur)
        } else {
            del.add(cur)
        }
        cur = nxt
    }
    // helper to format address
    func fmt(addr: String): String {
        if (addr == "-1") { return "-1" }
        var r = addr
        while (r.size < 5) { r = "0" + r }
        return r
    }
    // output keep
    for (i in 0..keep.size) {
        let addr = keep[i]
        let key = mapKey[addr]
        var nxtStr: String = "-1"
        if (i + 1 < keep.size) { nxtStr = keep[i+1] }
        println("${fmt(addr)} ${key} ${fmt(nxtStr)}")
    }
    for (i in 0..del.size) {
        let addr = del[i]
        let key = mapKey[addr]
        var nxtStr: String = "-1"
        if (i + 1 < del.size) { nxtStr = del[i+1] }
        println("${fmt(addr)} ${key} ${fmt(nxtStr)}")
    }
}
