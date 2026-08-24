// L3-029 还原文件 - 拼接顺序还原
import std.collection.*
import std.convert.*
import std.env.*

var B: Array<Int64> = []
var strips: Array<Array<Int64>> = []
var lens: Array<Int64> = []
var used: Array<Bool> = []
var order: ArrayList<Int64> = ArrayList<Int64>()
var n: Int64 = 0
var m: Int64 = 0

func matches(pos: Int64, sid: Int64): Bool {
    let K = lens[sid]
    if (pos + K > n) { return false }
    let arr = strips[sid]
    for (j in 0..K) {
        if (arr[j] != B[pos + j]) { return false }
    }
    return true
}
func dfs(pos: Int64, depth: Int64): Bool {
    if (depth == m) {
        return pos == n - 1
    }
    if (pos >= n) { return false }
    for (i in 0..m) {
        if (used[i]) { continue }
        if (!matches(pos, i)) { continue }
        used[i] = true
        order.add(i + 1)
        let K = lens[i]
        let nextPos = pos + K - 1
        if (dfs(nextPos, depth + 1)) {
            return true
        }
        used[i] = false
        // pop last
        var tmp = ArrayList<Int64>()
        for (k in 0..order.size) {
            if (k < order.size - 1) { tmp.add(order[k]) }
        }
        order = tmp
    }
    return false
}

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().size == 0) { return }
    let tmp = all.replace("\n", " ").replace("\r", " ").replace("\t", " ")
    let parts = tmp.split(" ")
    let toks = ArrayList<String>()
    for (p in parts) {
        if (p.size > 0) { toks.add(p) }
    }
    var idx: Int64 = 0
    n = Int64.parse(toks[idx]); idx++
    B = Array<Int64>(n, repeat: 0)
    for (i in 0..n) {
        B[i] = Int64.parse(toks[idx]); idx++
    }
    m = Int64.parse(toks[idx]); idx++
    strips = Array<Array<Int64>>(m, repeat: [])
    lens = Array<Int64>(m, repeat: 0)
    for (i in 0..m) {
        let K = Int64.parse(toks[idx]); idx++
        lens[i] = K
        let arr = Array<Int64>(K, repeat: 0)
        for (j in 0..K) {
            arr[j] = Int64.parse(toks[idx]); idx++
        }
        strips[i] = arr
    }
    if (m == 1) {
        println("1")
        return
    }
    used = Array<Bool>(m, repeat: false)
    order = ArrayList<Int64>()
    let ok = dfs(0, 0)
    if (order.size == m) {
        let sb = StringBuilder()
        for (i in 0..order.size) {
            if (i>0) { sb.append(" ") }
            sb.append(order[i].toString())
        }
        println(sb.toString())
    }
}
