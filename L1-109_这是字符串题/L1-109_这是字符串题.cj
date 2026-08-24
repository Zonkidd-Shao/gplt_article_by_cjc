/* L1-109 这是字符串题 - approach: count letters and sum scores */
import std.env.*
import std.collection.*
import std.convert.*
main() {
    let cin = getStdIn()
    var all = ArrayList<String>()
    while (let Some(line) <- cin.readln()) {
        // keep empty lines? but tokens needed
        all.add(line)
    }
    if (all.size == 0) { return }
    let s = all[0].trimAscii()
    var scores = ArrayList<Int64>()
    // tokens after first line
    var tokens = ArrayList<String>()
    for (idx in 1..Int64(all.size)) {
        let parts = all[Int64(idx)].split(" ")
        for (p in parts) {
            let t = p.trimAscii()
            if (t.size != 0) { tokens.add(t) }
        }
    }
    for (t in tokens) {
        if (scores.size < 26) { scores.add(Int64.parse(t)) }
    }
    // pad if missing (should not)
    while (scores.size < 26) { scores.add(0) }
    var cnt = Array<Int64>(26, repeat: 0)
    let alphabet = "abcdefghijklmnopqrstuvwxyz".toRuneArray()
    let sRunes = s.toRuneArray()
    var beauty: Int64 = 0
    var xpmclzjkln: Int64 = 0
    for (ch in sRunes) {
        var idxFound: Int64 = -1
        for (k in 0..26) {
            if (alphabet[k] == ch) {
                idxFound = Int64(k)
                break
            }
        }
        if (idxFound >= 0) {
            cnt[Int64(idxFound)] += 1
            beauty += scores[Int64(idxFound)]
            xpmclzjkln += scores[Int64(idxFound)]
        }
    }
    // output first line counts
    let sb = StringBuilder()
    for (i in 0..26) {
        if (i > 0) { sb.append(" ") }
        sb.append(cnt[i].toString())
    }
    println(sb.toString())
    println(beauty)
    // use xpmclzjkln to suppress unused warning
    if (xpmclzjkln == 9223372036854775807) { println(xpmclzjkln) }
}
