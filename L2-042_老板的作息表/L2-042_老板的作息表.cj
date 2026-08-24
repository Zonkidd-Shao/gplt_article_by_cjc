// L2-042 老板的作息表 - 区间求补
import std.env.*
import std.collection.*
import std.convert.*

func toSec(s: String): Int64 {
    let parts = s.split(":")
    let h = Int64.parse(parts[0]); let m = Int64.parse(parts[1]); let sec = Int64.parse(parts[2])
    return h*3600 + m*60 + sec
}
func toStr(sec: Int64): String {
    let h = sec / 3600
    let m = (sec % 3600) / 60
    let s = sec % 60
    var hs = "${h}"; var ms = "${m}"; var ss = "${s}"
    if (h < 10) { hs = "0${h}" }
    if (m < 10) { ms = "0${m}" }
    if (s < 10) { ss = "0${s}" }
    return "${hs}:${ms}:${ss}"
}

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.size==0) { return }
    var lines = ArrayList<String>()
    var tmp = StringBuilder()
    for (r in all.toRuneArray()) {
        let s = r.toString()
        if (s=="\n") {
            lines.add(tmp.toString()); tmp=StringBuilder()
        } else if (s=="\r") {
        } else { tmp.append(s) }
    }
    lines.add(tmp.toString())
    // remove empty trailing?
    var p: Int64 = 0
    while (p < lines.size && lines[p].trimAscii().size==0) { p+=1 }
    if (p>=lines.size) { return }
    let N = Int64.parse(lines[p].trimAscii()); p+=1
    var segs = ArrayList<ArrayList<Int64>>()
    for (i in 0..N) {
        while (p < lines.size && lines[p].trimAscii().size==0) { p+=1 }
        if (p>=lines.size) { break }
        let line = lines[p].trimAscii(); p+=1
        // format "hh:mm:ss - hh:mm:ss"
        let parts = line.split(" ")
        // parts may be ["hh:mm:ss","-","hh:mm:ss"]
        var aStr = ""; var bStr = ""
        for (pp in parts) {
            if (pp.size==0) { continue }
            if (pp=="-") { continue }
            if (aStr.size==0) { aStr=pp } else { bStr=pp }
        }
        let a = toSec(aStr); let b = toSec(bStr)
        var e = ArrayList<Int64>(); e.add(a); e.add(b)
        segs.add(e)
    }
    // sort by start
    for (i in 0..segs.size) {
        for (j in i+1..segs.size) {
            if (segs[j][0] < segs[i][0]) {
                let t = segs[i]; segs[i]=segs[j]; segs[j]=t
            }
        }
    }
    var out = StringBuilder()
    var prev: Int64 = 0
    let END: Int64 = 23*3600 + 59*60 + 59
    for (seg in segs) {
        let s = seg[0]; let e = seg[1]
        if (s > prev) {
            out.append("${toStr(prev)} - ${toStr(s)}\n")
        }
        if (e > prev) { prev = e }
    }
    if (prev < END) {
        out.append("${toStr(prev)} - ${toStr(END)}\n")
    } else if (prev < END) {
        out.append("${toStr(prev)} - 23:59:59\n")
    }
    print(out.toString())
}
