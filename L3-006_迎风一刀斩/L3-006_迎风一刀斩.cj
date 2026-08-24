// L3-006 迎风一刀斩 - 判断两多边形能否拼成轴对齐矩形
import std.env.*
import std.collection.*
import std.convert.*

main(){
    let cin=getStdIn()
    let all=cin.readToEnd()??""
    let runes=all.toRuneArray()
    let tokens=ArrayList<String>()
    var sb=StringBuilder()
    let sp:Rune=' '
    let nl:Rune='\n'
    let tab:Rune='\t'
    let cr:Rune='\r'
    for(r in runes){
        if(r==sp||r==nl||r==tab||r==cr){
            let cur=sb.toString()
            if(cur.size>0){ tokens.add(cur) }
            sb=StringBuilder()
        } else { sb.append(r) }
    }
    let last=sb.toString()
    if(last.size>0){ tokens.add(last) }
    if(tokens.size==0){ return }
    var p: Int64=0
    let Npairs=Int64.parse(tokens[p]); p++
    let polysA=ArrayList<ArrayList<Array<Int64>>>()
    let polysB=ArrayList<ArrayList<Array<Int64>>>()
    for(i in 0..Npairs){
        if(p >= tokens.size){ break }
        let k1=Int64.parse(tokens[p]); p++
        let pts1=ArrayList<Array<Int64>>()
        for(j in 0..k1){
            let x=Int64.parse(tokens[p]); p++
            let y=Int64.parse(tokens[p]); p++
            pts1.add([x,y])
        }
        let k2=Int64.parse(tokens[p]); p++
        let pts2=ArrayList<Array<Int64>>()
        for(j in 0..k2){
            let x=Int64.parse(tokens[p]); p++
            let y=Int64.parse(tokens[p]); p++
            pts2.add([x,y])
        }
        polysA.add(pts1)
        polysB.add(pts2)
    }
    func transform(pts: ArrayList<Array<Int64>>, flip: Bool, rot: Int64): ArrayList<Array<Int64>> {
        let res=ArrayList<Array<Int64>>()
        for(pt in pts){
            var x=pt[0]
            var y=pt[1]
            if(flip){ x = -x }
            for(r in 0..rot){
                let nx = -y
                let ny = x
                x=nx; y=ny
            }
            res.add([x,y])
        }
        return res
    }
    func doubleArea(pts: ArrayList<Array<Int64>>): Int64 {
        var s: Int64=0
        let m=pts.size
        for(i in 0..m){
            let j=(i+1)%m
            s += pts[i][0]*pts[j][1] - pts[j][0]*pts[i][1]
        }
        if(s<0){ s=-s }
        return s
    }
    func isConvex(pts: ArrayList<Array<Int64>>): Bool {
        let m=pts.size
        if(m<3){ return false }
        var sign: Int64=0
        for(i in 0..m){
            let a=pts[i]
            let b=pts[(i+1)%m]
            let c=pts[(i+2)%m]
            let dx1=b[0]-a[0]
            let dy1=b[1]-a[1]
            let dx2=c[0]-b[0]
            let dy2=c[1]-b[1]
            let cross=dx1*dy2 - dy1*dx2
            if(cross!=0){
                if(sign==0){
                    if(cross>0){ sign=1 } else { sign=-1 }
                } else {
                    if((cross>0 && sign<0) || (cross<0 && sign>0)){ return false }
                }
            }
        }
        return true
    }
    func canForm(pA: ArrayList<Array<Int64>>, pB: ArrayList<Array<Int64>>): Bool {
        for(flipA in 0..2){
            for(rotA in 0..4){
                let A=transform(pA, flipA==1, rotA)
                if(!isConvex(A)){ continue }
                let areaA=doubleArea(A)
                for(flipB in 0..2){
                    for(rotB in 0..4){
                        let B=transform(pB, flipB==1, rotB)
                        if(!isConvex(B)){ continue }
                        let areaB=doubleArea(B)
                        let nA=A.size
                        let nB=B.size
                        for(eA in 0..nA){
                            let p1=A[eA]
                            let p2=A[(eA+1)%nA]
                            let dxA=p2[0]-p1[0]
                            let dyA=p2[1]-p1[1]
                            for(eB in 0..nB){
                                let q1=B[eB]
                                let q2=B[(eB+1)%nB]
                                let dxB=q2[0]-q1[0]
                                let dyB=q2[1]-q1[1]
                                if(dxA != -dxB || dyA != -dyB){ continue }
                                let tx=p2[0]-q1[0]
                                let ty=p2[1]-q1[1]
                                if(q2[0]+tx != p1[0] || q2[1]+ty != p1[1]){ continue }
                                let Bt=ArrayList<Array<Int64>>()
                                for(pt in B){ Bt.add([pt[0]+tx, pt[1]+ty]) }
                                var minX: Int64 = 9000000000000000000
                                var maxX: Int64 = -9000000000000000000
                                var minY: Int64 = 9000000000000000000
                                var maxY: Int64 = -9000000000000000000
                                for(pt in A){
                                    if(pt[0] < minX){ minX=pt[0] }
                                    if(pt[0] > maxX){ maxX=pt[0] }
                                    if(pt[1] < minY){ minY=pt[1] }
                                    if(pt[1] > maxY){ maxY=pt[1] }
                                }
                                for(pt in Bt){
                                    if(pt[0] < minX){ minX=pt[0] }
                                    if(pt[0] > maxX){ maxX=pt[0] }
                                    if(pt[1] < minY){ minY=pt[1] }
                                    if(pt[1] > maxY){ maxY=pt[1] }
                                }
                                let w=maxX-minX
                                let h=maxY-minY
                                if(w<=0 || h<=0){ continue }
                                let box2=w*h*2
                                if(areaA+areaB != box2){ continue }
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    let outSb=StringBuilder()
    for(i in 0..Npairs){
        let a=polysA[i]
        let b=polysB[i]
        if(canForm(a,b)){
            outSb.append("YES\n")
        } else {
            outSb.append("NO\n")
        }
    }
    print(outSb.toString())
}
