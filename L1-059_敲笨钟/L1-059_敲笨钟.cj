// L1-059 敲笨钟 - 判断压ong韵并替换末三字
import std.env.*
import std.collection.*
import std.convert.*

func isOng(word: String): Bool {
    let a = word.toRuneArray()
    if (a.size < 3) { return false }
    return a[a.size - 3] == r'o' && a[a.size - 2] == r'n' && a[a.size - 1] == r'g'
}

main() {
    let cin = getStdIn()
    var lines = ArrayList<String>()
    while (let Some(line) <- cin.readln()) {
        lines.add(line)
    }
    if (lines.size == 0) { return }
    let n = Int64.parse(lines[0].trimAscii())
    for (k in 0..n) {
        let idx = 1 + k
        if (idx >= Int64(lines.size)) { break }
        let raw = lines[idx]
        // split by comma
        let parts = raw.split(",")
        if (parts.size < 2) {
            println("Skipped")
            continue
        }
        let upperRaw = parts[0].trimAscii()
        // second part: join remaining commas? but only one comma expected
        var lowerRawBuilder = StringBuilder()
        for (i in 1..Int64(parts.size)) {
            if (i > 1) { lowerRawBuilder.append(",") }
            lowerRawBuilder.append(parts[i])
        }
        var lowerWithDot = lowerRawBuilder.toString().trimAscii()
        // remove trailing '.'
        if (lowerWithDot.size > 0) {
            let la = lowerWithDot.toRuneArray()
            if (la[la.size - 1] == r'.') {
                var tmp = ArrayList<Rune>()
                for (i in 0..Int64(la.size)-1) { tmp.add(la[i]) }
                var sb = StringBuilder()
                for (r in tmp) { sb.append("${r}") }
                lowerWithDot = sb.toString().trimAscii()
            }
        }
        let upPartsRaw = upperRaw.split(" ")
        let lowPartsRaw = lowerWithDot.split(" ")
        var upParts = ArrayList<String>()
        var lowParts = ArrayList<String>()
        for (p in upPartsRaw) { if (p.size > 0) { upParts.add(p) } }
        for (p in lowPartsRaw) { if (p.size > 0) { lowParts.add(p) } }
        if (upParts.size == 0 || lowParts.size == 0) {
            println("Skipped")
            continue
        }
        let lastUp = upParts[upParts.size - 1]
        let lastLow = lowParts[lowParts.size - 1]
        if (!isOng(lastUp) || !isOng(lastLow)) {
            println("Skipped")
            continue
        }
        var newLow = ArrayList<String>()
        let keep = lowParts.size - 3
        for (i in 0..keep) { newLow.add(lowParts[i]) }
        newLow.add("qiao")
        newLow.add("ben")
        newLow.add("zhong")
        let sbUp = StringBuilder()
        for (i in 0..Int64(upParts.size)) {
            if (i > 0) { sbUp.append(" ") }
            sbUp.append(upParts[i])
        }
        let sbLow = StringBuilder()
        for (i in 0..Int64(newLow.size)) {
            if (i > 0) { sbLow.append(" ") }
            sbLow.append(newLow[i])
        }
        println("${sbUp.toString()}, ${sbLow.toString()}.")
    }
}
