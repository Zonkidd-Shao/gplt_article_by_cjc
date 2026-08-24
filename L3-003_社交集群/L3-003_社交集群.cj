// L3-003 社交集群 - 按共同兴趣并查集
import std.env.*
import std.collection.*
import std.convert.*

main(){
    let cin=getStdIn()
    let all=cin.readToEnd()??""
    let lines=ArrayList<String>()
    for(l in all.split("\n")){
        lines.add(l)
    }
    var ptr: Int64=0
    while(ptr < lines.size && lines[ptr].trimAscii().size==0){ ptr++ }
    if(ptr>=lines.size){ return }
    // first line may contain colon? but first line is N
    let firstTokens=lines[ptr].trimAscii().split(" ")
    var N: Int64=0
    for(t in firstTokens){ if(t.size>0){ N=Int64.parse(t); break } }
    ptr++
    let parent=ArrayList<Int64>()
    let sz=ArrayList<Int64>()
    for(i in 0..(N+1)){ parent.add(i); sz.add(1) }
    func find(x:Int64):Int64{
        var v=x
        while(parent[v]!=v){
            parent[v]=parent[parent[v]]
            v=parent[v]
        }
        return v
    }
    func union(a:Int64,b:Int64):Unit{
        var ra=find(a)
        var rb=find(b)
        if(ra==rb){ return }
        if(sz[ra] < sz[rb]){
            parent[ra]=rb
            sz[rb]+=sz[ra]
        } else {
            parent[rb]=ra
            sz[ra]+=sz[rb]
        }
    }
    let hobbyFirst=Array<Int64>(1001, repeat:0)
    let hobbySeen=Array<Bool>(1001, repeat:false)
    for(person in 1..(N+1)){
        if(ptr >= lines.size){ break }
        let raw=lines[ptr]; ptr++
        if(raw.trimAscii().size==0){ continue }
        let splitColon=raw.split(":")
        var hobbyPart=""
        if(splitColon.size>=2){
            hobbyPart=splitColon[1]
        } else {
            hobbyPart=raw
        }
        let parts=hobbyPart.split(" ")
        for(p in parts){
            let t=p.trimAscii()
            if(t.size==0){ continue }
            let h=Int64.parse(t)
            if(h<0 || h>1000){ continue }
            if(!hobbySeen[h]){
                hobbySeen[h]=true
                hobbyFirst[h]=person
            } else {
                union(person, hobbyFirst[h])
            }
        }
    }
    // count per root
    let cntMap=Array<Int64>(N+1, repeat:0)
    for(i in 1..(N+1)){
        let r=find(i)
        cntMap[r]++
    }
    let sizes=ArrayList<Int64>()
    let seen=Array<Bool>(N+1, repeat:false)
    for(i in 1..(N+1)){
        let r=find(i)
        if(!seen[r]){
            seen[r]=true
            sizes.add(cntMap[r])
        }
    }
    func qs(l:Int64,r:Int64):Unit{
        if(l>=r){ return }
        var i=l; var j=r
        let piv=sizes[(l+r)/2]
        while(i<=j){
            while(sizes[i] > piv){ i++ }
            while(sizes[j] < piv){ j-- }
            if(i<=j){
                let t=sizes[i]; sizes[i]=sizes[j]; sizes[j]=t
                i++; j--
            }
        }
        if(l<j){ qs(l,j) }
        if(i<r){ qs(i,r) }
    }
    if(sizes.size>1){ qs(0, sizes.size-1) }
    println(sizes.size.toString())
    let sb=StringBuilder()
    for(i in 0..sizes.size){
        if(i>0){ sb.append(" ") }
        sb.append(sizes[i].toString())
    }
    println(sb.toString())
}
