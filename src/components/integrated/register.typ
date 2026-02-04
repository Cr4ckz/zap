#import "../../component.typ": component, interface
#import "../../dependencies.typ": cetz
#import "../../mini.typ": clock-wedge
#import cetz.draw: anchor, content, line, polygon, rect, scope, translate

#let register(name, node, bits: 2, ..params) = {
    let draw(ctx, position, style) = {
        let w = style.width * 0.8
        // Höhe passt sich der Bit-Anzahl an
        let h = style.height * (2.0 + bits * 0.6) 
        let gap = style.spacing * 3
        
        interface((-w / 2, -h / 2), (w / 2, h / 2))

        // 1. Statische Anker (Takt & Reset)
        anchor("clk", (0, h/2))
        anchor("rst", (0, -h / 2))
        
        // 2. Gehäuse
        rect((-w / 2, -h / 2), (w / 2, h / 2), fill: style.fill, stroke: style.stroke)

        for i in range(bits) {
            let idx = bits - 1 - i

            let y_pos = (bits - 1) * gap / 2 - i * gap - 0.2
            

            let in_name = "s" + str(idx) + "_in"
            let out_name = "s" + str(idx) + "_out"
            
            anchor(in_name, (-w / 2, y_pos))
            anchor(out_name, (w / 2, y_pos))
            
            content((-w / 2, y_pos), $S'_#idx$, anchor: "west", padding: style.padding)
            content((w / 2, y_pos), $S_#idx$, anchor: "east", padding: style.padding)
        }

        content((0, h / 2), [#cetz.canvas({ clock-wedge() })], anchor: "west", angle: -90deg)
        content((0, h / 2 - 0.1), [CLK], anchor: "north", padding: style.padding)
        
        if "rst" != "" {
            content((0, -h / 2), [Reset], anchor: "south", padding: style.padding)
        }
    }

    component("register", name, node, draw: draw, ..params)
}

#let reg2bit(name, node, ..params) = register(name, node, bits: 2, ..params)
#let reg3bit(name, node, ..params) = register(name, node, bits: 3, ..params)
#let reg4bit(name, node, ..params) = register(name, node, bits: 4, ..params)
#let reg5bit(name, node, ..params) = register(name, node, bits: 5, ..params)
#let reg6bit(name, node, ..params) = register(name, node, bits: 6, ..params)
#let reg7bit(name, node, ..params) = register(name, node, bits: 7, ..params)
#let reg8bit(name, node, ..params) = register(name, node, bits: 8, ..params)