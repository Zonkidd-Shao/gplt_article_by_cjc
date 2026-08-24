// L2-004 这是二叉搜索树吗？
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
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    var nums = ArrayList<Int64>()
    for (i in 1..(n+1)) {
        if (i < tokens.size) { nums.add(Int64.parse(tokens[i])) }
    }
    var post = ArrayList<Int64>()
    if (checkBST(nums, 0, n-1, post, false)) {
        println("YES")
        printArr(post)
    } else {
        post = ArrayList<Int64>()
        if (checkBST(nums, 0, n-1, post, true)) {
            println("YES")
            printArr(post)
        } else {
            println("NO")
        }
    }
}
func checkBST(a: ArrayList<Int64>, l: Int64, r: Int64, post: ArrayList<Int64>, isMirror: Bool): Bool {
    if (l > r) { return true }
    if (l == r) { post.add(a[l]); return true }
    let root = a[l]
    var i: Int64 = l + 1
    if (!isMirror) {
        while (i <= r && a[i] < root) { i += 1 }
        // check remaining >= root
        var j = i
        while (j <= r) {
            if (a[j] < root) { return false }
            j += 1
        }
        if (!checkBST(a, l+1, i-1, post, isMirror)) { return false }
        if (!checkBST(a, i, r, post, isMirror)) { return false }
        post.add(root)
        return true
    } else {
        while (i <= r && a[i] >= root) { i += 1 }
        var j = i
        while (j <= r) {
            if (a[j] >= root) { return false }
            j += 1
        }
        if (!checkBST(a, l+1, i-1, post, isMirror)) { return false }
        if (!checkBST(a, i, r, post, isMirror)) { return false }
        post.add(root)
        return true
    }
}
func printArr(a: ArrayList<Int64>) {
    var out = StringBuilder()
    for (i in 0..a.size) {
        if (i != 0) { out.append(" ") }
        out.append(a[i])
    }
    println(out.toString())
}
