// L3-016 二叉搜索树的结构 - build BST and answer queries
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    // split lines preserving statements with spaces
    // Use manual line split by '\n'
    var lines = ArrayList<String>()
    var curLine = StringBuilder()
    for (r in all.toRuneArray()) {
        let rs = r.toString()
        if (rs == "\n") {
            lines.add(curLine.toString())
            curLine = StringBuilder()
        } else if (rs == "\r") {
            // ignore
        } else {
            curLine.append(rs)
        }
    }
    lines.add(curLine.toString())
    var idx: Int64 = 0
    func skipEmpty(): Unit {
        while (idx < lines.size && lines[idx].trimAscii().isEmpty()) { idx++ }
    }
    func nextLine(): String {
        skipEmpty()
        if (idx >= lines.size) { return "" }
        let v = lines[idx]
        idx++
        return v
    }
    // also need token helper for first lines that may be split
    let first = nextLine().trimAscii()
    let N = Int64.parse(first)
    var nums = ArrayList<Int64>()
    while (nums.size < N) {
        let line = nextLine()
        // split line by whitespace manually
        var cur = StringBuilder()
        for (r in line.toRuneArray()) {
            let rs = r.toString()
            if (rs == " " || rs == "\t") {
                if (cur.size > 0) { nums.add(Int64.parse(cur.toString())); cur = StringBuilder() }
            } else { cur.append(rs) }
        }
        if (cur.size > 0) { nums.add(Int64.parse(cur.toString())) }
    }
    let mLine = nextLine().trimAscii()
    let M = Int64.parse(mLine)
    var queries = ArrayList<String>()
    for (_ in 0..M) {
        // queries may be empty? take raw line (including spaces)
        // Use nextLine that skips empties, but queries are non-empty
        let q = nextLine()
        queries.add(q)
    }
    // Build BST
    let parent = HashMap<Int64, Int64>()
    let left = HashMap<Int64, Int64>()
    let right = HashMap<Int64, Int64>()
    let depth = HashMap<Int64, Int64>()
    let exists = HashSet<Int64>()
    var root: Int64 = 0
    var hasRoot = false
    for (v in nums) {
        exists.add(v)
        if (!hasRoot) {
            root = v
            hasRoot = true
            depth[v] = 0
        } else {
            var cur = root
            while (true) {
                if (v < cur) {
                    if (left.contains(cur)) {
                        cur = left[cur]
                    } else {
                        left[cur] = v
                        parent[v] = cur
                        depth[v] = depth[cur] + 1
                        break
                    }
                } else {
                    if (right.contains(cur)) {
                        cur = right[cur]
                    } else {
                        right[cur] = v
                        parent[v] = cur
                        depth[v] = depth[cur] + 1
                        break
                    }
                }
            }
        }
    }
    func splitTokens(s: String): Array<String> {
        var res = ArrayList<String>()
        var cur = StringBuilder()
        for (r in s.toRuneArray()) {
            let ch = r.toString()
            if (ch == " " || ch == "\t") {
                if (cur.size > 0) { res.add(cur.toString()); cur = StringBuilder() }
            } else { cur.append(ch) }
        }
        if (cur.size > 0) { res.add(cur.toString()) }
        return res.toArray()
    }
    func extractInts(s: String): Array<Int64> {
        let toks = splitTokens(s)
        var res = ArrayList<Int64>()
        for (tok in toks) {
            // try parse if numeric
            var isNum = true
            if (tok.isEmpty()) { continue }
            var start: Int64 = 0
            if (tok[0].toString() == "-") { start = 1; if (tok.size == 1) { continue } }
            for (k in start..tok.size) {
                let c = tok[k].toString()
                if (c < "0" || c > "9") { isNum = false; break }
            }
            if (isNum) { res.add(Int64.parse(tok)) }
        }
        return res.toArray()
    }
    let out = StringBuilder()
    for (q in queries) {
        let s = q.trimAscii()
        var ans = "No"
        let toksQ = splitTokens(s)
        if (s.contains("is the root")) {
            if (toksQ.size >= 1) {
                let a = Int64.parse(toksQ[0])
                if (hasRoot && a == root) { ans = "Yes" }
            }
        } else if (s.contains("are siblings")) {
            if (toksQ.size >= 3) {
                let a = Int64.parse(toksQ[0]); let b = Int64.parse(toksQ[2])
                if (exists.contains(a) && exists.contains(b) && parent.contains(a) && parent.contains(b) && parent[a] == parent[b]) {
                    ans = "Yes"
                }
            }
        } else if (s.contains("is the parent of")) {
            if (toksQ.size >= 6) {
                let a = Int64.parse(toksQ[0]); let b = Int64.parse(toksQ[5])
                if (parent.contains(b) && parent[b] == a) { ans = "Yes" }
            }
        } else if (s.contains("is the left child of")) {
            if (toksQ.size >= 7) {
                let a = Int64.parse(toksQ[0]); let b = Int64.parse(toksQ[6])
                if (left.contains(b) && left[b] == a) { ans = "Yes" }
            }
        } else if (s.contains("is the right child of")) {
            if (toksQ.size >= 7) {
                let a = Int64.parse(toksQ[0]); let b = Int64.parse(toksQ[6])
                if (right.contains(b) && right[b] == a) { ans = "Yes" }
            }
        } else if (s.contains("are on the same level")) {
            if (toksQ.size >= 3) {
                let a = Int64.parse(toksQ[0]); let b = Int64.parse(toksQ[2])
                if (exists.contains(a) && exists.contains(b) && depth.contains(a) && depth.contains(b) && depth[a]==depth[b]) { ans = "Yes" }
            }
        }
        out.append(ans)
        out.append("\n")
    }
    print(out.toString())
}
