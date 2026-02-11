#import "../../component.typ": component, interface
#import "../../dependencies.typ": cetz
#import cetz.draw: anchor, content, line, polygon, rect, scope, set-style, translate

/// Arithmetic adder component (ALU-style) with corrected anchor positions and V-notch.
/// - name (string): Unique identifier.
/// - node (coordinate): Position in the CeTZ canvas.
/// - mode (string): "half" or "full".
/// - description (boolean): Whether to show pin labels (A, B, S, Cin, Cout).
/// *Anchors:* `a`, `b` (top), `cin` (right edge), `cout` (left edge), `s` (bottom).
#let adder(name, node, mode: "full", description: true, rotate: (0deg), ..params) = {
  let draw(ctx, position, style,) = {
    let w = style.width
    let h = style.height
    let notch-x = w * 0.12
    let notch-y = h * 0.35
    let slant = w * 0.15

    interface((-w / 2, -h / 2), (w / 2, h / 2), io: false)
    set-style(stroke: ctx.style.stroke)

    cetz.draw.merge-path(fill: white, close: true, {
      line((-w / 2, h / 2), (-notch-x, h / 2))
      line((-notch-x, h / 2), (0, h / 2 - notch-y))
      line((0, h / 2 - notch-y), (notch-x, h / 2))
      line((notch-x, h / 2), (w / 2, h / 2))
      line((w / 2, h / 2), (w / 2 - slant, -h / 2))
      line((w / 2 - slant, -h / 2), (-w / 2 + slant, -h / 2))
      line((-w / 2 + slant, -h / 2), (-w / 2, h / 2))
    })

    content((0, -h / 6), text(1.3em, weight: "bold")[$+$])

    anchor("a", (-(w / 2 + notch-x) / 2, h / 2))
    anchor("b", ((w / 2 + notch-x) / 2, h / 2))

    anchor("s", (0, -h / 2))

    if mode == "full" {
      anchor("cin", (w / 2 - slant / 2, 0))
    }

    anchor("cout", (-w / 2 + slant / 2, 0))

    if description {
      let anchors = (
        cin: "south-west",
        cout: "south-east",
      )
      if (rotate == 90deg) {
        anchors = (
          cin: "south-west",
          cout: "north-west",
        )
      }
      let label(pin-name, txt, default-anchor) = {
        content(pin-name, padding: 0.15, txt, anchor: default-anchor)
      }
      if mode == "full" {
        label("cin", [$C_(i n)$], anchors.cin)
      }
      content((rel: (0, -0.25), to: "a"), text(style.textsize, weight: "bold")[$A$])
      content((rel: (0, -0.25), to: "b"), text(style.textsize, weight: "bold")[$B$])
      content((rel: (-0.25, 0.2), to: "s"), text(style.textsize, weight: "bold")[$S$])
      label("cout", [$C_(o u t)$], anchors.cout)
    }
  }

  component("adder", name, node, draw: draw, rotate: rotate, ..params)
}

/// Half-Adder
/// - name (string): Unique identifier for the component.
/// - node (coordinate): Position in the CeTZ canvas.
/// - description (boolean): Whether to show pin labels (A, B, S, Cin, Cout).
/// *Anchors:* `a`, `b`, `s`, `cout`.
#let half_adder(name, node, ..params) = adder(name, node, mode: "half", ..params)

/// Full-Adder
/// - name (string): Unique identifier for the component.
/// - node (coordinate): Position in the CeTZ canvas.
/// - description (boolean): Whether to show pin labels (A, B, S, Cin, Cout).
/// *Anchors:* `a`, `b`, `cin`, `s`, `cout`.
#let full_adder(name, node, mode: "full", ..params) = adder(name, node, mode: "full", ..params)
