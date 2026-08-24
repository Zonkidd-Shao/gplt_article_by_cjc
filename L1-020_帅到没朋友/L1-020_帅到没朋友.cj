// L1-020 帅到没朋友
// approach: set of people with friends
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    var tokens = ArrayList<String>()
    var cur = StringBuilder()
    for (r in all.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) { tokens.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(rs) }
    }
    if (cur.size > 0) { tokens.add(cur.toString()) }
    var idx: Int64 = 0
    let n = Int64.parse(tokens[idx]); idx += 1
    var hasFriends = HashSet<String>()
    for (_ in 0..n) {
        let k = Int64.parse(tokens[idx]); idx += 1
        if (k > 1) {
            for (j in 0..k) {
                hasFriends.add(tokens[idx+j])
            }
        }
        idx += k
    }
    let m = Int64.parse(tokens[idx]); idx += 1
    var seen = HashSet<String>()
    var result = ArrayList<String>()
    for (i in 0..m) {
        let id = tokens[idx+i]
        if (!hasFriends.contains(id) && !seen.contains(id)) {
            result.add(id)
            seen.add(id)
        }
    }
    if (result.size == 0) {
        println("No one is handsome")
    } else {
        var sb = StringBuilder()
        for (i in 0..Int64(result.size)) {
            if (i > 0) { sb.append(" ") }
            sb.append(result[i])
        }
        println(sb.toString())
    }
}
