// L2-055 胖达的山头 - 区间最大重叠数(含端点)
// Approach: sweep line events (time, delta) start before end at same time
import std.env.*
import std.collection.*
import std.convert.*

main(){
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    let runes = all.toRuneArray()
    let tokens = ArrayList<String>()
    var sb = StringBuilder()
    let sp: Rune = ' '
    let nl: Rune = '\n'
    let tab: Rune = '\t'
    let cr: Rune = '\r'
    for(r in runes){
        if(r==sp||r==nl||r==tab||r==cr){
            let cur=sb.toString()
            if(cur.size>0){ tokens.add(cur) }
            sb=StringBuilder()
        } else { sb.append(r) }
    }
    let last=sb.toString()
    if(last.size>0){ tokens.add(last) }
    if(tokens.size==0){ return }
    let n = Int64.parse(tokens[0])
    if(n==0){ println("0"); return }
    // tokens: n then pairs of times each like "hh:mm:ss"
    // tokens size =1+2*n
    let events = ArrayList<Array<Int64>>()
    // need to parse times correctly: tokens after first are time strings with colon
    // Our tokenization by whitespace correctly splits times (no spaces inside time)
    // So time tokens are at indices 1,2,3,4...
    var idx: Int64 = 1
    for(i in 0..n){
        if(idx+1 >= tokens.size){ break }
        let s1 = tokens[idx]; idx++
        let s2 = tokens[idx]; idx++
        func toSec(t: String): Int64 {
            let parts = t.split(":")
            let h = Int64.parse(parts[0])
            let m = Int64.parse(parts[1])
            let s = Int64.parse(parts[2])
            return h*3600+m*60+s
        }
        let a = toSec(s1)
        let b = toSec(s2)
        events.add([a, 1])
        events.add([b, -1])
    }
    // sort events by time, start (+1) before end (-1) at same time => delta descending
    // manual sort using quicksort
    let m = events.size
    func qs(l: Int64, r: Int64): Unit {
        if(l>=r){ return }
        var i=l; var j=r
        let pivotTime = events[(l+r)/2][0]
        let pivotDelta = events[(l+r)/2][1]
        while(i<=j){
            while(events[i][0] < pivotTime || (events[i][0]==pivotTime && events[i][1] > pivotDelta)){ i++ }
            while(events[j][0] > pivotTime || (events[j][0]==pivotTime && events[j][1] < pivotDelta)){ j-- }
            if(i<=j){
                let tmp = events[i]
                events[i]=events[j]
                events[j]=tmp
                i++; j--
            }
        }
        if(l<j){ qs(l,j) }
        if(i<r){ qs(i,r) }
    }
    qs(0, m-1)
    var cur: Int64 = 0
    var best: Int64 = 0
    for(e in events){
        cur += e[1]
        if(cur > best){ best = cur }
    }
    println(best.toString())
}
