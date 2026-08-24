// L1-070 吃火锅
import std.env.*
import std.collection.*
import std.convert.*

func contains(hay: String, needle: String): Bool {
    if (needle.size == 0) { return true }
    if (hay.size < needle.size) { return false }
    let ha = hay.toRuneArray()
    let na = needle.toRuneArray()
    let h = Int64(ha.size)
    let n = Int64(na.size)
    for (i in 0..h - n + 1) {
        var ok = true
        for (j in 0..n) {
            if (ha[i + j] != na[j]) { ok = false; break }
        }
        if (ok) { return true }
    }
    return false
}

main() {
    let cin = getStdIn()
    var lines = ArrayList<String>()
    while (let Some(line) <- cin.readln()) {
        lines.add(line)
    }
    var total: Int64 = 0
    var cnt: Int64 = 0
    var first: Int64 = 0
    let kw = "chi1 huo3 guo1"
    for (i in 0..Int64(lines.size)) {
        let s = lines[i]
        if (s == ".") { break }
        total += 1
        if (contains(s, kw)) {
            cnt += 1
            if (first == 0) { first = total }
        }
    }
    println(total)
    if (cnt == 0) {
        println("-_-#")
    } else {
        println("${first} ${cnt}")
    }
}
