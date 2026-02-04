#import "/tests/utils.typ": test
#import "../lib.typ"
#import "../dependencies.typ": cetz

// Test CeTZ components styling
#test({
    import lib: *
    set-style(rect: (stroke: 1pt + red))

    draw.rect((0, 0), (3, 3))
})
