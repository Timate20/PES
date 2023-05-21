onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /div16_tb/uut/clk
add wave -noupdate /div16_tb/uut/en
add wave -noupdate /div16_tb/uut/rstn
add wave -noupdate /div16_tb/uut/a
add wave -noupdate /div16_tb/uut/b
add wave -noupdate /div16_tb/uut/result
add wave -noupdate /div16_tb/uut/r_remainder
add wave -noupdate -expand /div16_tb/uut/r_shifted_b
add wave -noupdate -expand /div16_tb/uut/r_result
add wave -noupdate -expand /div16_tb/uut/r_en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {116 ns} {239 ns}
