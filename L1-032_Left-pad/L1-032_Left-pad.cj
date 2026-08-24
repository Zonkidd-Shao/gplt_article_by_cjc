// L1-032 Left-pad - pad or truncate
import std.env.*
import std.convert.*
main() {
    let cin = getStdIn()
    var first = ""
    var second = ""
    var idx: Int64 = 0
    while (let Some(line) <- cin.readln()) {
        var s = line
        if (s.size > 0) {
            let ra = s.toRuneArray()
            if (ra[ra.size - 1] == r'\r') {
                var t = ""
                var k: Int64 = 0
                while (k < ra.size - 1) { t += ra[k].toString(); k += 1 }
                s = t
            }
        }
        if (idx == 0) { first = s }
        else if (idx == 1) { second = s; break }
        idx += 1
    }
    let ra0 = first.toRuneArray()
    var pos: Int64 = -1
    var p: Int64 = 0
    while (p < ra0.size) {
        if (ra0[p] == r' ') { pos = p; break }
        p += 1
    }
    if (pos == -1) { return }
    var nStr = ""
    var q: Int64 = 0
    while (q < pos) { nStr += ra0[q].toString(); q += 1 }
    let n = Int64.parse(nStr.trimAscii())
    var padChar: Rune = r' '
    if (pos + 1 < ra0.size) { padChar = ra0[pos + 1] }
    let sRunes = second.toRuneArray()
    let len = sRunes.size
    if (len >= n) {
        var out = ""
        var start = len - n
        var k: Int64 = start
        while (k < len) { out += sRunes[k].toString(); k += 1 }
        println(out)
    } else {
        let padCount = n - len
        var out = ""
        var c: Int64 = 0
        while (c < padCount) { out += padChar.toString(); c += 1 }
        out += second
        println(out)
    }
}
