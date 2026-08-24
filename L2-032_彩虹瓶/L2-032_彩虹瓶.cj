// L2-032 彩虹瓶 - 栈模拟
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let toks = tokenize(all)
    var idx: Int64 = 0
    func next(): String { let v = toks[idx]; idx++; return v }
    let N = Int64.parse(next())
    let M = Int64.parse(next())
    let K = Int64.parse(next())
    let sb = StringBuilder()
    for (_ in 0..K) {
        let order = ArrayList<Int64>()
        for (_2 in 0..N) { order.add(Int64.parse(next())) }
        var need: Int64 = 1
        let stack = ArrayList<Int64>()
        var ok = true
        for (c in order) {
            if (!ok) { break }
            if (c == need) {
                need += 1
                while (stack.size > 0 && stack[stack.size-1] == need) {
                    stack.remove(at: stack.size-1)
                    need += 1
                }
            } else {
                if (stack.size >= M) { ok = false; break }
                stack.add(c)
            }
        }
        while (ok && stack.size > 0 && stack[stack.size-1] == need) {
            stack.remove(at: stack.size-1)
            need += 1
        }
        sb.append(if (ok && stack.size == 0 && need == N+1) {"YES\n"} else {"NO\n"})
    }
    print(sb.toString())
}

func tokenize(s: String): Array<String> {
    let res = ArrayList<String>()
    var cur = StringBuilder()
    for (r in s.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) { res.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(rs) }
    }
    if (cur.size > 0) { res.add(cur.toString()) }
    return res.toArray()
}
