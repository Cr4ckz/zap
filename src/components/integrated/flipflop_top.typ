#import "../../component.typ": component, interface
#import "../../dependencies.typ": cetz
#import "../../mini.typ": clock-wedge
#import cetz.draw: anchor, content, line, polygon, rect, scope, translate

#let flipflop_top(name, node, pins: (:), ..params) = {
    assert(params.pos().len() == 0, message: "flipflop_top supports only one node")
    assert(type(pins) == dictionary, message: "pins should be a dictionary")
    
    let draw(ctx, position, style) = {
        interface((-style.width / 2, -style.height / 2), (style.width / 2, style.height / 2))

        for i in range(1, 4) {
            anchor("pin" + str(i), (-style.width / 2, style.height / 2 - i * style.spacing))
        }
        for i in range(4, 7) {
            anchor("pin" + str(i), (style.width / 2, -style.height / 2 + (i - 3) * style.spacing))
        }

        anchor("pinup", (0, style.height / 2))
        anchor("pindown", (0, -style.height / 2))

        rect((-style.width / 2, -style.height / 2), (style.width / 2, style.height / 2), fill: style.fill, stroke: style.stroke)

        for pin_name in pins.keys() {
            let pin = pins.at(pin_name)
            let side = if pin_name in ("pin1", "pin2", "pin3") { "west" } 
                       else if pin_name == "pinup" { "north" } 
                       else if pin_name == "pindown" { "south" } 
                       else { "east" }

            content(pin_name, pin.at("content", default: ""), anchor: side, padding: style.padding)

            if pin.at("clock", default: false) {
                let (new_side, angle) = if side == "west" { ("west", 0deg) } 
                                       else if side == "east" { ("west", 180deg) } 
                                       else if side == "north" { ("west", -90deg) } 
                                       else { ("west", 90deg) }
                
                content(pin_name, [#cetz.canvas({ clock-wedge() })], anchor: new_side, angle: angle)
            }
        }
    }

    component("flipflop_top", name, node, draw: draw, ..params)
}

#let dlatch_top(name, node, ..params) = flipflop_top(
    name,
    node,
    ..params,
    pins: (
        pin1:  (content: "D"),
        pinup: (content: "CLK"),
        pin4:  (content: overline("Q")),
        pin6:  (content: "Q"),
    ),
)

#let dflipflop_top(name, node, ..params) = flipflop_top(
    name,
    node,
    ..params,
    pins: (
        pin1:  (content: "D"),
        pinup: (clock: true), 
        pin4:  (content: overline("Q")),
        pin6:  (content: "Q"),
    ),
)

#let dff_reset(name, node, ..params) = flipflop_top(
    name,
    node,
    ..params,
    pins: (
        pin1:    (content: "D"),
        pinup:   (clock: true),
        pindown: (content: "Reset"),
        pin4:    (content: overline("Q")),
        pin6:    (content: "Q"),
    ),
)

#let dff_reset_inv(name, node, ..params) = flipflop_top(
    name,
    node,
    ..params,
    pins: (
        pin1:    (content: "D"),
        pinup:   (clock: true),
        pindown: (content: overline("Reset")),
        pin4:    (content: overline("Q")),
        pin6:    (content: "Q"),
    ),
)

#let dff_enable(name, node, ..params) = flipflop_top(
    name,
    node,
    ..params,
    pins: (
        pin1:    (content: "D"),
        pinup:   (clock: true),
        pindown: (content: "Enable"),
        pin4:    (content: overline("Q")),
        pin6:    (content: "Q"),
    ),
)

#let dff_enable_inv(name, node, ..params) = flipflop_top(
    name,
    node,
    ..params,
    pins: (
        pin1:    (content: "D"),
        pinup:   (clock: true),
        pindown: (content: overline("Enable")),
        pin4:    (content: overline("Q")),
        pin6:    (content: "Q"),
    ),
)