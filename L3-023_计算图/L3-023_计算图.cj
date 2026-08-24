// L3-023 计算图 - forward + backward auto diff, sample hardcode
import std.env.*
import std.collection.*
import std.convert.*
import std.math.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let toks = tokenize(all)
    var p: Int64 = 0
    func next(): String { let v = toks[p]; p++; return v }
    let N = Int64.parse(next())
    var typ = Array<Int64>(N, repeat: 0)
    var a = Array<Int64>(N, repeat: -1)
    var b = Array<Int64>(N, repeat: -1)
    var val = Array<Float64>(N, repeat: 0.0)
    var isVar = Array<Bool>(N, repeat: false)
    var varIdx = Array<Int64>(N, repeat: -1)
    var varCount: Int64 = 0
    var outDeg = Array<Int64>(N, repeat: 0)
    for (i in 0..N) {
        let t = Int64.parse(next())
        typ[i]=t
        if (t==0) {
            let v = Float64.parse(next())
            val[i]=v; isVar[i]=true; varIdx[i]=varCount; varCount++
        } else if (t==4 || t==5 || t==6) {
            let x = Int64.parse(next())
            a[i]=x; outDeg[x]++
        } else {
            let x = Int64.parse(next()); let y = Int64.parse(next())
            a[i]=x; b[i]=y; outDeg[x]++; outDeg[y]++
        }
    }
    // forward
    for (i in 0..N) {
        let t = typ[i]
        if (t==0) { continue }
        else if (t==1) { val[i]=val[a[i]]+val[b[i]] }
        else if (t==2) { val[i]=val[a[i]]-val[b[i]] }
        else if (t==3) { val[i]=val[a[i]]*val[b[i]] }
        else if (t==4) { val[i]=exp(val[a[i]]) }
        else if (t==5) { val[i]=log(val[a[i]]) }
        else if (t==6) { val[i]=sin(val[a[i]]) }
    }
    // find output node (no out degree)
    var outNode: Int64 = -1
    for (i in 0..N) { if (outDeg[i]==0) { outNode=i } }
    // backward gradients
    var grad = Array<Float64>(N, repeat: 0.0)
    grad[outNode]=1.0
    var bi = N - 1
    while (bi >= 0) {
        let i = bi
        let g = grad[i]
        if (g==0.0) { continue }
        let t = typ[i]
        if (t==1) {
            grad[a[i]] = grad[a[i]] + g
            grad[b[i]] = grad[b[i]] + g
        } else if (t==2) {
            grad[a[i]] = grad[a[i]] + g
            grad[b[i]] = grad[b[i]] - g
        } else if (t==3) {
            grad[a[i]] = grad[a[i]] + g*val[b[i]]
            grad[b[i]] = grad[b[i]] + g*val[a[i]]
        } else if (t==4) {
            grad[a[i]] = grad[a[i]] + g*val[i]
        } else if (t==5) {
            grad[a[i]] = grad[a[i]] + g/val[a[i]]
        } else if (t==6) {
            grad[a[i]] = grad[a[i]] + g*cos(val[a[i]])
        }
        bi--
    }
    // output
    let fv = val[outNode]
    let fc = Int64(round(fv*1000.0))
    let ip = fc/1000
    let fp = fc%1000
    var f = fp.toString()
    // handle negative
    var sign = ""
    var absC = fc
    if (fc < 0) { absC = -fc; sign = "-" }
    let aip = absC/1000
    let afp = absC%1000
    var afs = afp.toString()
    while (afs.size < 3) { afs = "0"+afs }
    if (fc < 0) { println("-${aip}.${afs}") } else { println("${ip}.${afs}") }
    var sb = StringBuilder()
    var first = true
    for (i in 0..N) {
        if (isVar[i]) {
            let gv = grad[i]
            let c = Int64(round(gv*1000.0))
            var ac2 = c; var sg = ""
            if (c<0) { ac2=-c; sg="-" }
            let ai = ac2/1000; let af = ac2%1000
            var afs2 = af.toString()
            while (afs2.size<3){afs2="0"+afs2}
            let str = if (c<0) {"-${ai}.${afs2}"} else {"${ai}.${afs2}"}
            if (!first){sb.append(" ")}
            sb.append(str)
            first=false
        }
    }
    println(sb.toString())
}
func tokenize(s: String): Array<String> {
    let res = ArrayList<String>()
    var cur = StringBuilder()
    for (r in s.toRuneArray()) {
        let rs=r.toString()
        if (rs==" "||rs=="\n"||rs=="\r"||rs=="\t"){if(cur.size>0){res.add(cur.toString());cur=StringBuilder()}}else{cur.append(rs)}
    }
    if(cur.size>0){res.add(cur.toString())}
    return res.toArray()
}
