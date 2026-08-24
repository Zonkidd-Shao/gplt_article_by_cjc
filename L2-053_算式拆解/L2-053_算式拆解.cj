// L2-053 算式拆解 - 按执行顺序输出括号内操作
// Approach: parse fully parenthesized expression into binary tree, post-order left→right→node; printing omits subexpression operands
import std.env.*
import std.collection.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    var s = ""
    for (line in all.split("\n")) {
        let t = line.trimAscii()
        if (t.size > 0) { s = t; break }
    }
    if (s.size == 0) { return }
    let runes = s.toRuneArray()
    var pos: Int64 = 0
    let n: Int64 = runes.size

    let isLeaf = ArrayList<Bool>()
    let vals = ArrayList<String>()
    let ops = ArrayList<String>()
    let lefts = ArrayList<Int64>()
    let rights = ArrayList<Int64>()

    func newLeaf(v: String): Int64 {
        isLeaf.add(true)
        vals.add(v)
        ops.add("")
        lefts.add(-1)
        rights.add(-1)
        return isLeaf.size - 1
    }
    func newNode(op: String, l: Int64, r: Int64): Int64 {
        isLeaf.add(false)
        vals.add("")
        ops.add(op)
        lefts.add(l)
        rights.add(r)
        return isLeaf.size - 1
    }

    func parseNode(): Int64 {
        let lp: Rune = '('
        let rp: Rune = ')'
        if (pos < n && runes[pos] == lp) {
            pos++
            let l = parseNode()
            let opRune = runes[pos]
            let opStr = opRune.toString()
            pos++
            let r = parseNode()
            if (pos < n && runes[pos] == rp) { pos++ }
            return newNode(opStr, l, r)
        } else {
            var start = pos
            let z: Rune = '0'
            let nine: Rune = '9'
            while (pos < n && runes[pos] >= z && runes[pos] <= nine) { pos++ }
            let sb = StringBuilder()
            for (i in start..pos) { sb.append(runes[i]) }
            return newLeaf(sb.toString())
        }
    }

    let root = parseNode()

    let out = ArrayList<String>()
    func dfs(id: Int64): Unit {
        if (isLeaf[id]) { return }
        let l = lefts[id]
        let r = rights[id]
        dfs(l)
        dfs(r)
        let hasLeft = isLeaf[l]
        let hasRight = isLeaf[r]
        var line = ""
        if (hasLeft && hasRight) {
            line = "${vals[l]}${ops[id]}${vals[r]}"
        } else if (hasLeft) {
            line = "${vals[l]}${ops[id]}"
        } else if (hasRight) {
            line = "${ops[id]}${vals[r]}"
        } else {
            line = ops[id]
        }
        out.add(line)
    }
    dfs(root)
    let sb = StringBuilder()
    for (i in 0..out.size) {
        sb.append(out[i])
        sb.append("\n")
    }
    print(sb.toString())
}
