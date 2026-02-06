#import "../component.typ": component, interface
#import "../dependencies.typ": cetz
#import cetz.draw: anchor, arc-through, circle, content, line, rect, rotate,set-style, bezier, arc, set-origin, merge-path

#let logic(name, node, text: $"&"$, invert: false, inputs: 2, ..params) = {
    assert(inputs >= 2, message: "logic supports minimum two inputs")

    // Drawing function
    let draw(ctx, position, style) = {
        let height = calc.max(style.min-height, (inputs - 1) * style.spacing + 2 * style.padding)
        interface((-style.width / 2, -height / 2), (style.width / 2, height / 2), io: false)

        rect((-style.width / 2, -height / 2), (rel: (style.width, height)), fill: style.fill, stroke: style.stroke)
        content((0, height / 2 - style.padding), text, anchor: "north")

        for input in range(1, inputs + 1) {
            anchor("in" + str(input), (-style.width / 2, height / 2 - style.padding - (input - 1) * style.spacing))
        }

        if invert {
            line((style.width / 2, style.invert-height), (rel: (style.invert-width, -style.invert-height)))
            line((style.width / 2, 0), (rel: (style.invert-width, 0)))
            anchor("out", ())
        } else {
            anchor("out", (style.width / 2, 0))
        }
    }

    // Component call
    component("logic", name, node, draw: draw, ..params)
}

/// American (MIL-STD) logic gate component with dynamic input scaling.
/// - name (string): Unique identifier for the component.
/// - node (coordinate): Position in the CeTZ canvas.
/// - type (string): Gate logic type ("and", "nand", "or", "nor", "xor", "xnor", "not", "buffer").
/// - inputs (int): Number of input pins (ignored for NOT and Buffer).
/// *Anchors:* /// - `in1` to `in{n}`: Input pins (left).
/// - `out`: Output pin (right).
#let logic_american(name, node, type: "and", inputs: 2, ..params) = {
  let draw(ctx, position, style) = {
    let is-negated = type in ("nand", "nor", "not", "xnor")
    let is-or-style = type in ("or", "nor", "xor", "xnor")
    let is-xor-style = type in ("xor", "xnor")
    let is-triangle = type in ("not", "buffer")
    let is-not = type == "not"
    
    let actual-inputs = if is-triangle { 1 } else { inputs }
    
    let spread = (actual-inputs - 1) * style.spacing
    let h = calc.max(style.min-height, spread + 2 * style.padding) / 2
    let w = if is-not { style.width * 0.8 } else { style.width }

    interface((-w / 2, -h), (w / 2, h), io: false)
    set-style(stroke: ctx.style.stroke)
    
    let bubble-attach-x = w / 2

    merge-path(fill: white, close: true, {
      if is-triangle {
        line((-w/2, h), (-w/2, -h), (w/2, 0))
      } else if is-or-style {
        bezier((-w/2, h), (w/2, 0), (w/8, h), (w/2, h/2))
        bezier((w/2, 0), (-w/2, -h), (w/2, -h/2), (w/8, -h))
        bezier((-w/2, -h), (-w/2, h), (-w/4, -h/2), (-w/4, h/2))
      } else {
        line((-w/2, h), (0, h))
        bezier((0, h), (0, -h), (w * 0.65, h), (w * 0.65, -h))
        line((0, -h), (-w/2, -h), (-w/2, h))
      }
    })

    if is-xor-style {
      let x-off = 0.15
      bezier((-w/2 - x-off, h), (-w/2 - x-off, -h), (-w/4 - x-off, h/2), (-w/4 - x-off, -h/2))
    }

    if is-negated {
      let r = style.invert-width / 2
      circle((bubble-attach-x + r, 0), radius: r, fill: white)
      anchor("out", (bubble-attach-x + style.invert-width, 0))
    } else {
      anchor("out", (bubble-attach-x, 0))
    }

    for i in range(0, actual-inputs) {
      let y-pos = (spread / 2) - (i * style.spacing)
      
      let x-indent = if is-or-style {
        (1 - calc.pow(y-pos / h, 2)) * 0.18 
      } else { 0 }
      
      let input-x = if is-xor-style { 
        -w/2 - 0.15 + x-indent 
      } else if is-or-style { 
        -w/2 + x-indent 
      } else { 
        -w/2 
      }
      
      anchor("in" + str(i + 1), (input-x, y-pos))
    }
  }

  component("logic_american", name, node, draw: draw, ..params)
}

