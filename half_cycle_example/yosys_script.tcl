#read modules from verilog
read_verilog /home/gmsarath/Sarath/vlsi_wrk/sta_exercise/sta_check_examples/half_cycle_example/my_ckt.v

#elaborate design heirarchy
hierarchy -check -top my_ckt

#translate processes to netlist
proc

#mapping to internal cell library
techmap

#mapping sequential ff
dfflibmap -liberty /home/gmsarath/Sarath/vlsi_wrk/OpenROAD/test/Nangate45/Nangate45_typ.lib

#mapping logic gates
abc -liberty /home/gmsarath/Sarath/vlsi_wrk/OpenROAD/test/Nangate45/Nangate45_typ.lib

#remove unused cells and wires
clean

#write the current design to a verilog file 
write_verilog -noattr my_ckt_synthesized.v
