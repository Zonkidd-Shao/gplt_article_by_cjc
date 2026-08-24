// L2-035 完全二叉树的层序遍历 - 后序转层序
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.size == 0) { return }
    var toks = ArrayList<String>()
    var cur = StringBuilder()
    for (r in all.toRuneArray()) {
        let s = r.toString()
        if (s == " " || s == "\n" || s == "\r" || s == "\t") {
            if (cur.toString().size > 0) { toks.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(s) }
    }
    if (cur.toString().size > 0) { toks.add(cur.toString()) }
    if (toks.size == 0) { return }
    let n = Int64.parse(toks[0])
    if (n == 0) { return }
    var post = Array<Int64>(n, repeat: 0)
    for (i in 0..n) {
        if (i+1 < toks.size) { post[i] = Int64.parse(toks[(i+1)]) }
    }
    var level = Array<Int64>(n+1, repeat: 0)
    build(level, post, 0, n-1, 1)
    var sb = StringBuilder()
    for (i in 1..=n) {
        if (i > 1) { sb.append(" ") }
        sb.append("${level[i]}")
    }
    println(sb.toString())
}
func build(level: Array<Int64>, post: Array<Int64>, l: Int64, r: Int64, pos: Int64): Unit {
    if (l > r) { return }
    if (pos >= level.size) { return }
    let root = post[r]
    level[pos] = root
    let cnt = r - l + 1
    if (cnt == 1) { return }
    let leftSize = getLeftSize(cnt)
    build(level, post, l, l + leftSize - 1, pos*2)
    build(level, post, l + leftSize, r-1, pos*2+1)
}
func getLeftSize(n: Int64): Int64 {
    if (n <= 1) { return 0 }
    var h: Int64 = 0
    while ((1 << (h+1)) <= n+1) { h+=1 }
    let pow: Int64 = 1 << h
    let full = pow - 1
    let last = n - full
    let half = pow / 2
    var left: Int64 = 0
    if (last <= half) {
        left = (half - 1) + last
    } else {
        left = (half - 1) + half
    }
    return left
}
