// L2-037 包装机 - 轨道队列+筐栈模拟
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.size == 0) { return }
    var lines = ArrayList<String>()
    var tmp = StringBuilder()
    for (r in all.toRuneArray()) {
        let s = r.toString()
        if (s=="\n") { lines.add(tmp.toString()); tmp=StringBuilder() } else if (s=="\r") {} else { tmp.append(s) }
    }
    lines.add(tmp.toString())
    var idx: Int64 = 0
    while (idx < lines.size && lines[idx].trimAscii().size == 0) { idx+=1 }
    if (idx >= lines.size) { return }
    let firstParts = lines[idx].trimAscii().split(" ").filter({x => x.size>0})
    idx+=1
    let N = Int64.parse(firstParts[0])
    let M = Int64.parse(firstParts[1])
    let Smax = Int64.parse(firstParts[2])
    var tracks = Array<ArrayList<String>>(N+1, repeat: ArrayList<String>())
    for (i in 1..=N) { tracks[i]=ArrayList<String>() }
    for (i in 1..=N) {
        while (idx < lines.size && lines[idx].size == 0) { idx+=1 }
        if (idx >= lines.size) { break }
        let s = lines[idx].trimAscii(); idx+=1
        var q = ArrayList<String>()
        for (rr in s.toRuneArray()) { q.add(rr.toString()) }
        tracks[i]=q
    }
    // collect buttons via token scan after header+tracks
    var allToks = ArrayList<String>()
    var cur2 = StringBuilder()
    for (r in all.toRuneArray()) {
        let s = r.toString()
        if (s==" "||s=="\n"||s=="\r"||s=="\t") {
            if (cur2.toString().size>0) { allToks.add(cur2.toString()); cur2=StringBuilder() }
        } else { cur2.append(s) }
    }
    if (cur2.toString().size>0) { allToks.add(cur2.toString()) }
    var pos: Int64 = 0
    pos+=3
    pos+=N
    var buttons = ArrayList<Int64>()
    while (pos < allToks.size) {
        let v = Int64.parse(allToks[pos]); pos+=1
        if (v==-1) { break }
        buttons.add(v)
    }
    var head = Array<Int64>(N+1, repeat: 0)
    var basket = ArrayList<String>()
    var out = StringBuilder()
    for (btn in buttons) {
        if (btn == 0) {
            if (basket.size > 0) {
                let top = basket[basket.size-1]
                out.append(top)
                basket.remove((basket.size-1)..basket.size)
            }
        } else {
            let id = btn
            if (id < 1 || id > N) { continue }
            if (head[id] >= tracks[id].size) { continue }
            if (basket.size >= Smax) {
                if (basket.size > 0) {
                    let top = basket[basket.size-1]
                    out.append(top)
                    basket.remove((basket.size-1)..basket.size)
                }
            }
            if (head[id] < tracks[id].size) {
                let item = tracks[id][head[id]]
                head[id]+=1
                basket.add(item)
            }
        }
    }
    println(out.toString())
}
