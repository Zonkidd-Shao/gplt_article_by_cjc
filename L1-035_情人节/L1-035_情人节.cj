// L1-035 情人节 - find 2nd and 14th names
import std.env.*
main() {
    let cin = getStdIn()
    var names = Array<String>(0, repeat: "")
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
        s = s.trimAscii()
        if (s == ".") { break }
        if (s.size > 0) {
            var tmp = Array<String>(names.size + 1, repeat: "")
            var i: Int64 = 0
            while (i < names.size) { tmp[i] = names[i]; i += 1 }
            tmp[names.size] = s
            names = tmp
        }
    }
    let sz = names.size
    if (sz < 2) {
        println("Momo... No one is for you ...")
    } else if (sz < 14) {
        let a = names[1]
        println("${a} is the only one for you...")
    } else {
        let a = names[1]
        let b = names[13]
        println("${a} and ${b} are inviting you to dinner...")
    }
}
