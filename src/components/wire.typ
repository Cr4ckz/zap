#import "../dependencies.typ": cetz
#import "../utils.typ": get-style, opposite-anchor, resolve-style
#import cetz.draw: anchor, circle, content, group, hide, line, mark, set-style, set-origin
#import cetz.styles: merge

#let ra = ratio

#let wire(bits: 0, shape: "direct", ratio: 50%, axis: "x", i: none, name: none, ..params) = {
    assert(type(bits) == int, message: "bits must be an int")
    assert(params.pos().len() >= 2, message: "wires need at least two points")
    assert(type(ratio) in (ra, int, float, length), message: "ratio must be a ratio, a number or a length")
    assert(shape in ("direct", "zigzag", "dodge"), message: "shape must be direct, zigzag or dodge")

    group(name: name, ctx => {
        let style = get-style(ctx).wire
        let (ctx, ..points) = cetz.coordinate.resolve(ctx, ..params.pos())

        set-style(stroke: style.stroke)
        let final-points = ()

        // Drawing the wire using the shape parameter
        anchor("in", points.first())
        anchor("out", points.last())
        for (index, point) in points.enumerate() {
            anchor("p" + str(index), point)
        }
        if shape == "direct" {
            final-points = points
            line(..points, name: "line")
        } else if shape == "zigzag" {
            if points.len() < 2 { return }

            let generated-points = ()
            for i in range(points.len() - 1) {
                let p1 = points.at(i)
                let p2 = points.at(i + 1)
                let (ctx, p-mid) = cetz.coordinate.resolve(ctx, (p1, ratio, p2))

                let p-mid1 = if axis == "x" { (p-mid.at(0), p1.at(1)) } else { (p1.at(0), p-mid.at(1)) }
                let p-mid2 = if axis == "x" { (p-mid.at(0), p2.at(1)) } else { (p2.at(0), p-mid.at(1)) }

                group(name: "p" + str(i) + "-p" + str(i + 1), {
                    anchor("a", p-mid1)
                    anchor("b", p-mid2)
                })

                generated-points = (..generated-points, p1, p-mid1, p-mid2)
            }
            final-points = (..generated-points, points.last())
            line(..generated-points, points.last(), name: "line")
        }
        for (index, point) in final-points.enumerate() {
            anchor("p" + str(index), point)
        }

    // Multi-bits wiring
        if bits != 0 and final-points.len() >= 2 {
            let n = final-points.len()
            let default-dist = 0.3 
            
            let marker-configs = (
                (s: "p0", e: "p1", name: "start"),
                (s: "p" + str(n - 1), e: "p" + str(n - 2), name: "end")
            )

            for m in marker-configs {
                group(name: "bus-marker-" + m.name, {
                    cetz.draw.get-ctx(ctx => {
                        let (ctx, p-s) = cetz.coordinate.resolve(ctx, m.s)
                        let (ctx, p-e) = cetz.coordinate.resolve(ctx, m.e)
                        
                        let len = cetz.vector.dist(p-s, p-e)
                        
                        let actual-dist = calc.min(default-dist, len * 0.4)
                        
                        set-origin((m.s, actual-dist, m.e))
                        
                        let angle = cetz.vector.angle2(p-s, p-e)
                        
                        group({
                          cetz.draw.rotate(angle + 30deg)
                          line((0, -0.15), (0, 0.15), stroke: style.stroke)
                        })
                        
                        let display = if type(bits) == int { [#bits] } else { bits }
                        if type(bits) != int or bits > 1 {
                            content(
                                (0, -0.175), 
                                text(0.7em, weight: "bold", display), 
                                anchor: "north"
                            )
                        }
                    })
                })
            }
        }

        // Current decoration
        if i != none {
            let zap-style = ctx.zap.style
            zap-style.decoration.current.wire = merge(zap-style.decoration.current.wire, if type(i) == dictionary { i } else { (content: i) })

            let dec = resolve-style(zap-style).decoration.current.wire
            mark(
                (name: "line", anchor: dec.position),
                (name: "line", anchor: dec.position + if type(dec.position) == ra { 1% } else { 0.1 }),
                symbol: dec.symbol,
                reverse: dec.invert,
                anchor: "center",
                fill: dec.stroke.paint,
                stroke: 0pt,
                scale: dec.scale * get-style(ctx).decoration.scale,
            )
            content(
                (name: "line", anchor: dec.position),
                anchor: opposite-anchor(dec.anchor),
                dec.content,
                padding: dec.distance,
            )
        }
    })
}


#let zwire(..params) = wire(shape: "zigzag", ..params)
#let swire(..params) = wire(shape: "zigzag", ratio: 100%, ..params)
