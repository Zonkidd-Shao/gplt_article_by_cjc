// L2-011 玩转二叉树 - inorder+pre -> mirrored level
import std.env.*
import std.collection.*
import std.convert.*
var gIn = ArrayList<Int64>()
var gPre = ArrayList<Int64>()
var nodeVal = ArrayList<Int64>()
var nodeLeft = ArrayList<Int64>()
var nodeRight = ArrayList<Int64>()
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
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    gIn = ArrayList<Int64>()
    gPre = ArrayList<Int64>()
    for (i in 0..n) {
        let idx = 1 + i
        if (idx < tokens.size) { gIn.add(Int64.parse(tokens[idx])) }
    }
    for (i in 0..n) {
        let idx = 1 + n + i
        if (idx < tokens.size) { gPre.add(Int64.parse(tokens[idx])) }
    }
    nodeVal = ArrayList<Int64>()
    nodeLeft = ArrayList<Int64>()
    nodeRight = ArrayList<Int64>()
    let root = build(0, n-1, 0, n-1)
    if (root == -1) { return }
    // mirror: swap left/right for all nodes
    var stack = ArrayList<Int64>()
    stack.add(root)
    var si: Int64 = 0
    while (si < stack.size) {
        let cur = stack[si]; si+=1
        let l = nodeLeft[cur]
        let r = nodeRight[cur]
        nodeLeft[cur] = r
        nodeRight[cur] = l
        if (l != -1) { stack.add(l) }
        if (r != -1) { stack.add(r) }
    }
    // level order
    var q = ArrayList<Int64>()
    q.add(root)
    var head: Int64 = 0
    var res = ArrayList<Int64>()
    while (head < q.size) {
        let cur = q[head]; head+=1
        res.add(nodeVal[cur])
        let l = nodeLeft[cur]
        let r = nodeRight[cur]
        if (l != -1) { q.add(l) }
        if (r != -1) { q.add(r) }
    }
    var out = StringBuilder()
    for (i in 0..res.size) {
        if (i != 0) { out.append(" ") }
        out.append(res[i])
    }
    println(out.toString())
}
func newNode(v: Int64): Int64 {
    let id = nodeVal.size
    nodeVal.add(v)
    nodeLeft.add(-1)
    nodeRight.add(-1)
    return id
}
func build(is_: Int64, ie: Int64, ps: Int64, pe: Int64): Int64 {
    if (is_ > ie || ps > pe) { return -1 }
    let rv = gPre[ps]
    let id = newNode(rv)
    var idx: Int64 = is_
    while (idx <= ie) {
        if (gIn[idx] == rv) { break }
        idx+=1
    }
    let leftSize = idx - is_
    let leftId = build(is_, idx-1, ps+1, ps+leftSize)
    let rightId = build(idx+1, ie, ps+leftSize+1, pe)
    nodeLeft[id] = leftId
    nodeRight[id] = rightId
    return id
}
