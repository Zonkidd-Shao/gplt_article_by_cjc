// L2-046 天梯赛的赛场安排 - 多轮分配
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
    let C = Int64.parse(toks[p]); p+=1
    var names = Array<String>(N, repeat: "")
    var counts = Array<Int64>(N, repeat: 0)
    var contact = Array<Int64>(N, repeat: 0)
    for (i in 0..N) {
        names[i]=toks[p]; p+=1
        counts[i]=Int64.parse(toks[p]); p+=1
    }
    var remaining = Array<Int64>(N, repeat: 0)
    for (i in 0..N) { remaining[i]=counts[i] }
    var rooms = ArrayList<Int64>() // occupancy
    // bucket for remaining values 0..500
    // Instead simple loop scanning max each iteration may still be okay for 5000*placements; we use bucket
    // We'll use while loop picking max
    while (true) {
        var maxRem: Int64 = 0
        var maxIdx: Int64 = -1
        for (i in 0..N) {
            if (remaining[i] > maxRem) { maxRem=remaining[i]; maxIdx=i }
        }
        if (maxRem==0) { break }
        let n = maxRem
        if (n >= C) {
            rooms.add(C)
            remaining[maxIdx] = n - C
            contact[maxIdx]+=1
        } else {
            var found: Int64 = -1
            for (r in 0..rooms.size) {
                let avail = C - rooms[r]
                if (avail >= n) { found=r; break }
            }
            if (found != -1) {
                rooms[found] = rooms[found] + n
                remaining[maxIdx]=0
                contact[maxIdx]+=1
            } else {
                rooms.add(n)
                remaining[maxIdx]=0
                contact[maxIdx]+=1
            }
        }
    }
    var out = StringBuilder()
    for (i in 0..N) {
        out.append("${names[i]} ${contact[i]}\n")
    }
    out.append("${rooms.size}\n")
    print(out.toString())
}
