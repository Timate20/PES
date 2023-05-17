###
###
###

file mkdir "_run"
transcript file "_run/transcript.txt"
transcript on

###
###
###

set lib _run/work

###
### create libraries
###

vlib $lib
vmap work $lib

source sources.tcl

# initialize and run simulation
vsim $SIM_TOP_LEVEL
source wave.do
run $SIM_TIME