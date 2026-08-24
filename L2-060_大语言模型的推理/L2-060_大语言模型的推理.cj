// L2-060 大语言模型的推理 - 定向图贪心遍历
// Approach: build directed adjacency, for each query greedy pick max p then smallest id among unvisited
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
    var p: Int64=0
    let n=Int64.parse(tokens[p]); p++
    let m=Int64.parse(tokens[p]); p++
    let adj=ArrayList<ArrayList<Array<Int64>>>()
    for(i in 0..(n+1)){ adj.add(ArrayList<Array<Int64>>()) }
    for(i in 0..m){
        let a=Int64.parse(tokens[p]); p++
        let b=Int64.parse(tokens[p]); p++
        let w=Int64.parse(tokens[p]); p++
        adj[a].add([b,w])
    }
    if(p >= tokens.size){ return }
    let K=Int64.parse(tokens[p]); p++
    let queries=ArrayList<Int64>()
    for(i in 0..K){
        if(p >= tokens.size){ break }
        queries.add(Int64.parse(tokens[p])); p++
    }
    let visited=Array<Bool>(n+1, repeat: false)
    for(q in queries){
        // reset visited
        for(i in 0..(n+1)){ visited[i]=false }
        let path=ArrayList<Int64>()
        var cur = q
        visited[cur]=true
        path.add(cur)
        while(true){
            var bestTo: Int64 = -1
            var bestP: Int64 = -1
            for(e in adj[cur]){
                let to=e[0]
                let pr=e[1]
                if(visited[to]){ continue }
                if(pr > bestP || (pr==bestP && to < bestTo)){
                    bestP=pr
                    bestTo=to
                }
            }
            if(bestTo==-1){ break }
            cur=bestTo
            visited[cur]=true
            path.add(cur)
        }
        let sb2=StringBuilder()
        for(i in 0..path.size){
            if(i>0){ sb2.append("->") }
            sb2.append(path[i].toString())
        }
        println(sb2.toString())
    }
}
