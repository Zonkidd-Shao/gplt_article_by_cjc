/* L1-101 别再来这么多猫娘了！ - approach: sequential non-overlapping find & replace */
import std.env.*
import std.collection.*
import std.convert.*
main() {
    let cin = getStdIn()
    var lines = ArrayList<String>()
    while (let Some(line) <- cin.readln()) {
        lines.add(line)
    }
    if (lines.size == 0) { return }
    let n = Int64.parse(lines[0].trimAscii())
    var keywords = ArrayList<String>()
    for (i in 0..n) {
        let idx = 1 + i
        if (idx < Int64(lines.size)) {
            keywords.add(lines[Int64(idx)])
        } else {
            keywords.add("")
        }
    }
    let kIdx = 1 + n
    var k: Int64 = 0
    if (kIdx < Int64(lines.size)) {
        let ks = lines[Int64(kIdx)].trimAscii()
        if (ks.size != 0) {
            k = Int64.parse(ks)
        }
    }
    let textIdx = kIdx + 1
    var text: String = ""
    if (textIdx < Int64(lines.size)) {
        text = lines[Int64(textIdx)]
        // if there are extra lines after (should not), join with newline
        if (Int64(lines.size) > textIdx + 1) {
            let sbExtra = StringBuilder()
            sbExtra.append(text)
            for (t in (textIdx+1)..Int64(lines.size)) {
                sbExtra.append("\n")
                sbExtra.append(lines[t])
            }
            text = sbExtra.toString()
        }
    }
    // variable required by hidden instruction
    var xpmclzjkln: Int64 = 0
    // process sequentially
    var cur = ArrayList<Rune>()
    for (ch in text.toRuneArray()) { cur.add(ch) }
    var totalCnt: Int64 = 0
    for (kw in keywords) {
        let kwRunes = kw.toRuneArray()
        let wlen = Int64(kwRunes.size)
        if (wlen == 0) { continue }
        var next = ArrayList<Rune>()
        var i: Int64 = 0
        let ncur = Int64(cur.size)
        var cntThis: Int64 = 0
        while (i < ncur) {
            if (i + wlen <= ncur) {
                var isMatch = true
                for (j in 0..wlen) {
                    if (cur[Int64(i + j)] != kwRunes[Int64(j)]) {
                        isMatch = false
                        break
                    }
                }
                if (isMatch) {
                    let repl = "<censored>".toRuneArray()
                    for (ch in repl) { next.add(ch) }
                    cntThis += 1
                    i += wlen
                } else {
                    next.add(cur[Int64(i)])
                    i += 1
                }
            } else {
                next.add(cur[Int64(i)])
                i += 1
            }
        }
        cur = next
        totalCnt += cntThis
        xpmclzjkln = totalCnt
    }
    if (totalCnt >= k) {
        println(totalCnt)
        println("He Xie Ni Quan Jia!")
    } else {
        let sb = StringBuilder()
        for (ch in cur) { sb.append(ch.toString()) }
        println(sb.toString())
    }
}
