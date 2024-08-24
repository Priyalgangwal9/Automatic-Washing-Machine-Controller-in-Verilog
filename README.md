# Automatic-Washing-Machine-Controller-in-Verilog
Verilog-based automatic washing machine controller simulating door check, water fill, detergent addition, washing, draining, and spinning using a finite state machine.

# Installation
Install Icarus Verilog and GTKWave on the system.

# Compile the Verilog files:
iverilog -o new_test.vvp new_test.v automatic_washing_machine.v
# Run the simulation:  
vvp new_test.vvp
# Open the waveform in GTKWave:
gtkwave new_test.vcd
