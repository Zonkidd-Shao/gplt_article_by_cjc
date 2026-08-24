// L1-011 A-B
// approach: remove chars of B from A
import std.env.*
import std.collection.*

main() {
    let cin = getStdIn()
    var lines = ArrayList<String>()
    while (let Some(line) <- cin.readln()) {
        lines.add(line)
    }
    let a = if (lines.size > 0) { lines[0] } else { "" }
    let b = if (lines.size > 1) { lines[1] } else { "" }
    var set = HashSet<Rune>()
    for (r in b.toRuneArray()) { set.add(r) }
    var sb = StringBuilder()
    for (r in a.toRuneArray()) {
        if (!set.contains(r)) { sb.append(r.toString()) }
    }
    println(sb.toString())
}
