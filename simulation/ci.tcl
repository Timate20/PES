if {[catch {

    # TODO: Could use list of lists to allow additional per-file compile flags
    proc compile_vhdl {sources flags} {
        foreach {source} $sources {
            vcom -2008 $source {*}$flags
        }
    }

    proc prepend_directory {dir sources} {
        set result {}
        foreach {entry} $sources {
            lappend result "${dir}/${entry}"
        }
        return $result
    }
	
	set dir [pwd]
	echo "Starting to run ModelSim simulation in ${dir}" 
	
	file mkdir "_run"
	transcript file "_run/transcript.txt"
	transcript on
	
	set lib _run/work

	###
	### create libraries
	###

	vlib $lib
	vmap work $lib
	
	echo "Compiling sources..."
	source ../simulation/sources.tcl
	
	echo "Starting simulation of ${SIM_TOP_LEVEL}..."
    vsim $SIM_TOP_LEVEL
	echo "Running ${SIM_TOP_LEVEL} for ${SIM_TIME}"
    run $SIM_TIME

    # Propagate exit code
    if {[runStatus] == "ready"} {
		echo "Testbench ${SIM_TOP_LEVEL} was simulated successfully!"
        exit
    } else {
		echo "Error while running testbench ${SIM_TOP_LEVEL}!"
        exit -code 30
    }
}]} {
    exit -code 30
}
exit
