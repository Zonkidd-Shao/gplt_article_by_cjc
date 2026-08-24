// L2-034 口罩发放 - 按时间排序、P间隔、18位数字
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.size == 0) { return }
    var toks = ArrayList<String>()
    var cur = StringBuilder()
    for (r in all.toRuneArray()) {
        let s = r.toString()
        if (s == " " || s == "\n" || s == "\r" || s == "\t") {
            if (cur.toString().size > 0) { toks.add(cur.toString()); cur = StringBuilder() }
        } else {
            cur.append(s)
        }
    }
    if (cur.toString().size > 0) { toks.add(cur.toString()) }
    if (toks.size < 2) { return }
    var p: Int64 = 0
    let D = Int64.parse(toks[p]); p+=1
    let P = Int64.parse(toks[p]); p+=1
    var lastReceive = HashMap<String, Int64>()
    var sickSeen = HashMap<String, Bool>()
    var sickOrder = ArrayList<String>()
    var out = StringBuilder()
    for (day in 1..=D) {
        if (p+1 >= toks.size) { break }
        let Ti = Int64.parse(toks[p]); p+=1
        let Si = Int64.parse(toks[p]); p+=1
        var dayApps = ArrayList<ArrayList<String>>()
        // collect Ti records
        for (t in 0..Ti) {
            if (dayApps.size >= Ti) { break }
            if (p+3 >= toks.size) { break }
            let name = toks[p]; let id = toks[p+1]; let health = toks[p+2]; let tm = toks[p+3]
            p+=4
            var arr = ArrayList<String>()
            arr.add(name); arr.add(id); arr.add(health); arr.add(tm)
            dayApps.add(arr)
            // sick collection: valid id and health==1
            var valid = true
            if (id.size != 18) { valid = false } else {
                for (rr in id.toRuneArray()) {
                    let ss = rr.toString()
                    if (ss < "0" || ss > "9") { valid = false; break }
                }
            }
            if (valid && health == "1") {
                let key = "${name} ${id}"
                if (!sickSeen.contains(key)) {
                    sickSeen[key] = true
                    sickOrder.add(key)
                }
            }
        }
        // filter valid ids for distribution
        var validApps = ArrayList<ArrayList<String>>()
        var ord: Int64 = 0
        for (a in dayApps) {
            let id = a[1]
            var valid = true
            if (id.size != 18) { valid = false } else {
                for (rr in id.toRuneArray()) {
                    let ss = rr.toString()
                    if (ss < "0" || ss > "9") { valid = false; break }
                }
            }
            if (!valid) { continue }
            var e = ArrayList<String>()
            e.add(a[0]); e.add(a[1]); e.add(a[3]); e.add("${ord}")
            validApps.add(e)
            ord+=1
        }
        // sort by time then order
        for (i in 0..validApps.size) {
            for (j in i+1..validApps.size) {
                let ai = validApps[i]
                let aj = validApps[j]
                var needSwap = false
                if (ai[2] != aj[2]) {
                    if (ai[2] > aj[2]) { needSwap = true }
                } else {
                    if (Int64.parse(ai[3]) > Int64.parse(aj[3])) { needSwap = true }
                }
                if (needSwap) {
                    let tmp = validApps[i]
                    validApps[i] = validApps[j]
                    validApps[j] = tmp
                }
            }
        }
        var cnt: Int64 = 0
        for (app in validApps) {
            if (cnt >= Si) { break }
            let id = app[1]
            var can = true
            if (lastReceive.contains(id)) {
                let last = lastReceive[id]
                if (day - last <= P) { can = false }
            }
            if (can) {
                out.append("${app[0]} ${id}\n")
                lastReceive[id] = day
                cnt+=1
            }
        }
    }
    for (s in sickOrder) { out.append("${s}\n") }
    print(out.toString())
}
