// Export dependencies
#import "dependencies.typ": cetz
#import cetz: draw

// Export circuit
#import "circuit.typ": circuit

// Export utils
#import "utils.typ": set-style

// Export styles
#import "styles.typ"

// Export core
#import "component.typ": component, interface

// Export components
#import "components/antenna.typ": antenna
#import "components/transformer.typ": transformer
#import "components/stub.typ": estub, nstub, sstub, stub, wstub
#import "components/wire.typ": swire, wire, zwire
#import "components/circulator.typ": circulator
#import "components/node.typ": node
#import "components/capacitor.typ": capacitor, pcapacitor
#import "components/diode.typ": diode, led, photodiode, schottky, tunnel, zener
#import "components/switch.typ": switch
#import "components/fuse.typ": afuse, fuse
#import "components/supply.typ": earth, frame, ground, vcc, vee
#import "components/inductor.typ": inductor
#import "components/logic.typ": land, lnand, lnor, lnot, lor, lxnor, lxor, aand, anand, anor, anot, aor, axor, axnor, abuffer, alogic
#import "components/resistor.typ": heater, potentiometer, resistor, rheostat
#import "components/source.typ": acvsource, disource, dvsource, isource, vsource
#import "components/motor.typ": acmotor, dcmotor
#import "components/transistors/bjt.typ": bjt, npn, pnp
#import "components/transistors/mosfet.typ": mosfet, nmos, nmosd, pmos, pmosd
#import "components/integrated/opamp.typ": opamp
#import "components/integrated/mcu.typ": mcu
#import "components/integrated/converter.typ": adc, dac
#import "components/instruments/round-meter.typ": ammeter, ohmmeter, round-meter, voltmeter, wattmeter
#import "components/button.typ": button, ncbutton, ncibutton, nobutton, noibutton
#import "components/integrated/flipflop.typ": dflipflop, flipflop, jkflipflop, srlatch

//new
#import "components/transistors/simple.typ": nmos_simple, pmos_simple, mosfet_simple
#import "components/integrated/multiplexer.typ": mux, mux2, mux4, mux8, dmux, dmux2, dmux4, dmux8
#import "components/integrated/decoder.typ": decoder, dec1to2, dec2to4, dec3to8
#import "components/integrated/flipflop_top.typ": flipflop_top, dflipflop_top, dlatch_top, dff_enable, dff_reset, dff_enable_inv, dff_reset_inv
#import "components/integrated/register.typ": register, reg2bit, reg3bit, reg4bit, reg5bit, reg6bit, reg7bit, reg8bit
#import "components/integrated/adder.typ": full_adder, half_adder
#import "components/integrated/zero_extend.typ": zero_extend, sign_extend
#import "components/integrated/shifter.typ": shifter, shiftla, shiftll, shiftra, shiftrl

