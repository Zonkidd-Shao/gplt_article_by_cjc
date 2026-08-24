// L3-002 特殊堆栈 - 支持Push Pop PeekMedian (中值=(N/2或(N+1)/2))
// Approach: BIT over value 1..1e5, stack数组
import std.env.*
import std.collection.*
import std.convert.*

class BIT{
    var n: Int64
    var t: Array<Int64>
    init(n: Int64){
        this.n=n
        this.t=Array<Int64>(n+2, repeat:0)
    }
    func add(i: Int64, delta: Int64): Unit{
        var x=i
        while(x<=n){
            t[x]+=delta
            x+= x & -x
        }
    }
    func kth(k: Int64): Int64 {
        var idx: Int64=0
        var bitMask: Int64=1
        while(bitMask <= n){ bitMask <<= 1 }
        var kk=k
        var mask=bitMask
        while(mask>0){
            let nxt = idx + mask
            if(nxt <= n && t[nxt] < kk){
                idx=nxt
                kk-=t[nxt]
            }
            mask >>= 1
        }
        return idx+1
    }
}

main(){
    let cin=getStdIn()
    let all=cin.readToEnd()??""
    // tokenization lines: we need to parse commands with strings
    let lines=ArrayList<String>()
    for(l in all.split("\n")){
        let tr=l.trimAscii()
        if(tr.size>0){ lines.add(tr) }
        else if(l.size>0){ // keep empty?
        }
    }
    if(lines.size==0){ return }
    let N=Int64.parse(lines[0].trimAscii().split(" ")[0])
    let bit=BIT(100000)
    let stack=ArrayList<Int64>()
    let sbOut=StringBuilder()
    var lineIdx: Int64=1
    for(opIdx in 0..N){
        if(lineIdx >= lines.size){ break }
        let line=lines[lineIdx]; lineIdx++
        if(line.startsWith("Push")){
            let parts=line.split(" ")
            var valStr=""
            for(p in parts){ if(p.size>0 && p!="Push"){ valStr=p } }
            // last part is value
            let v=Int64.parse(valStr)
            stack.add(v)
            bit.add(v, 1)
        } else if(line.startsWith("Pop")){
            if(stack.size==0){
                sbOut.append("Invalid\n")
            } else {
                let v=stack[stack.size-1]
                stack.remove((stack.size-1)..stack.size)
                bit.add(v, -1)
                sbOut.append(v.toString())
                sbOut.append("\n")
            }
        } else if(line.startsWith("Peek")){
            if(stack.size==0){
                sbOut.append("Invalid\n")
            } else {
                let k=(stack.size+1)/2
                let med=bit.kth(k)
                sbOut.append(med.toString())
                sbOut.append("\n")
            }
        }
    }
    print(sbOut.toString())
}
