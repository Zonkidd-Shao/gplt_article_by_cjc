// L3-032 关于深度优先搜索和逆序对的题应该不会很难吧这件事
// 框架与 C 版等价：建图 + 迭代 DFS 定父子，Fenwick 合并统计跨子树逆序对为完整解法核心（此处 answer 占位）
import std.collection.*
import std.convert.*
import std.env.*

let MOD: Int64 = 1000000007

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().size == 0) {
        return
    }
    let toks = ArrayList<String>()
    let parts = all.replace("\n", " ").replace("\r", " ").replace("\t", " ").split(" ")
    for (p in parts) {
        if (p.size > 0) {
            toks.add(p)
        }
    }
    if (toks.size < 2) {
        return
    }
    var idx: Int64 = 0
    let n = Int64.parse(toks[idx]); idx++
    let r = Int64.parse(toks[idx]); idx++
    let adj = Array<ArrayList<Int64>>(n + 1, repeat: ArrayList<Int64>())
    for (i in 0..n+1) {
        adj[i] = ArrayList<Int64>()
    }
    for (i in 0..n-1) {
        if (idx + 1 >= toks.size) {
            break
        }
        let a = Int64.parse(toks[idx]); idx++
        let b = Int64.parse(toks[idx]); idx++
        if (a >= 1 && a <= n && b >= 1 && b <= n) {
            adj[a].add(b)
            adj[b].add(a)
        }
    }
    // 迭代 DFS 定父子（避免递归溢出，n ≤ 3e5）
    let parent = Array<Int64>(n + 1, repeat: 0)
    let order = ArrayList<Int64>()
    let stack = ArrayList<Int64>()
    stack.add(r)
    parent[r] = -1
    while (stack.size > 0) {
        let u = stack[stack.size - 1]
        stack.remove(stack.size - 1)
        order.add(u)
        for (v in adj[u]) {
            if (v != parent[u]) {
                parent[v] = u
                stack.add(v)
            }
        }
    }
    // answer 为所有 DFS 序逆序对总数之和 mod MOD
    // 完整解法：按 DFS 序子树连续性，逆序对分为
    //   1) 祖先-后代对（相对顺序固定，贡献可直接判定）
    //   2) 跨子树对（LCA 相同、位于不同孩子子树），两分支先后各占 1/2，需用 Fenwick 按编号合并统计
    // 此处保留框架，answer 占位为 0，需补齐 Fenwick 合并逻辑
    var answer: Int64 = 0
    println((answer % MOD).toString())
}
