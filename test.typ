
#import "src/lib.typ": *

#circuit(debug: false, {
  pmos_simple("t1", (1, 0))
  nmos_simple("t2", (0, 2))
  swire("t1.g", "t2.g")
  swire("t1.d", "t2.s")

  anand("l1", (9, 0))
  //anor("l2", (12, 0))
  abuffer("l3", (8, -2))
  axnor("l4", (10, -4))
  alogic("l5", (12, 0),type: "xnor", inputs: 3)
  reg8bit("ff",(2,-10))

  zwire("l1.out", "l5.in1")
  zwire("l3.out", "l5.in2")
  zwire("l4.out", "l5.in3")
  
  decoder4("dec", (5,5))
  mux8("mux", (5, -10))
  swire("t1.d", "ff.clk")
 


 
})

