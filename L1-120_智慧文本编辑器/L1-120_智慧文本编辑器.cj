// L1-120 智慧文本编辑器
import std.env.*
import std.collection.*
import std.convert.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    var norm = StringBuilder()
    let cr: Rune = '\r'
    for (ch in all.toRuneArray()) { if (ch != cr) { norm.append(ch) } }
    let s = norm.toString()
    var lines = ArrayList<String>()
    var cur = StringBuilder()
    let nl: Rune = '\n'
    for (ch in s.toRuneArray()) {
        if (ch == nl) { lines.add(cur.toString()); cur=StringBuilder() }
        else { cur.append(ch) }
    }
    if (s.size != 0) {
        let lastIsNl = s.toRuneArray()[s.size-1] == nl
        if (!lastIsNl) { lines.add(cur.toString()) }
    }
    if (lines.size < 2) { return }
    let n = Int64.parse(lines[0].trimAscii())
    var text = lines[1]
    var idx: Int64 = 2
    var opCount: Int64 = 0
    while (opCount < n && idx < lines.size) {
        let raw = lines[idx]
        idx += 1
        if (raw.trimAscii().isEmpty()) { continue }
        opCount += 1
        let sp: Rune = ' '
        let tab: Rune = '\t'
        var parts = ArrayList<String>()
        var pSb = StringBuilder()
        var inP = false
        for (ch in raw.toRuneArray()) {
            let isSp = (ch == sp) || (ch == tab)
            if (isSp) {
                if (inP) { parts.add(pSb.toString()); pSb=StringBuilder(); inP=false }
            } else { pSb.append(ch); inP=true }
        }
        if (inP) { parts.add(pSb.toString()) }
        if (parts.size == 0) { continue }
        let op = Int64.parse(parts[0])
        if (op == 1) {
            if (parts.size < 2) { println("-1"); continue }
            let pat = parts[1]
            let tRunes = text.toRuneArray()
            let pRunes = pat.toRuneArray()
            var positions = ArrayList<Int64>()
            let tLen = tRunes.size
            let pLen = pRunes.size
            if (pLen <= tLen) {
                var i: Int64 = 0
                while (i <= tLen - pLen) {
                    var isMatch = true
                    for (j in 0..pLen) {
                        if (tRunes[(i+j)] != pRunes[j]) { isMatch = false; break }
                    }
                    if (isMatch) {
                        positions.add(i)
                        if (positions.size >= 3) { break }
                    }
                    i += 1
                }
            }
            if (positions.size == 0) {
                println("-1")
            } else {
                var out = StringBuilder()
                for (k in 0..positions.size) {
                    if (k != 0) { out.append(" ") }
                    out.append(positions[k])
                }
                println(out.toString())
            }
        } else if (op == 2) {
            if (parts.size < 3) { continue }
            let p = Int64.parse(parts[1])
            let s2 = parts[2]
            let tRunes = text.toRuneArray()
            let s2Runes = s2.toRuneArray()
            let tLen = tRunes.size
            var newSb = StringBuilder()
            if (p <= 0) {
                for (ch in s2Runes) { newSb.append(ch) }
                for (ch in tRunes) { newSb.append(ch) }
            } else if (p >= tLen) {
                for (ch in tRunes) { newSb.append(ch) }
                for (ch in s2Runes) { newSb.append(ch) }
            } else {
                for (i in 0..p) { newSb.append(tRunes[i]) }
                for (ch in s2Runes) { newSb.append(ch) }
                for (i in p..tLen) { newSb.append(tRunes[i]) }
            }
            text = newSb.toString()
            println(text)
        } else if (op == 3) {
            if (parts.size < 3) { continue }
            let l = Int64.parse(parts[1])
            let r = Int64.parse(parts[2])
            let tRunes = text.toRuneArray()
            let tLen = tRunes.size
            if (l < 0 || r >= tLen || l > r) {
                println(text)
                continue
            }
            var newSb = StringBuilder()
            for (i in 0..l) { newSb.append(tRunes[i]) }
            var revIdx = r
            while (revIdx >= l) {
                newSb.append(tRunes[revIdx])
                revIdx -= 1
            }
            for (i in (r+1)..tLen) { newSb.append(tRunes[i]) }
            text = newSb.toString()
            println(text)
        }
    }
}
