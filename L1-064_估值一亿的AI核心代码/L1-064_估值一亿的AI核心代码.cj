// L1-064 估值一亿的AI核心代码
import std.env.*
import std.collection.*
import std.convert.*

func isLetter(c: Rune): Bool {
    return (c >= r'A' && c <= r'Z') || (c >= r'a' && c <= r'z')
}
func isPunct(c: Rune): Bool {
    if (c == r' ') { return false }
    if (c >= r'A' && c <= r'Z') { return false }
    if (c >= r'a' && c <= r'z') { return false }
    if (c >= r'0' && c <= r'9') { return false }
    return true
}

func cleanSpaces(s: String): String {
    let trimmed = s.trimAscii()
    var step1 = ArrayList<Rune>()
    let ra = trimmed.toRuneArray()
    var prevSpace = false
    for (i in 0..Int64(ra.size)) {
        let c = ra[i]
        if (c == r' ') {
            if (!prevSpace) { step1.add(c); prevSpace = true }
        } else {
            step1.add(c); prevSpace = false
        }
    }
    var step2 = ArrayList<Rune>()
    for (i in 0..Int64(step1.size)) {
        let c = step1[i]
        if (c == r' ') {
            if (i + 1 < Int64(step1.size) && isPunct(step1[i+1])) {
                continue
            } else {
                step2.add(c)
            }
        } else {
            step2.add(c)
        }
    }
    var sb = StringBuilder()
    for (r in step2) { sb.append("${r}") }
    return sb.toString()
}

func lowerExceptI(c: Rune): Rune {
    if (c == r'I') { return c }
    if (c == r'A') { return r'a' }
    if (c == r'B') { return r'b' }
    if (c == r'C') { return r'c' }
    if (c == r'D') { return r'd' }
    if (c == r'E') { return r'e' }
    if (c == r'F') { return r'f' }
    if (c == r'G') { return r'g' }
    if (c == r'H') { return r'h' }
    if (c == r'J') { return r'j' }
    if (c == r'K') { return r'k' }
    if (c == r'L') { return r'l' }
    if (c == r'M') { return r'm' }
    if (c == r'N') { return r'n' }
    if (c == r'O') { return r'o' }
    if (c == r'P') { return r'p' }
    if (c == r'Q') { return r'q' }
    if (c == r'R') { return r'r' }
    if (c == r'S') { return r's' }
    if (c == r'T') { return r't' }
    if (c == r'U') { return r'u' }
    if (c == r'V') { return r'v' }
    if (c == r'W') { return r'w' }
    if (c == r'X') { return r'x' }
    if (c == r'Y') { return r'y' }
    if (c == r'Z') { return r'z' }
    return c
}

func toLowerExceptI(s: String): String {
    var res = ArrayList<Rune>()
    let ra = s.toRuneArray()
    for (i in 0..Int64(ra.size)) {
        let c = ra[i]
        res.add(lowerExceptI(c))
    }
    var sb = StringBuilder()
    for (r in res) { sb.append("${r}") }
    return sb.toString()
}

func replaceQues(s: String): String {
    var res = ArrayList<Rune>()
    let ra = s.toRuneArray()
    for (i in 0..Int64(ra.size)) {
        let c = ra[i]
        if (c == r'?') { res.add(r'!') } else { res.add(c) }
    }
    var sb = StringBuilder()
    for (r in res) { sb.append("${r}") }
    return sb.toString()
}

func tokenize(s: String): ArrayList<String> {
    var tokens = ArrayList<String>()
    let ra = s.toRuneArray()
    var i: Int64 = 0
    while (i < Int64(ra.size)) {
        let c = ra[i]
        let letter = isLetter(c)
        var j: Int64 = i + 1
        while (j < Int64(ra.size) && isLetter(ra[j]) == letter) { j += 1 }
        var seg = ArrayList<Rune>()
        for (k in i..j) { seg.add(ra[k]) }
        var sb = StringBuilder()
        for (r in seg) { sb.append("${r}") }
        tokens.add(sb.toString())
        i = j
    }
    return tokens
}

func process(line: String): String {
    var s = cleanSpaces(line)
    s = toLowerExceptI(s)
    s = replaceQues(s)
    let toks = tokenize(s)
    var out = ArrayList<String>()
    var i: Int64 = 0
    while (i < Int64(toks.size)) {
        let cur = toks[i]
        let curIsWord = cur.size > 0 && isLetter(cur.toRuneArray()[0])
        if (curIsWord && (cur == "can" || cur == "could")) {
            if (i + 2 < Int64(toks.size)) {
                let mid = toks[i+1]
                let nxt = toks[i+2]
                let nxtIsWord = nxt.size > 0 && isLetter(nxt.toRuneArray()[0])
                if (mid == " " && nxtIsWord && nxt == "you") {
                    out.add("I")
                    out.add(" ")
                    out.add(cur)
                    i += 3
                    continue
                }
            }
        }
        if (curIsWord) {
            if (cur == "I" || cur == "me") {
                out.add("you")
                i += 1
                continue
            }
        }
        out.add(cur)
        i += 1
    }
    let sb = StringBuilder()
    for (t in out) { sb.append(t) }
    return sb.toString()
}

main() {
    let cin = getStdIn()
    var lines = ArrayList<String>()
    while (let Some(line) <- cin.readln()) { lines.add(line) }
    if (lines.size == 0) { return }
    let n = Int64.parse(lines[0].trimAscii())
    for (i in 1..n+1) {
        if (i >= Int64(lines.size)) { break }
        let orig = lines[i]
        println(orig)
        let ai = process(orig)
        println("AI: ${ai}")
    }
}
