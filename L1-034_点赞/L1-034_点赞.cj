// L1-034 点赞 - most frequent tag, tie largest id
import std.env.*
import std.convert.*
main() {
    let cin = getStdIn()
    var lines = Array<String>(0, repeat: "")
    while (let Some(line) <- cin.readln()) {
        if (line.trimAscii().size == 0) { continue }
        var tmp = Array<String>(lines.size + 1, repeat: "")
        var i: Int64 = 0
        while (i < lines.size) { tmp[i] = lines[i]; i += 1 }
        tmp[lines.size] = line.trimAscii()
        lines = tmp
    }
    if (lines.size == 0) { return }
    let n = Int64.parse(lines[0])
    var cnt = Array<Int64>(1001, repeat: 0)
    var i: Int64 = 1
    var processed: Int64 = 0
    while (processed < n && i < lines.size) {
        let line = lines[i]
        var norm = ""
        for (c in line.toRuneArray()) {
            if (c == r'\t') { norm += " " } else { norm += c.toString() }
        }
        let toksRaw = norm.split(" ")
        var toks = Array<String>(0, repeat: "")
        for (p in toksRaw) {
            if (p.trimAscii().size > 0) {
                var tmp2 = Array<String>(toks.size + 1, repeat: "")
                var k: Int64 = 0
                while (k < toks.size) { tmp2[k] = toks[k]; k += 1 }
                tmp2[toks.size] = p.trimAscii()
                toks = tmp2
            }
        }
        if (toks.size > 0) {
            let k = Int64.parse(toks[0])
            var t: Int64 = 1
            while (t <= k && t < toks.size) {
                let tag = Int64.parse(toks[t])
                if (tag >= 0 && tag <= 1000) { cnt[tag] += 1 }
                t += 1
            }
        }
        processed += 1
        i += 1
    }
    var bestTag: Int64 = 0
    var bestCnt: Int64 = -1
    var tag: Int64 = 1
    while (tag <= 1000) {
        let c = cnt[tag]
        if (c > bestCnt || (c == bestCnt && tag > bestTag)) {
            bestCnt = c
            bestTag = tag
        }
        tag += 1
    }
    println("${bestTag} ${bestCnt}")
}
