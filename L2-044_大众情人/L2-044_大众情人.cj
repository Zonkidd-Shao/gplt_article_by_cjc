// L2-044 大众情人 - Floyd
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.size==0) { return }
    var lines = ArrayList<String>()
    var tmp = StringBuilder()
    for (r in all.toRuneArray()) {
        let s = r.toString()
        if (s=="\n") { lines.add(tmp.toString()); tmp=StringBuilder() } else if (s=="\r") {} else { tmp.append(s) }
    }
    lines.add(tmp.toString())
    var p: Int64 = 0
    while (p < lines.size && lines[p].trimAscii().size==0) { p+=1 }
    let N = Int64.parse(lines[p].trimAscii()); p+=1
    let INF: Int64 = 4000000000000
    var dist = Array<Array<Int64>>(N+1, repeat: Array<Int64>(0, repeat: 0))
    for (i in 0..N+1) { dist[i]=Array<Int64>(N+1, repeat: INF); dist[i][i]=0 }
    var gender = Array<String>(N+1, repeat: "")
    for (i in 1..=N) {
        while (p < lines.size && lines[p].trimAscii().size==0) { p+=1 }
        if (p>=lines.size) { break }
        let line = lines[p].trimAscii(); p+=1
        let parts = line.split(" ").filter({x => x.size>0})
        gender[i]=parts[0]
        let K = Int64.parse(parts[1])
        for (k in 0..K) {
            let idx = 2 + k
            if (idx >= parts.size) { break }
            let kv = parts[idx]
            let kvParts = kv.split(":")
            let friend = Int64.parse(kvParts[0]); let d = Int64.parse(kvParts[1])
            if (d < dist[i][friend]) { dist[i][friend]=d }
        }
    }
    for (k in 1..=N) {
        for (i in 1..=N) {
            for (j in 1..=N) {
                let nd = dist[i][k] + dist[k][j]
                if (nd < dist[i][j]) { dist[i][j]=nd }
            }
        }
    }
    var femaleMax = Array<Int64>(N+1, repeat: INF)
    var maleMax = Array<Int64>(N+1, repeat: INF)
    for (i in 1..=N) {
        var mx: Int64 = 0
        var hasInf = false
        for (j in 1..=N) {
            if (gender[i]==gender[j]) { continue }
            if (dist[j][i] >= INF/2) { hasInf=true; break }
            if (dist[j][i] > mx) { mx = dist[j][i] }
        }
        if (hasInf) { mx = INF }
        if (gender[i]=="F") { femaleMax[i]=mx } else { maleMax[i]=mx }
    }
    var minF = INF; var minM = INF
    for (i in 1..=N) {
        if (gender[i]=="F" && femaleMax[i] < minF) { minF = femaleMax[i] }
        if (gender[i]=="M" && maleMax[i] < minM) { minM = maleMax[i] }
    }
    var outF = ArrayList<Int64>()
    var outM = ArrayList<Int64>()
    for (i in 1..=N) {
        if (gender[i]=="F" && femaleMax[i]==minF) { outF.add(i) }
        if (gender[i]=="M" && maleMax[i]==minM) { outM.add(i) }
    }
    var sb1 = StringBuilder()
    for (i in 0..outF.size) {
        if (i>0) { sb1.append(" ") }
        sb1.append("${outF[i]}")
    }
    println(sb1.toString())
    var sb2 = StringBuilder()
    for (i in 0..outM.size) {
        if (i>0) { sb2.append(" ") }
        sb2.append("${outM[i]}")
    }
    println(sb2.toString())
}
