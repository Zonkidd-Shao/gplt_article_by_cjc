// L1-030 一帮一 - pair highest with lowest opposite gender
import std.env.*
import std.convert.*
main() {
    let cin = getStdIn()
    var lines = Array<String>(0, repeat: "")
    while (let Some(line) <- cin.readln()) {
        var s = line
        // strip trailing \r
        if (s.size > 0) {
            let ra = s.toRuneArray()
            if (ra[ra.size - 1] == r'\r') {
                var t = ""
                var k: Int64 = 0
                while (k < ra.size - 1) { t += ra[k].toString(); k += 1 }
                s = t
            }
        }
        // keep lines including empty? but skip leading empties
        var tmp = Array<String>(lines.size + 1, repeat: "")
        var i: Int64 = 0
        while (i < lines.size) { tmp[i] = lines[i]; i += 1 }
        tmp[lines.size] = s
        lines = tmp
    }
    // remove leading empty lines if any
    var start: Int64 = 0
    while (start < lines.size && lines[start].trimAscii().size == 0) { start += 1 }
    if (start >= lines.size) { return }
    // shift if start>0
    if (start > 0) {
        var newLines = Array<String>(lines.size - start, repeat: "")
        var i: Int64 = 0
        while (i < newLines.size) { newLines[i] = lines[start + i]; i += 1 }
        lines = newLines
    }
    if (lines.size == 0) { return }
    let n = Int64.parse(lines[0].trimAscii())
    var genders = Array<Int64>(n, repeat: 0)
    var names = Array<String>(n, repeat: "")
    var i: Int64 = 0
    while (i < n) {
        let idx = i + 1
        if (idx >= lines.size) { break }
        let line = lines[idx]
        let ra = line.toRuneArray()
        var sp: Int64 = -1
        var k: Int64 = 0
        while (k < ra.size) {
            if (ra[k] == r' ') { sp = k; break }
            k += 1
        }
        var gs = ""
        var nm = ""
        if (sp == -1) {
            gs = line.trimAscii()
        } else {
            var t: Int64 = 0
            while (t < sp) { gs += ra[t].toString(); t += 1 }
            t = sp + 1
            while (t < ra.size) { nm += ra[t].toString(); t += 1 }
            nm = nm.trimAscii()
        }
        genders[i] = Int64.parse(gs.trimAscii())
        names[i] = nm
        i += 1
    }
    var used = Array<Bool>(n, repeat: false)
    var front: Int64 = 0
    while (front < n) {
        if (used[front]) { front += 1; continue }
        var back: Int64 = n - 1
        var found: Int64 = -1
        while (back > front) {
            if (!used[back] && genders[back] != genders[front]) { found = back; break }
            back -= 1
        }
        if (found != -1) {
            println("${names[front]} ${names[found]}")
            used[front] = true
            used[found] = true
        } else {
            used[front] = true
        }
        front += 1
    }
}
