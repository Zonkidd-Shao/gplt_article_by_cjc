// L2-045 堆宝塔 - 模拟A/B柱
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
    var arr = Array<Int64>(N, repeat: 0)
    for (i in 0..N) { arr[i]=Int64.parse(toks[p]); p+=1 }
    var A = ArrayList<Int64>()
    var B = ArrayList<Int64>()
    var towers = ArrayList<Int64>()
    for (i in 0..N) {
        let c = arr[i]
        if (A.size==0) {
            A.add(c)
        } else if (c < A[A.size-1]) {
            A.add(c)
        } else {
            if (B.size==0 || c > B[B.size-1]) {
                B.add(c)
            } else {
                towers.add(A.size)
                var newA = ArrayList<Int64>()
                while (B.size>0 && B[B.size-1] > c) {
                    let v = B[B.size-1]; B.remove((B.size-1)..B.size)
                    newA.add(v)
                }
                newA.add(c)
                A = newA
            }
        }
    }
    if (A.size>0) { towers.add(A.size) }
    if (B.size>0) { towers.add(B.size) }
    var maxH: Int64 = 0
    for (h in towers) { if (h>maxH) { maxH=h } }
    println("${towers.size} ${maxH}")
}
