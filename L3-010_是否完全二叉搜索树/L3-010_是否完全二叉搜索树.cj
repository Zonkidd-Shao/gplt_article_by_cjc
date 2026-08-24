// L3-010 是否完全二叉搜索树 - 左大右小
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
    let N=Int64.parse(tokens[0])
    let vals=ArrayList<Int64>()
    for(i in 0..N){
        let idx=i+1
        if(idx < tokens.size){ vals.add(Int64.parse(tokens[idx])) }
    }
    // BST with left > right? Actually left big, right small: if val > node.val go left else right
    // Build tree via array nodes
    let left=Array<Int64>(N, repeat:-1)
    let right=Array<Int64>(N, repeat:-1)
    let root: Int64=0
    // Insert sequentially
    for(i in 1..N){
        var cur=0
        let v=vals[i]
        while(true){
            if(v > vals[cur]){
                if(left[cur]==-1){ left[cur]=i; break } else { cur=left[cur] }
            } else {
                if(right[cur]==-1){ right[cur]=i; break } else { cur=right[cur] }
            }
        }
    }
    // Level order
    let que=ArrayList<Int64>()
    que.add(0)
    var head: Int64=0
    let order=ArrayList<Int64>()
    let posMap=Array<Int64>(N, repeat:-1) // position index in complete tree?
    // For complete check, we can assign indices: root 0, left child 2*i+1, right 2*i+2 (if array representation)
    // BFS assign pos
    let qPos=ArrayList<Int64>()
    qPos.add(0)
    var maxPos: Int64=0
    while(head < que.size){
        let node=que[head]
        let p=qPos[head]
        head++
        order.add(vals[node])
        if(p > maxPos){ maxPos=p }
        let l=left[node]
        let r=right[node]
        if(l != -1){
            que.add(l)
            qPos.add(2*p+1)
        }
        if(r != -1){
            que.add(r)
            qPos.add(2*p+2)
        }
    }
    // Complete iff maxPos == N-1 (positions 0..N-1 all filled) and no gaps: Actually if tree is complete, maxPos should be N-1 and all positions <N are present.
    // However if some missing but maxPos < N, still complete? No, condition is that nodes fill level order without gaps.
    // So complete if maxPos == N-1 (since positions are 0-indexed, the largest index should be N-1)
    var isComplete = (maxPos == N-1)
    // Alternatively check via BFS with nulls: if we had encountered null before non-null then not complete.
    // Our pos method already covers.
    let sb2=StringBuilder()
    for(i in 0..order.size){
        if(i>0){ sb2.append(" ") }
        sb2.append(order[i].toString())
    }
    println(sb2.toString())
    if(isComplete){ println("YES") } else { println("NO") }
}
