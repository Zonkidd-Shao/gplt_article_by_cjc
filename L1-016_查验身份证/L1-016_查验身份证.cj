// L1-016 查验身份证
// approach: weighted sum mod 11
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    var lines = ArrayList<String>()
    while (let Some(line) <- cin.readln()) {
        let t = line.trimAscii()
        // preserve even empty? but IDs are not empty; skip leading empty
        if (t.isEmpty()) { continue }
        lines.add(t)
    }
    if (lines.size == 0) { return }
    let n = Int64.parse(lines[0])
    let weights: Array<Int64> = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2]
    let codes: Array<String> = ["1","0","X","9","8","7","6","5","4","3","2"]
    var anyInvalid = false
    var invalids = ArrayList<String>()
    for (i in 1..=n) {
        if (i >= Int64(lines.size)) { break }
        let id = lines[i]
        var ok = true
        var sum: Int64 = 0
        if (Int64(id.size) != 18) {
            ok = false
        } else {
            let runes = id.toRuneArray()
            for (j in 0..17) {
                let rs = runes[j].toString()
                if (rs < "0" || rs > "9") { ok = false; break }
                let d = Int64.parse(rs)
                sum += d * weights[j]
            }
            if (ok) {
                let z = sum % 11
                let expected = codes[z]
                let actual = runes[17].toString()
                if (expected != actual) { ok = false }
            }
        }
        if (!ok) {
            invalids.add(id)
            anyInvalid = true
        }
    }
    if (!anyInvalid) {
        println("All passed")
    } else {
        for (s in invalids) { println(s) }
    }
}
