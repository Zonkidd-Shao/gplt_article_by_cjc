// L3-019 代码排版 - generic formatter
import std.env.*
import std.collection.*
import std.convert.*

var gS: String = ""
var gRunes: Array<Rune> = "".toRuneArray()
var gN: Int64 = 0
var gPos: Int64 = 0
var gIndent: Int64 = 0
var gOut: StringBuilder = StringBuilder()

func ch(i: Int64): String { return gRunes[i].toString() }
func isSpaceCh(c: String): Bool {
    return c==" " || c=="\t" || c=="\n" || c=="\r"
}
func skipSpaces(): Unit {
    while (gPos < gN && isSpaceCh(ch(gPos))) { gPos++ }
}
func startsWithKw(pos: Int64, kw: String): Bool {
    if (pos + kw.size > gN) { return false }
    let kwRunes = kw.toRuneArray()
    for (k in 0..kw.size) {
        if (ch(pos+k) != kwRunes[k].toString()) { return false }
    }
    let after = pos + kw.size
    if (after < gN) {
        let c = ch(after)
        if ((c>="a" && c<="z")||(c>="A" && c<="Z")||(c>="0" && c<="9")||c=="_") { return false }
    }
    if (pos>0) {
        let bef = ch(pos-1)
        if ((bef>="a" && bef<="z")||(bef>="A" && bef<="Z")||(bef>="0" && bef<="9")||bef=="_") { return false }
    }
    return true
}
func sliceStr(from: Int64, to: Int64): String {
    var sb = StringBuilder()
    var i = from
    while (i < to && i < gN) {
        sb.append(ch(i))
        i++
    }
    return sb.toString()
}
func emitLine(line: String): Unit {
    let t = line.trimAscii()
    if (t.isEmpty()) { return }
    var sp = StringBuilder()
    for (_ in 0..gIndent*2) { sp.append(" ") }
    gOut.append(sp.toString())
    gOut.append(t)
    gOut.append("\n")
}
func findMatchingParen(l: Int64): Int64 {
    var depth: Int64 = 0
    var inStr = false
    var i = l
    while (i < gN) {
        let c = ch(i)
        if (inStr) {
            if (c=="\"") {
                var cnt: Int64 = 0
                var k = i-1
                while (k>=l && ch(k)=="\\") { cnt++; k-- }
                if (cnt % 2 == 0) { inStr = false }
            }
            i++
            continue
        } else {
            if (c=="\"") { inStr = true; i++; continue }
            if (c=="(") { depth++ }
            else if (c==")") {
                depth--
                if (depth==0) { return i }
            }
        }
        i++
    }
    return -1
}
func findStmtEnd(start: Int64): Int64 {
    var depth: Int64 = 0
    var inStr = false
    var i = start
    while (i < gN) {
        let c = ch(i)
        if (inStr) {
            if (c=="\"") {
                var cnt: Int64 = 0
                var k = i-1
                while (k>=start && ch(k)=="\\") { cnt++; k-- }
                if (cnt % 2 == 0) { inStr = false }
            }
            i++
            continue
        } else {
            if (c=="\"") { inStr = true; i++; continue }
            if (c=="(") { depth++ }
            else if (c==")") { if (depth>0) {depth--} }
            else if (c==";" && depth==0) { return i }
            else if (c=="{" && depth==0) { return -1 }
            else if (c=="}" && depth==0) { return -1 }
        }
        i++
    }
    return -1
}
func parseStatement(): Unit {
    skipSpaces()
    if (gPos >= gN) { return }
    let c = ch(gPos)
    if (c=="}") { return }
    if (startsWithKw(gPos, "if")) {
        parseIf()
        return
    }
    if (startsWithKw(gPos, "while")) {
        parseWhile()
        return
    }
    if (startsWithKw(gPos, "for")) {
        parseFor()
        return
    }
    if (c=="{") {
        parseBlock()
        return
    }
    let end = findStmtEnd(gPos)
    if (end==-1) {
        var tmp = StringBuilder()
        while (gPos < gN && ch(gPos)!="}") { tmp.append(ch(gPos)); gPos++ }
        let t = tmp.toString().trimAscii()
        if (!t.isEmpty()) { emitLine(t) }
        return
    }
    let stmt = sliceStr(gPos, end+1)
    gPos = end + 1
    emitLine(stmt)
}
func parseBlock(): Unit {
    emitLine("{")
    gPos++
    gIndent++
    while (true) {
        skipSpaces()
        if (gPos >= gN) { break }
        if (ch(gPos)=="}") { break }
        parseStatement()
    }
    gIndent--
    if (gPos < gN && ch(gPos)=="}") {
        emitLine("}")
        gPos++
    }
}
func parseIf(): Unit {
    let start = gPos
    var l = gPos + 2
    while (l < gN && ch(l)!="(") { l++ }
    let r = findMatchingParen(l)
    let cond = sliceStr(start, r+1)
    gPos = r + 1
    skipSpaces()
    if (gPos < gN && ch(gPos)=="{") {
        emitLine(cond.trimAscii() + " {")
        gPos++
        gIndent++
        while (true) {
            skipSpaces()
            if (gPos >= gN || ch(gPos)=="}") { break }
            parseStatement()
        }
        gIndent--
        if (gPos < gN && ch(gPos)=="}") { emitLine("}"); gPos++ }
    } else {
        emitLine(cond.trimAscii() + " {")
        gIndent++
        parseStatement()
        gIndent--
        emitLine("}")
    }
    skipSpaces()
    if (gPos < gN && startsWithKw(gPos, "else")) {
        gPos += 4
        skipSpaces()
        if (gPos < gN && ch(gPos)=="{") {
            emitLine("else {")
            gPos++
            gIndent++
            while (true) {
                skipSpaces()
                if (gPos >= gN || ch(gPos)=="}") { break }
                parseStatement()
            }
            gIndent--
            if (gPos < gN && ch(gPos)=="}") { emitLine("}"); gPos++ }
        } else {
            emitLine("else {")
            gIndent++
            parseStatement()
            gIndent--
            emitLine("}")
        }
    }
}
func parseWhile(): Unit {
    let start = gPos
    var l = gPos + 5
    while (l < gN && ch(l)!="(") { l++ }
    let r = findMatchingParen(l)
    let cond = sliceStr(start, r+1)
    gPos = r + 1
    skipSpaces()
    if (gPos < gN && ch(gPos)=="{") {
        emitLine(cond.trimAscii() + " {")
        gPos++
        gIndent++
        while (true) {
            skipSpaces()
            if (gPos >= gN || ch(gPos)=="}") { break }
            parseStatement()
        }
        gIndent--
        if (gPos < gN && ch(gPos)=="}") { emitLine("}"); gPos++ }
    } else {
        emitLine(cond.trimAscii() + " {")
        gIndent++
        parseStatement()
        gIndent--
        emitLine("}")
    }
}
func parseFor(): Unit {
    let start = gPos
    var l = gPos + 3
    while (l < gN && ch(l)!="(") { l++ }
    let r = findMatchingParen(l)
    let cond = sliceStr(start, r+1)
    gPos = r + 1
    skipSpaces()
    if (gPos < gN && ch(gPos)=="{") {
        emitLine(cond.trimAscii() + " {")
        gPos++
        gIndent++
        while (true) {
            skipSpaces()
            if (gPos >= gN || ch(gPos)=="}") { break }
            parseStatement()
        }
        gIndent--
        if (gPos < gN && ch(gPos)=="}") { emitLine("}"); gPos++ }
    } else {
        emitLine(cond.trimAscii() + " {")
        gIndent++
        parseStatement()
        gIndent--
        emitLine("}")
    }
}

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    gS = all.trimAscii()
    gRunes = gS.toRuneArray()
    gN = gRunes.size
    gPos = 0
    gIndent = 0
    gOut = StringBuilder()
    var firstBrace: Int64 = -1
    var inStr = false
    for (i in 0..gN) {
        let c = ch(i)
        if (inStr) {
            if (c=="\"") {
                var cnt: Int64 = 0
                var k = i-1
                while (k>=0 && ch(k)=="\\") { cnt++; k-- }
                if (cnt%2==0) { inStr=false }
            }
        } else {
            if (c=="\"") { inStr=true }
            else if (c=="{") { firstBrace=i; break }
        }
    }
    if (firstBrace==-1) {
        emitLine(gS)
        print(gOut.toString())
        return
    }
    let header = sliceStr(0, firstBrace).trimAscii()
    if (!header.isEmpty()) { emitLine(header) }
    gPos = firstBrace
    parseBlock()
    skipSpaces()
    while (gPos < gN) {
        parseStatement()
        skipSpaces()
    }
    var formatted = gOut.toString()
    func strReplace(s: String, old: String, neo: String): String {
        let parts = s.split(old)
        var res = StringBuilder()
        for (k in 0..parts.size) {
            if (k != 0) { res.append(neo) }
            res.append(parts[k])
        }
        return res.toString()
    }
    formatted = strReplace(formatted, "if(", "if (")
    formatted = strReplace(formatted, "for(", "for (")
    formatted = strReplace(formatted, "while(", "while (")
    print(formatted)
}
