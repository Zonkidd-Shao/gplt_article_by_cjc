// L2-041 插松枝 - 小盒子栈模拟
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.size==0) { return }
    var toks = ArrayList<String>()
    var cur = StringBuilder()
    for (r in all.toRuneArray()) {
        let s = r.toString()
        if (s==" "||s=="\n"||s=="\r"||s=="\t") {
            if (cur.toString().size>0) { toks.add(cur.toString()); cur=StringBuilder() }
        } else { cur.append(s) }
    }
    if (cur.toString().size>0) { toks.add(cur.toString()) }
    var p: Int64 = 0
    let N = Int64.parse(toks[p]); p+=1
    let BoxCap = Int64.parse(toks[p]); p+=1
    let K = Int64.parse(toks[p]); p+=1
    var push = Array<Int64>(N, repeat: 0)
    for (i in 0..N) { push[i]=Int64.parse(toks[p]); p+=1 }
    var box = ArrayList<Int64>()
    var curBranch = ArrayList<Int64>()
    var results = ArrayList<ArrayList<Int64>>()
    var idx: Int64 = 0
    while (idx < N || box.size > 0) {
        if (curBranch.size == 0) {
            if (box.size > 0) {
                let v = box[box.size-1]; box.remove((box.size-1)..box.size)
                curBranch.add(v)
                if (curBranch.size == K) {
                    var copy = ArrayList<Int64>()
                    for (x in curBranch) { copy.add(x) }
                    results.add(copy)
                    curBranch = ArrayList<Int64>()
                }
            } else {
                if (idx < N) {
                    curBranch.add(push[idx]); idx+=1
                    if (curBranch.size == K) {
                        var copy = ArrayList<Int64>()
                        for (x in curBranch) { copy.add(x) }
                        results.add(copy)
                        curBranch = ArrayList<Int64>()
                    }
                } else { break }
            }
            continue
        }
        let last = curBranch[curBranch.size-1]
        if (box.size > 0 && box[box.size-1] <= last) {
            let v = box[box.size-1]; box.remove((box.size-1)..box.size)
            curBranch.add(v)
            if (curBranch.size == K) {
                var copy = ArrayList<Int64>()
                for (x in curBranch) { copy.add(x) }
                results.add(copy)
                curBranch = ArrayList<Int64>()
            }
        } else {
            if (idx >= N) {
                var copy = ArrayList<Int64>()
                for (x in curBranch) { copy.add(x) }
                results.add(copy)
                curBranch = ArrayList<Int64>()
            } else {
                let needle = push[idx]; idx+=1
                if (needle <= last) {
                    curBranch.add(needle)
                    if (curBranch.size == K) {
                        var copy = ArrayList<Int64>()
                        for (x in curBranch) { copy.add(x) }
                        results.add(copy)
                        curBranch = ArrayList<Int64>()
                    }
                } else {
                    if (box.size < BoxCap) {
                        box.add(needle)
                    } else {
                        var copy = ArrayList<Int64>()
                        for (x in curBranch) { copy.add(x) }
                        results.add(copy)
                        curBranch = ArrayList<Int64>()
                        idx-=1
                    }
                }
            }
        }
    }
    if (curBranch.size > 0) {
        var copy = ArrayList<Int64>()
        for (x in curBranch) { copy.add(x) }
        results.add(copy)
    }
    for (b in results) {
        var sb = StringBuilder()
        for (i in 0..b.size) {
            if (i>0) { sb.append(" ") }
            sb.append("${b[i]}")
        }
        println(sb.toString())
    }
}
