// L2-057 姥姥改作业 - 重复筛选阈值为左堆平均值(不含/2)
// Approach: simulate stacks with reversal of left pile each round
import std.env.*
import std.collection.*
import std.convert.*

main(){
    let cin=getStdIn()
    let all=cin.readToEnd()??""
    let runes=all.toRuneArray()
    let tokens=ArrayList<String>()
    var sb=StringBuilder()
    let sp:Rune=' '
    let nl:Rune='\n'
    let tab:Rune='\t'
    let cr:Rune='\r'
    for(r in runes){
        if(r==sp||r==nl||r==tab||r==cr){
            let cur=sb.toString()
            if(cur.size>0){ tokens.add(cur) }
            sb=StringBuilder()
        } else { sb.append(r) }
    }
    let last=sb.toString()
    if(last.size>0){ tokens.add(last) }
    if(tokens.size<2){ return }
    let n=Int64.parse(tokens[0])
    var T=Int64.parse(tokens[1])
    let c=ArrayList<Int64>()
    for(i in 0..n){
        let idx=i+2
        if(idx < tokens.size){
            c.add(Int64.parse(tokens[idx]))
        } else { c.add(0) }
    }
    var curr=ArrayList<Int64>()
    for(i in 0..n){ curr.add(i) } // indices 0..n-1 in order top->bottom
    let ans=ArrayList<Int64>()
    while(true){
        let nextLeft=ArrayList<Int64>()
        for(id in curr){
            let val=c[id]
            if(val <= T){
                ans.add(id+1) // 1-based编号
            } else {
                nextLeft.add(id)
            }
        }
        if(nextLeft.size==0){ break }
        var sum: Int64=0
        for(id in nextLeft){ sum+=c[id] }
        T = sum / nextLeft.size // floor avg
        // next curr is reverse of nextLeft (stack LIFO)
        curr.clear()
        // Actually ArrayList clear may not exist; recreate
        curr = ArrayList<Int64>()
        var j=nextLeft.size-1
        while(j>=0){
            curr.add(nextLeft[j])
            j--
        }
    }
    let sb2=StringBuilder()
    for(i in 0..ans.size){
        if(i>0){ sb2.append(" ") }
        sb2.append(ans[i].toString())
    }
    println(sb2.toString())
}