#let lnot(name, node, ..params) = logic(name, node, ..params, text: $1$, invert: true)
#let land(name, node, ..params) = logic(name, node, ..params, text: $"&"$)
#let lnand(name, node, ..params) = logic(name, node, ..params, text: $"&"$, invert: true)
#let lor(name, node, ..params) = logic(name, node, ..params, text: $>=1$)
#let lnor(name, node, ..params) = logic(name, node, ..params, text: $>=1$, invert: true)
#let lxor(name, node, ..params) = logic(name, node, ..params, text: $=1$)
#let lxnor(name, node, ..params) = logic(name, node, ..params, text: $=1$, invert: true)

/// American NOT Gate (Inverter).
/// - name (string): Unique identifier for the component.
/// - node (coordinate): Position in the CeTZ canvas.
/// *Anchors:* `in1`, `out`.
#let anot(name, node, ..params) = logic_american(name, node, type: "not", inputs: 1, ..params)

/// American AND Gate.
/// - name (string): Unique identifier for the component.
/// - node (coordinate): Position in the CeTZ canvas.
/// - inputs (int): Number of input pins
/// *Anchors:* `in1` to `in{n}`, `out`.
#let aand(name, node, inputs: 2, ..params) = logic_american(name, node, type: "and", inputs: inputs, ..params)

/// American NAND Gate with inversion bubble.
/// - name (string): Unique identifier for the component.
/// - node (coordinate): Position in the CeTZ canvas.
/// - inputs (int): Number of input pins
/// *Anchors:* `in1` to `in{n}`, `out`.
#let anand(name, node, inputs: 2, ..params) = logic_american(name, node, type: "nand", inputs: inputs, ..params)

/// American OR Gate with curved input and pointed output.
/// - name (string): Unique identifier for the component.
/// - node (coordinate): Position in the CeTZ canvas.
/// - inputs (int): Number of input pins
/// *Anchors:* `in1` to `in{n}`, `out`.
#let aor(name, node, inputs: 2, ..params) = logic_american(name, node, type: "or", inputs: inputs, ..params)

/// American NOR Gate.
/// - name (string): Unique identifier for the component.
/// - node (coordinate): Position in the CeTZ canvas.
/// - inputs (int): Number of input pins
/// *Anchors:* `in1` to `in{n}`, `out`.
#let anor(name, node, inputs: 2, ..params) = logic_american(name, node, type: "nor", inputs: inputs, ..params)

/// American NOR Gate.
/// - name (string): Unique identifier for the component.
/// - node (coordinate): Position in the CeTZ canvas.
/// - inputs (int): Number of input pins
/// *Anchors:* `in1` to `in{n}`, `out`.
#let axor(name, node, inputs: 2, ..params) = logic_american(name, node, type: "xor", inputs: inputs, ..params)

/// American XNOR Gate.
/// - name (string): Unique identifier for the component.
/// - node (coordinate): Position in the CeTZ canvas.
/// - inputs (int): Number of input pins
/// *Anchors:* `in1` to `in{n}`, `out`.
#let axnor(name, node, inputs: 2, ..params) = logic_american(name, node, type: "xnor", inputs: inputs, ..params)

/// American BUFFER Gate.
/// - name (string): Unique identifier for the component.
/// - node (coordinate): Position in the CeTZ canvas.
/// *Anchors:* `in1`, `out`.
#let abuffer(name, node, ..params) = logic_american(name, node, type: "buffer", inputs: 1, ..params)

/// American (MIL-STD) logic gate component with dynamic input scaling.
/// - name (string): Unique identifier for the component.
/// - node (coordinate): Position in the CeTZ canvas.
/// - type (string): Gate logic type ("and", "nand", "or", "nor", "xor", "xnor", "not", "buffer").
/// - inputs (int): Number of input pins (ignored for NOT and Buffer).
/// *Anchors:* /// - `in1` to `in{n}`: Input pins (left).
/// - `out`: Output pin (right).
#let alogic(name: none, node: (0,0), type: "and", inputs: 2, ..params) = logic_american(name: name, node: node, type: type, inputs: inputs, ..params)
