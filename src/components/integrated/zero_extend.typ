#import "../../component.typ": component, interface
#import "../../dependencies.typ": cetz
#import cetz.draw: anchor, content, line, polygon, rect, scope, translate, set-style, group

/// Zero-Extend component for bit-width expansion with rotation support.
/// - name (string): Unique identifier.
/// - node (coordinate): Position in the CeTZ canvas.
/// - label (string): The text shown inside the component (default: "ZE").
/// - angle (angle): Rotation angle (default: 0deg).
/// *Anchors:* `in`, `out`, `nw`, `ne`, `sw`, `se`.
#let zero_extend(name, node, label: "ZE", angle: 0deg, ..params) = {
  let draw(ctx, position, style) = {
    let w = style.at("width", default: 1.2)
    let h = style.at("height", default: 0.8)

    interface((-w/2, -h/2), (w/2, h/2), io: false)
    
    set-style(stroke: ctx.style.stroke)

    cetz.draw.rotate(angle)

    rect((-w/2, -h/2), (w/2, h/2), fill: white, name: "rect")


    content("rect", text(style.at("textsize", default: 0.7em), weight: "bold")[#label])

    anchor("in",  (-w/2, 0))
    anchor("out", (w/2, 0))
    
    anchor("nw", (-w/2,  h/2))
    anchor("ne", ( w/2,  h/2))
    anchor("sw", (-w/2, -h/2))
    anchor("se", ( w/2, -h/2))
  }

  component("zero_extend", name, node, draw: draw, ..params)
}

/// Sign-Extend component with rotation support.
/// - name (string): Unique identifier.
/// - node (coordinate): Position in the CeTZ canvas.
/// - angle (angle): Rotation angle (default: 0deg).
#let sign_extend(name, node, angle: 0deg, ..params) = zero_extend(name, node, label: "SE", angle: angle, ..params)