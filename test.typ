
#import "src/lib.typ": *

#circuit(debug: false, {
  pmos_simple("t1", (1, 0))
  nmos_simple("t2", (0, 2))
  swire("t1.g", "t2.g")
  swire("t1.d", "t2.s")

  anand("l1", (9, 0))
  abuffer("l3", (8, -2))
  axnor("l4", (10, -4))
  alogic("l5", (12, 0),type: "xnor", inputs: 3)
  reg4bit("ff",(2,-10))

  zwire("l1.out", "l5.in1")
  zwire("l3.out", "l5.in2")
  zwire(bits: "2","l4.out", "l5.in3")
  
  full_adder("dec", (5,-15), description: true)
  dmux4("mux", (2, -10))
  shiftll("ze", (5,0))
  wire("l1.in1", "ze.out", bits: "41")

  swire(bits: "N", "mux.out11","dec.a")
 


 
})

