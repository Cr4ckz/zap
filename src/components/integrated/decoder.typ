#import "../../component.typ": component, interface
#import "../../dependencies.typ": cetz
#import cetz.draw: anchor, content, line, polygon, rect, scope, translate, set-style

#let decoder(name, node, outputs: 2, ..params) = {
  assert(outputs >= 2, message: "A decoder needs at least 2 outputs")
  
  let draw(ctx, position, style) = {
    let s = style.spacing * 1.5
    let p = style.padding
    let bit-width = int(calc.ceil(calc.log(outputs, base: 2)))
    
    // Dimensions
    let h_total = (outputs - 1) * s + (4 * p)
    let h = h_total / 2
    let w = style.width + (bit-width * 0.4)
    
    interface((-w/2, -h), (w/2, h), io: false)
    line((-w/2, -h), (w/2, h), stroke: none, name: "bounds")

    set-style(stroke: ctx.style.stroke)
    
    cetz.draw.rect((-w/2, -h), (w/2, h), fill: white)

    // adressspace
    let in_spread = (bit-width - 1) * s
    for i in range(0, bit-width) {
      let y-pos = (in_spread / 2) - (i * s)
      let idx = bit-width - 1 - i
      anchor("in" + str(idx), (-w/2, y-pos))
      content((-w/2 + 0.4, y-pos), text(1.1em)[$A_#idx$])
    }

    // outputs
    let out_spread = (outputs - 1) * s
    for i in range(0, outputs) {
      let y-pos = (out_spread / 2) - (i * s)
      
      let bin-val = ""
      let temp-i = i
      for _ in range(bit-width) {
        bin-val = str(calc.rem(temp-i, 2)) + bin-val
        temp-i = calc.floor(temp-i / 2)
      }

      anchor("out" + str(i + 1), (w/2, y-pos))
      anchor("out" + bin-val, (w/2, y-pos))
      
      content((w/2 - 0.4, y-pos), text(1.2em, weight: "bold")[#bin-val])
    }

    content((0, h - 0.5), text(0.7em, weight: "black")[DECODER])
  }

  component("decoder", name, node, draw: draw, ..params)
}

#let decoder2 = decoder.with(outputs: 2)
#let decoder4 = decoder.with(outputs: 4)
#let decoder8 = decoder.with(outputs: 8)