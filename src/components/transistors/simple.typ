#import "../../component.typ": component, interface
#import "../../dependencies.typ": cetz
#import "../../components/wire.typ": wire
#import cetz.draw: anchor, circle, content, floating, hide, line, mark, scale, set-origin, set-style, translate


/// Simplified MOSFET base component (CMOS logic style).
/// - name (string): Unique identifier for the component.
/// - node (coordinate): Position in the CeTZ canvas.
/// - channel (string): Either "n" or "p". "p" adds a circle at the gate.
/// *Anchors:* /// - `g`: Gate input (left).
/// - `d`: Drain (top right).
/// - `s`: Source (bottom right).
#let mosfet_simple(
    name,
    node,
    channel: "n",
    ..params,
) = {
    assert(channel in ("p", "n"), message: "channel must be `p` or `n`")

    let draw(ctx, position, style) = {
        let (height, width, base-width, base-spacing, radius) = style
        interface((-height, -width / 2), (0, width / 2))

        let center = (-height / 2, 0)

        anchor("d_int", (0, width / 2))
        anchor("s_int", (0, -width / 2))
        anchor("d", (rel: (0, 0.3), to: "d_int"))
        anchor("s", (rel: (0, -0.3), to: "s_int"))

        wire("d_int", "d")
        wire("s_int", "s")

        set-style(stroke: style.stroke)

        wire("d_int", (rel: (0, 0)), (rel: (-height, 0)))
        wire("s_int", (rel: (0, 0)), (rel: (-height, 0)))
        anchor("gl", (rel: (-3 * height / 4, width / 2), to: center))

        wire((rel: (0, -width / 2)), (rel: (-height / 2, 0)))

        anchor("g", (rel: (-height / 2, -width / 2)))

        wire("gl", (rel: (0, -width / 2)), (rel: (0, -width / 2)))

        if channel == "p" {
            circle((-height - 0.28, 0), radius: 0.1, fill: style.fill)
        }

        wire((-height, width / 2), (-height, -width / 2))
    }
    component("mosfet", name, node, draw: draw, ..params)
}

/// Simple P-channel MOSFET with inversion circle.
/// - name (string): Unique identifier.
/// - node (coordinate): Position.
/// *Anchors:* `g` (Gate), `d` (Drain), `s` (Source).
#let pmos_simple(name, node, ..params) = mosfet_simple(name, node, channel: "p", ..params)

/// Simple N-channel MOSFET.
/// - name (string): Unique identifier.
/// - node (coordinate): Position.
/// *Anchors:* `g` (Gate), `d` (Drain), `s` (Source)
#let nmos_simple(name, node, ..params) = mosfet_simple(name, node, channel: "n", ..params)
