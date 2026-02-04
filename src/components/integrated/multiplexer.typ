#import "../../component.typ": component, interface
#import "../../dependencies.typ": cetz
#import cetz.draw: anchor, content, line, polygon, rect, scope, translate, set-style

#let mux(name, node, inputs: 2, ..params) = {
  assert(inputs >= 2, message: "A multiplexer needs at least 2 inputs!")
  let draw(ctx, position, style) = {
    let spacing = style.spacing
    let bit-width = int(calc.ceil(calc.log(inputs, base: 2)))
    
    //dynamic dimensions
    let h_total = calc.max(style.min-height, (inputs - 1) * spacing + 6 * style.padding)
    let h = h_total / 2
    
    let w = style.width + (bit-width * 0.1)
    let slope = h * 0.4 

    interface((-w/2, -h), (w/2, h), io: false)
    line((-w/2, -h), (w/2, h), stroke: none, name: "bounds")

    set-style(stroke: ctx.style.stroke)
    
    // body
    line((-w/2, h), (w/2, h - slope))         
    line((w/2, h - slope), (w/2, -h + slope)) 
    line((w/2, -h + slope), (-w/2, -h))       
    line((-w/2, -h), (-w/2, h))               

    // inputs
    let spread = (inputs - 1) * spacing
    for i in range(0, inputs) {
      let y-pos = (spread / 2) - (i * spacing)
      anchor("in" + str(i + 1), (-w/2, y-pos))
      let bin-val = ""
      let temp-i = i
      for _ in range(bit-width) {
        bin-val = str(calc.rem(temp-i, 2)) + bin-val
        temp-i = calc.floor(temp-i / 2)
      }

      // 2. Binär-Anker (z.B. "in00", "in01")
      anchor("in" + bin-val, (-w/2, y-pos))
      
      let bin-val = ""
      let temp-i = i
      for _ in range(bit-width) {
        bin-val = str(calc.rem(temp-i, 2)) + bin-val
        temp-i = calc.floor(temp-i / 2)
      }

      //input labels
      content((-w/2 + 0.45, y-pos), text(1.2em, weight: "bold")[#bin-val])
    }

    //sets the selectors
    for i in range(0, bit-width) {
      let x-pos = (w / 2) - (i + 1) * (w / (bit-width + 1))
      let y-pos = (-slope / w) * x-pos + (h - slope / 2)
      let s-idx = bit-width - 1 - i
      
      anchor("sel" + str(s-idx), (x-pos, y-pos))
      //selector label shifted here
      content((x-pos - 0.25, y-pos + 0.4), text(0.9em)[$S_#s-idx$])
    }

    //output
    anchor("out", (w/2, 0))
  }

  component("mux", name, node, draw: draw, ..params)
}

#let dmux(name, node, outputs: 2, ..params) = {
  assert(outputs >= 2, message: "A demultiplexer needs at least 2 outputs.")
  
  let draw(ctx, position, style) = {
    let spacing = style.spacing
    let bit-width = int(calc.ceil(calc.log(outputs, base: 2)))
    
    let h_total = calc.max(style.min-height, (outputs - 1) * spacing + 6 * style.padding)
    let h = h_total / 2
    let w = style.width + (bit-width * 0.4) 
    let slope = h * 0.4 

    interface((-w/2, -h), (w/2, h), io: false)
    line((-w/2, -h), (w/2, h), stroke: none, name: "bounds")

    set-style(stroke: ctx.style.stroke)
    
    // Gehäuse DMUX (Trapez andersherum: links schmaler als rechts)
    line((-w/2, h - slope), (w/2, h))         
    line((w/2, h), (w/2, -h)) 
    line((w/2, -h), (-w/2, -h + slope))       
    line((-w/2, -h + slope), (-w/2, h - slope))

    // Ausgänge (Rechts)
    let spread = (outputs - 1) * spacing
    for i in range(0, outputs) {
      let y-pos = (spread / 2) - (i * spacing)
      anchor("out" + str(i + 1), (w/2, y-pos))
      anchor("out" + bin-val, (w/2, y-pos))
      
      let bin-val = ""
      let temp-i = i
      for _ in range(bit-width) {
        bin-val = str(calc.rem(temp-i, 2)) + bin-val
        temp-i = calc.floor(temp-i / 2)
      }
      // Beschriftung rechtsbündig an der Innenkante
      content((w/2 - 0.4, y-pos), text(1.2em, weight: "bold")[#bin-val])
    }

    // Selektoren (Oben auf der geraden Kante verteilt)
    for i in range(0, bit-width) {
      let x-pos = (w / 2) - (i + 1) * (w / (bit-width + 1))
      // Y-Position ist hier einfacher, da die obere Kante beim DMUX zum Teil flach/schräg gemischt ist
      // Wir setzen sie einfach auf die obere Linie:
      let y-pos = if x-pos < -w/2 { h - slope } else { (slope / w) * x-pos + (h - slope/2) }
      
      let s-idx = bit-width - 1 - i
      anchor("sel" + str(s-idx), (x-pos, y-pos))
      content((x-pos + 0.25, y-pos + 0.4), text(0.9em)[$S_#s-idx$])
    }

    // Eingang (Links mittig)
    anchor("in", (-w/2, 0))
  }
  component("dmux", name, node, draw: draw, ..params)
}

#let mux2(name, node, ..params) = mux(name, node, inputs: 2, ..params)
#let mux4(name, node, ..params) = mux(name, node, inputs: 4, ..params)
#let mux8(name, node, ..params) = mux(name, node, inputs: 8, ..params)

#let dmux2(name, node, ..params) = dmux(name, node, outputs: 2, ..params)
#let dmux4(name, node, ..params) = dmux(name, node, outputs: 4, ..params)
#let dmux8(name, node, ..params) = dmux(name, node, outputs: 8, ..params)