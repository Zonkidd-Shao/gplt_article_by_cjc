// L1-094 剪切粘贴 - 剪切后按前后串查找插入
import std.env.*
import std.collection.*
import std.convert.*

func indexOf(s: Array<Rune>, pat: Array<Rune>): Int64 {
    if (pat.size == 0) { return 0 }
    if (pat.size > s.size) { return -1 }
    var i: Int64 = 0
    while (i <= Int64(s.size) - Int64(pat.size)) {
        var j: Int64 = 0
        while (j < Int64(pat.size) && s[j + i] == pat[j]) { j++ }
        if (j == Int64(pat.size)) { return i }
        i++
    }
    return -1
}

main() {
    let cin = getStdIn()
    let firstOpt = cin.readln()
    if (let None <- firstOpt) { return }
    let firstLine = match (firstOpt) { case Some(v) => v; case None => "" }
    var cur = firstLine.toRuneArray()
    let secondOpt = cin.readln()
    if (let None <- secondOpt) { return }
    let secondLine = match (secondOpt) { case Some(v) => v; case None => "" }
    let n = Int64.parse(secondLine.trimAscii())
    var op: Int64 = 0
    while (op < n) {
        let lineOpt = cin.readln()
        if (let None <- lineOpt) { break }
        let line = match (lineOpt) { case Some(v) => v; case None => "" }
        var raw = line.trimAscii().split(" ")
        var toks = ArrayList<String>()
        for (p in raw) { if (p.size > 0) { toks.add(p) } }
        if (toks.size < 4) { op++; continue }
        let a = Int64.parse(toks[0])
        let b = Int64.parse(toks[1])
        let before = toks[2]
        let after = toks[3]
        let start: Int64 = a - 1
        let end: Int64 = b - 1
        var clip = Array<Rune>(0, repeat: " ".toRuneArray()[0])
        // clear placeholder
        clip = Array<Rune>(0, repeat: " ".toRuneArray()[0])
        // actually build correctly without placeholder
        var tmpClip = Array<Rune>(0, repeat: " ".toRuneArray()[0])
        tmpClip = Array<Rune>(0, repeat: " ".toRuneArray()[0])
        // To avoid repeat complexity, rebuild from scratch using dynamic
        var clip2 = ArrayList<Rune>()
        var ii = start
        while (ii <= end && ii < Int64(cur.size)) {
            clip2.add(cur[ii])
            ii++
        }
        var next = ArrayList<Rune>()
        var j: Int64 = 0
        while (j < start) {
            next.add(cur[j])
            j++
        }
        var k = end + 1
        while (k < Int64(cur.size)) {
            next.add(cur[k])
            k++
        }
        var nextArr = Array<Rune>(next.size, repeat: " ".toRuneArray()[0])
        for (t in 0..next.size) { nextArr[t] = next[t] }
        cur = nextArr
        let beforeArr = before.toRuneArray()
        let afterArr = after.toRuneArray()
        var targetList = ArrayList<Rune>()
        for (r in beforeArr) { targetList.add(r) }
        for (r in afterArr) { targetList.add(r) }
        var target = Array<Rune>(targetList.size, repeat: " ".toRuneArray()[0])
        for (t in 0..targetList.size) { target[t] = targetList[t] }
        let pos = indexOf(cur, target)
        if (pos != -1) {
            let insertAt = pos + Int64(beforeArr.size)
            var merged = ArrayList<Rune>()
            var t1: Int64 = 0
            while (t1 < insertAt) { merged.add(cur[t1]); t1++ }
            for (r in clip2) { merged.add(r) }
            var t2 = insertAt
            while (t2 < Int64(cur.size)) { merged.add(cur[t2]); t2++ }
            var mergedArr = Array<Rune>(merged.size, repeat: " ".toRuneArray()[0])
            for (t in 0..merged.size) { mergedArr[t] = merged[t] }
            cur = mergedArr
        } else {
            var ext = ArrayList<Rune>()
            for (r in cur) { ext.add(r) }
            for (r in clip2) { ext.add(r) }
            var extArr = Array<Rune>(ext.size, repeat: " ".toRuneArray()[0])
            for (t in 0..ext.size) { extArr[t] = ext[t] }
            cur = extArr
        }
        op++
    }
    var out = StringBuilder()
    for (r in cur) { out.append(r) }
    println(out.toString())
}
