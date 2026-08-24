// L3-043 门诊预约排队系统
import std.collection.*
import std.convert.*
import std.env.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().size == 0) { return }
    let lines = all.split("\n")
    let filt = ArrayList<String>()
    for (ln in lines) {
        let t = ln.trimAscii()
        if (t.size>0) { filt.add(t) }
    }
    let n = Int64.parse(filt[0].trimAscii().split(" ")[0])
    let patients = ArrayList<Array<String>>()
    // Actually need to parse n lines, each with 4 tokens: arrival, appointment, ID, age
    // Use filt[1..n]
    let arrivals = Array<Int64>(n, repeat: 0)
    let appointments = Array<Int64>(n, repeat: 0)
    let ids = Array<String>(n, repeat: "")
    let ages = Array<Int64>(n, repeat: 0)
    for (i in 0..n) {
        let line = filt[i+1]
        let toks = line.split(" ")
        let clean = ArrayList<String>()
        for (p in toks) { if (p.size>0) { clean.add(p) } }
        arrivals[i]=Int64.parse(clean[0])
        appointments[i]=Int64.parse(clean[1])
        ids[i]=clean[2]
        ages[i]=Int64.parse(clean[3])
    }
    // byAppointment
    let byApp = Array<Int64>(n+1, repeat: -1)
    for (i in 0..n) {
        let ap = appointments[i]
        if (ap>=1 && ap<=n) { byApp[ap]=i }
    }
    // arrival buckets
    let maxTime = n + 10000 // enough
    let buckets = Array<ArrayList<Int64>>(maxTime+1, repeat: ArrayList<Int64>())
    for (i in 0..maxTime+1) { buckets[i]=ArrayList<Int64>() }
    for (i in 0..n) {
        let at = arrivals[i]
        if (at>=1 && at<=maxTime) { buckets[at].add(i) }
        else if (at<1) { buckets[1].add(i) }
    }
    let seen = Array<Bool>(n, repeat: false)
    let actual = Array<Int64>(n, repeat: 0)
    let waiting = ArrayList<Int64>()
    var time: Int64 = 1
    var seenCnt: Int64 = 0
    while (seenCnt < n) {
        if (time <= maxTime) {
            for (p in buckets[time]) {
                waiting.add(p)
            }
        }
        if (waiting.size == 0) {
            time++
            if (time > maxTime) { break }
            continue
        }
        var chosen: Int64 = -1
        // check appointment == time
        if (time >=1 && time <= n) {
            let apIdx = byApp[time]
            if (apIdx != -1) {
                // check if apIdx in waiting
                var found = false
                for (w in waiting) { if (w==apIdx) { found=true; break } }
                if (found) { chosen = apIdx }
            }
        }
        if (chosen == -1) {
            // check elderly
            let elderly = ArrayList<Int64>()
            for (w in waiting) { if (ages[w] >= 80) { elderly.add(w) } }
            if (elderly.size > 0) {
                var best = elderly[0]
                for (k in 1..elderly.size) {
                    let cand = elderly[k]
                    if (appointments[cand] < appointments[best]) { best=cand }
                }
                chosen = best
            } else {
                var best = waiting[0]
                for (k in 1..waiting.size) {
                    let cand = waiting[k]
                    if (appointments[cand] < appointments[best]) { best=cand }
                }
                chosen = best
            }
        }
        actual[chosen]=time
        // remove from waiting
        let nw = ArrayList<Int64>()
        for (w in waiting) { if (w != chosen) { nw.add(w) } }
        waiting.clear()
        for (w in nw) { waiting.add(w) }
        seen[chosen]=true
        seenCnt++
        time++
        // prevent infinite loop
        if (time > n + 10000) { break }
    }
    // output sorted by actual time ascending
    let order = ArrayList<Int64>()
    for (i in 0..n) { order.add(i) }
    for (i in 0..order.size) {
        for (j in i+1..order.size) {
            if (actual[order[j]] < actual[order[i]]) {
                let t=order[i]; order[i]=order[j]; order[j]=t
            }
        }
    }
    for (idx in order) {
        let sb = StringBuilder()
        sb.append(actual[idx].toString())
        sb.append(" ")
        sb.append(ids[idx])
        println(sb.toString())
    }
}
