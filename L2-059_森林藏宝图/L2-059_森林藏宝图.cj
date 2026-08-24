// L2-059 森林藏宝图 - 树上叶节点路径最小安全系数最大的叶
// Approach: build children, DFS/bfs to compute bottle for leaves, find max
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
    if(tokens.size==0){ return }
    var p: Int64=0
    let n=Int64.parse(tokens[p]); p++
    let children=ArrayList<ArrayList<Int64>>()
    let edgeSafe=ArrayList<Int64>()
    for(i in 0..n){ children.add(ArrayList<Int64>()) }
    for(i in 0..n){ edgeSafe.add(101) }
    for(i in 1..n){
        if(p+1 >= tokens.size){ break }
        let j=Int64.parse(tokens[p]); p++
        let s=Int64.parse(tokens[p]); p++
        children[j].add(i)
        edgeSafe[i]=s
    }
    let isLeaf = ArrayList<Bool>()
    for(i in 0..n){ isLeaf.add(children[i].size==0) }
    let stackNodes=ArrayList<Int64>()
    let stackBottle=ArrayList<Int64>()
    stackNodes.add(0)
    stackBottle.add(101)
    let leafBottles=ArrayList<Int64>()
    let leafIds=ArrayList<Int64>()
    while(stackNodes.size>0){
        let node=stackNodes[stackNodes.size-1]
        stackNodes.remove((stackNodes.size-1)..stackNodes.size)
        let bottle=stackBottle[stackBottle.size-1]
        stackBottle.remove((stackBottle.size-1)..stackBottle.size)
        if(isLeaf[node] && node!=0){
            leafIds.add(node)
            leafBottles.add(bottle)
        } else {
            for(ch in children[node]){
                let s=edgeSafe[ch]
                var nb = bottle
                if(s < nb){ nb=s }
                if(bottle==101){ nb=s }
                stackNodes.add(ch)
                stackBottle.add(nb)
            }
        }
    }
    if(leafIds.size==0){
        println("0")
        println("")
        return
    }
    var maxB: Int64 = -1
    for(b in leafBottles){ if(b>maxB){ maxB=b } }
    let ans=ArrayList<Int64>()
    for(i in 0..leafIds.size){
        if(leafBottles[i]==maxB){ ans.add(leafIds[i]) }
    }
    func qs(l:Int64,r:Int64):Unit{
        if(l>=r){return}
        var i=l; var j=r
        let pivot=ans[(l+r)/2]
        while(i<=j){
            while(ans[i] < pivot){ i++ }
            while(ans[j] > pivot){ j-- }
            if(i<=j){
                let t=ans[i]; ans[i]=ans[j]; ans[j]=t
                i++; j--
            }
        }
        if(l<j){ qs(l,j) }
        if(i<r){ qs(i,r) }
    }
    if(ans.size>1){ qs(0, ans.size-1) }
    println(maxB.toString())
    let sb2=StringBuilder()
    for(i in 0..ans.size){
        if(i>0){ sb2.append(" ") }
        sb2.append(ans[i].toString())
    }
    println(sb2.toString())
}
