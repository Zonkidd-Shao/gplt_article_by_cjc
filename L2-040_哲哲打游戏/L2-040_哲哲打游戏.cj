// L2-040 哲哲打游戏 - 存档模拟
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
    let M = Int64.parse(toks[p]); p+=1
    var nxt = Array<ArrayList<Int64>>(N+1, repeat: ArrayList<Int64>())
    for (i in 1..=N) { nxt[i]=ArrayList<Int64>() }
    for (i in 1..=N) {
        let K = Int64.parse(toks[p]); p+=1
        for (k in 0..K) {
            let v = Int64.parse(toks[p]); p+=1
            nxt[i].add(v)
        }
    }
    var save = Array<Int64>(101, repeat: 0)
    var curPos: Int64 = 1
    var out = StringBuilder()
    for (i in 0..M) {
        if (p+1 >= toks.size) { break }
        let op = Int64.parse(toks[p]); let j = Int64.parse(toks[p+1]); p+=2
        if (op==0) {
            // j is 1-indexed choice
            let lst = nxt[curPos]
            curPos = lst[j-1]
        } else if (op==1) {
            save[j]=curPos
            out.append("${curPos}\n")
        } else {
            curPos = save[j]
        }
    }
    out.append("${curPos}\n")
    print(out.toString())
}
