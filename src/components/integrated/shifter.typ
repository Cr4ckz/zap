#import "../../component.typ": component, interface
#import "../../dependencies.typ": cetz
#import cetz.draw: anchor, content, line, merge-path, set-style

/// Barrel Shifter component (Parallelogram shape).
/// - name (string): Unique identifier.
/// - node (coordinate): Position in the CeTZ canvas.
/// - label (string): The shift symbol (default: ">>>" for logical right shift).
/// - angle (angle): Rotation of the component.
/// *Anchors:* `in` (left), `out` (right), `shamt` (top).
#let shifter(name, node, label: ">>>", angle: 0deg, ..params) = {
  let draw(ctx, position, style) = {
    let w = style.at("width", default: 1.2)
    let h = style.at("height", default: 0.8)
    let slant = w * 0.2

    interface((-w/2 - slant, -h/2), (w/2 + slant, h/2), io: false)
    
    set-style(stroke: ctx.style.stroke)
    
    cetz.draw.rotate(angle)

    if(label.contains(">")){
      merge-path(fill: white, close: true, {
      line((-w/2 + slant, h/2), (w/2 + slant, h/2))
      line((w/2 + slant, h/2), (w/2 - slant, -h/2))
      line((w/2 - slant, -h/2), (-w/2 - slant, -h/2))
      line((-w/2 - slant, -h/2), (-w/2 + slant, h/2))
    })
    }else{
      cetz.draw.rotate(180deg)
      merge-path(fill: white, close: true, {
      line((-w/2 + slant, h/2), (w/2 + slant, h/2))
      line((w/2 + slant, h/2), (w/2 - slant, -h/2))
      line((w/2 - slant, -h/2), (-w/2 - slant, -h/2))
      line((-w/2 - slant, -h/2), (-w/2 + slant, h/2))
    })
    cetz.draw.rotate(180deg)
    }
    


    content((0, 0), text(style.at("textsize", default: 1.0em), weight: "bold")[#label])

    anchor("in",    (-w/2, 0))
    anchor("out",   (w/2, 0))
    anchor("shamt", (0, h/2))
    
    anchor("nw", (-w/2 + slant,  h/2))
    anchor("ne", ( w/2 + slant,  h/2))
    anchor("sw", (-w/2 - slant, -h/2))
    anchor("se", ( w/2 - slant, -h/2))
  }

  component("shifter", name, node, draw: draw, ..params)
}