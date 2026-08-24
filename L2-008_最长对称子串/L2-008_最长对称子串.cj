// L2-008 最长对称子串
import std.env.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    // extract first line preserving spaces
    var sb = StringBuilder()
    let nl: Rune = '\n'
    let cr: Rune = '\r'
    var done = false
    for (ch in all.toRuneArray()) {
        if (ch == nl || ch == cr) {
            if (sb.size != 0) { done = true; break }
            else {
                // if first char is newline, ignore leading empty lines? But spec says non-empty string, so not needed
                continue
            }
        }
        sb.append(ch)
        // if we already saw newline before, we break, so not continue
    }
    var s = sb.toString()
    // If all was empty after trimming but actual string may be spaces? Our loop skips leading newlines only.
    // If s is empty because all was empty, handle
    if (s.size == 0) {
        // fallback: if all contains only spaces, we need to capture them
        // try alternative: take raw without stripping leading spaces
        // For now, if s empty, take all trimmed of newline but keep spaces
        var alt = StringBuilder()
        for (ch in all.toRuneArray()) {
            if (ch == nl || ch == cr) { break }
            alt.append(ch)
        }
        s = alt.toString()
        if (s.size == 0) {
            // if still empty, it means input was empty line? Not per spec
            println(0)
            return
        }
    }
    let runes = s.toRuneArray()
    let n = runes.size
    if (n == 0) { println(0); return }
    var best: Int64 = 1
    for (c in 0..n) {
        // odd
        var l = c
        var r = c
        while (l >= 0 && r < n) {
            if (runes[l] != runes[r]) { break }
            let len = r - l + 1
            if (len > best) { best = len }
            l -= 1
            r += 1
        }
        // even
        l = c
        r = c + 1
        while (l >= 0 && r < n) {
            if (runes[l] != runes[r]) { break }
            let len = r - l + 1
            if (len > best) { best = len }
            l -= 1
            r += 1
        }
    }
    println(best)
}
