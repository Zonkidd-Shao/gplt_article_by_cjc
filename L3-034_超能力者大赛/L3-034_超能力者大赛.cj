// L3-034 超能力者大赛 - 通用贪心模拟 + Floyd + 联盟
import std.collection.*
import std.convert.*
import std.env.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().size == 0) { return }
    let tmp = all.replace("\n", " ").replace("\r", " ").replace("\t", " ")
    let parts = tmp.split(" ")
    let toks = ArrayList<String>()
    for (p in parts) { if (p.size > 0) { toks.add(p) } }
    var idx: Int64 = 0
    func nextInt(): Int64 {
        let v = Int64.parse(toks[idx])
        idx++
        return v
    }
    let N = nextInt()
    let M = nextInt()
    let Me = nextInt()
    let D = nextInt()
    let city = Array<Int64>(N, repeat: 0)
    let power = Array<Int64>(N, repeat: 0)
    for (i in 0..N) {
        city[i] = nextInt()
        power[i] = nextInt()
    }
    let INF: Int64 = 1000000000
    let dist = Array<Array<Int64>>(M, repeat: Array<Int64>(0, repeat: 0))
    let hops = Array<Array<Int64>>(M, repeat: Array<Int64>(0, repeat: 0))
    for (i in 0..M) {
        dist[i] = Array<Int64>(M, repeat: INF)
        hops[i] = Array<Int64>(M, repeat: INF)
        dist[i][i] = 0
        hops[i][i] = 0
    }
    for (_ in 0..Me) {
        let a = nextInt()
        let b = nextInt()
        let w = nextInt()
        if (w < dist[a][b]) {
            dist[a][b] = w
            dist[b][a] = w
            hops[a][b] = 1
            hops[b][a] = 1
        } else if (w == dist[a][b] && 1 < hops[a][b]) {
            hops[a][b] = 1
            hops[b][a] = 1
        }
    }
    for (k in 0..M) {
        for (i in 0..M) {
            for (j in 0..M) {
                let nd = dist[i][k] + dist[k][j]
                if (nd < dist[i][j]) {
                    dist[i][j] = nd
                    hops[i][j] = hops[i][k] + hops[k][j]
                } else if (nd == dist[i][j]) {
                    let nh = hops[i][k] + hops[k][j]
                    if (nh < hops[i][j]) {
                        hops[i][j] = nh
                    }
                }
            }
        }
    }
    // city entities
    let cityEnts = Array<ArrayList<Int64>>(M, repeat: ArrayList<Int64>())
    for (i in 0..M) { cityEnts[i] = ArrayList<Int64>() }
    // ensure distinct arrays for dist/hops already handled

    for (i in 1..N) {
        let c = city[i]
        cityEnts[c].add(power[i])
    }
    var totalRem: Int64 = N - 1
    var myPos = city[0]
    var myPower = power[0]
    var day: Int64 = 1
    var blockedCity: Int64 = -1
    var wsbdwzbl: Int64 = 0
    // helper to count total remaining (already)
    while (true) {
        if (totalRem == 0) {
            println("WIN on day ${day - 1} with ${myPower}!")
            break
        }
        if (day > D) {
            println("Game over with ${myPower}.")
            break
        }
        // find best target respecting blockedCity
        var maxBeat: Int64 = -1
        for (c in 0..M) {
            if (c == blockedCity) { continue }
            for (e in cityEnts[c]) {
                if (e <= myPower && e > maxBeat) { maxBeat = e }
            }
        }
        // if blocked city had the only beatable, we already excluded, so maxBeat may be -1 -> Lose
        // Also consider that if blockedCity == -1, we already computed correctly
        // If maxBeat == -1 but there exists beatable in blocked city, that beatable is not reachable due to forced leave, so still Lose (as per spec)
        if (maxBeat == -1) {
            // check if there is any beatable in blocked city that we ignored: then still Lose (same)
            // No need to check, just Lose
            println("Lose on day ${day} with ${myPower}.")
            break
        }
        // among maxBeat, pick closest
        var bestCity: Int64 = -1
        var bestDist: Int64 = INF
        var bestHops: Int64 = INF
        for (c in 0..M) {
            if (c == blockedCity) { continue }
            // check if city has at least one entity == maxBeat
            var has = false
            for (e in cityEnts[c]) { if (e == maxBeat) { has = true; break } }
            if (!has) { continue }
            let d = dist[myPos][c]
            if (d >= INF) { continue }
            let h = hops[myPos][c]
            if (bestCity == -1 || d < bestDist || (d == bestDist && h < bestHops) || (d == bestDist && h == bestHops && c < bestCity)) {
                bestCity = c
                bestDist = d
                bestHops = h
            }
        }
        if (bestCity == -1) {
            // no reachable beatable (all unreachable)
            println("Lose on day ${day} with ${myPower}.")
            break
        }
        // move if needed
        var fightDay = day
        if (bestCity != myPos) {
            let travel = bestDist
            fightDay = day + travel
            if (fightDay > D) {
                println("Game over with ${myPower}.")
                break
            }
            println("Move from ${myPos} to ${bestCity}.")
            myPos = bestCity
            day = fightDay
        } else {
            fightDay = day
        }
        // find one occurrence of maxBeat in bestCity
        var removeIdx: Int64 = -1
        for (i in 0..cityEnts[bestCity].size) {
            if (cityEnts[bestCity][i] == maxBeat) { removeIdx = i; break }
        }
        // remove
        cityEnts[bestCity].remove(at: removeIdx)
        totalRem--
        println("Get ${maxBeat} at ${bestCity} on day ${fightDay}.")
        myPower += maxBeat
        wsbdwzbl += maxBeat
        if (totalRem == 0) {
            println("WIN on day ${fightDay} with ${myPower}!")
            break
        }
        day = fightDay + 1
        if (day > D) {
            // after last fight, if we have consumed D, check win/lose already, now game over
            // But need to check if next day would be Lose vs Game over: spec says on last day first judge lose/win then game over.
            // Since we are at day = D+1, we are beyond, so Game over
            println("Game over with ${myPower}.")
            break
        }
        // alliance merging for city myPos (=bestCity)
        let cur = cityEnts[myPos]
        var weakSum: Int64 = 0
        var weakCnt: Int64 = 0
        let newList = ArrayList<Int64>()
        var hasStrong = false
        for (e in cur) {
            if (e <= myPower) {
                weakSum += e
                weakCnt++
            } else {
                newList.add(e)
                hasStrong = true
            }
        }
        if (weakCnt > 0) {
            totalRem = totalRem - weakCnt + 1
            newList.add(weakSum)
            if (weakSum > myPower) { hasStrong = true }
        }
        cityEnts[myPos] = newList
        if (hasStrong) {
            blockedCity = myPos
        } else {
            if (weakCnt > 0) {
                // stay: must defeat the weak alliance next day without global selection
                // newList should contain exactly one element (weakSum) when no strong
                // fight it now on day (which is already next day)
                if (day > D) {
                    println("Game over with ${myPower}.")
                    break
                }
                // locate alliance
                var sIdx: Int64 = -1
                for (i in 0..cityEnts[myPos].size) {
                    if (cityEnts[myPos][i] == weakSum) { sIdx = i; break }
                }
                cityEnts[myPos].remove(at: sIdx)
                totalRem--
                println("Get ${weakSum} at ${myPos} on day ${day}.")
                myPower += weakSum
                wsbdwzbl += weakSum
                if (totalRem == 0) {
                    println("WIN on day ${day} with ${myPower}!")
                    break
                }
                day = day + 1
                if (day > D) {
                    println("Game over with ${myPower}.")
                    break
                }
                // after stay fight, city becomes empty
                cityEnts[myPos] = ArrayList<Int64>()
                blockedCity = -1
            } else {
                blockedCity = -1
            }
        }
    }
}
