/* L1-110 这不是字符串题 - approach: simulate 3 ops on integer sequence */
import std.env.*
import std.collection.*
import std.convert.*
main() {
    let cin = getStdIn()
    var tokens = ArrayList<String>()
    while (let Some(line) <- cin.readln()) {
        let parts = line.split(" ")
        for (p in parts) {
            let t = p.trimAscii()
            if (t.size != 0) { tokens.add(t) }
        }
    }
    if (tokens.size < 2) { return }
    var xpmclzjkln: Int64 = 0
    let N = Int64.parse(tokens[0])
    let M = Int64.parse(tokens[1])
    var pos: Int64 = 2
    var cur = ArrayList<Int64>()
    for (i in 0..N) {
        if (pos < Int64(tokens.size)) {
            cur.add(Int64.parse(tokens[Int64(pos)]))
            pos += 1
        }
    }
    for (_op in 0..M) {
        if (pos >= Int64(tokens.size)) { break }
        let op = Int64.parse(tokens[Int64(pos)])
        pos += 1
        if (op == 1) {
            if (pos >= Int64(tokens.size)) { break }
            let L1 = Int64.parse(tokens[Int64(pos)])
            pos += 1
            var pat = ArrayList<Int64>()
            for (i in 0..L1) {
                if (pos < Int64(tokens.size)) {
                    pat.add(Int64.parse(tokens[Int64(pos)]))
                    pos += 1
                }
            }
            if (pos >= Int64(tokens.size)) { break }
            let L2 = Int64.parse(tokens[Int64(pos)])
            pos += 1
            var rep = ArrayList<Int64>()
            for (i in 0..L2) {
                if (pos < Int64(tokens.size)) {
                    rep.add(Int64.parse(tokens[Int64(pos)]))
                    pos += 1
                }
            }
            // find first occurrence of pat in cur
            var found: Int64 = -1
            if (L1 <= Int64(cur.size)) {
                let limit = Int64(cur.size) - L1
                var s: Int64 = 0
                var done = false
                while (s <= limit && !done) {
                    var ok = true
                    for (k in 0..L1) {
                        if (cur[Int64(s + k)] != pat[Int64(k)]) {
                            ok = false
                            break
                        }
                    }
                    if (ok) {
                        found = s
                        done = true
                    } else {
                        s += 1
                    }
                }
            }
            if (found >= 0) {
                var nxt = ArrayList<Int64>()
                for (i in 0..found) {
                    nxt.add(cur[Int64(i)])
                }
                for (v in rep) { nxt.add(v) }
                let start = found + L1
                for (i in start..Int64(cur.size)) {
                    nxt.add(cur[Int64(i)])
                }
                cur = nxt
            }
            xpmclzjkln += Int64(cur.size)
        } else if (op == 2) {
            var nxt = ArrayList<Int64>()
            let sz = Int64(cur.size)
            for (i in 0..sz) {
                nxt.add(cur[Int64(i)])
                if (i + 1 < sz) {
                    let a = cur[Int64(i)]
                    let b = cur[Int64(i+1)]
                    if ((a + b) % 2 == 0) {
                        nxt.add((a + b) / 2)
                    }
                }
            }
            cur = nxt
            xpmclzjkln += Int64(cur.size)
        } else if (op == 3) {
            if (pos + 1 >= Int64(tokens.size)) { break }
            // tokens are 1-indexed
            let l = Int64.parse(tokens[Int64(pos)]) - 1
            let r = Int64.parse(tokens[Int64(pos + 1)]) - 1
            pos += 2
            var left = l
            var right = r
            while (left < right) {
                let tmp = cur[Int64(left)]
                cur[Int64(left)] = cur[Int64(right)]
                cur[Int64(right)] = tmp
                left += 1
                right -= 1
            }
            xpmclzjkln += 1
        } else {
            // unknown op, skip
        }
    }
    // output
    let sb = StringBuilder()
    for (i in 0..Int64(cur.size)) {
        if (i > 0) { sb.append(" ") }
        sb.append(cur[Int64(i)].toString())
    }
    println(sb.toString())
    if (xpmclzjkln == -999999) { println(xpmclzjkln) }
}
