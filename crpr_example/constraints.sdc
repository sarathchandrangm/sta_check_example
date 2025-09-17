
#creating a virtual clock
create_clock -name VIRTUAL_CLK -period 10

#creating input clock
create_clock -name CLK -period 10 -waveform {0 5} [get_ports clk]
set_clock_latency -source  -clock CLK 1.5 [get_ports clk]

# create_generated_clock -name CLK_G -source [get_ports clk] -multiply_by 1 [get_ports clk_g]
# set_clock_latency -source -clock CLK_G 1.5 [get_ports clk_g]
# set_propagated_clock [get_clocks CLK_G]
set_propagated_clock [get_clocks CLK]

# set_multicycle_path -setup 2 -from [get_pins _3_/CK] -to [get_pins _2_/D] -start
# set_multicycle_path -hold 1 -from [get_pins _3_/CK] -to [get_pins _2_/D] -start

# set_clock_latency -source -clock CLK 1.2 [get_ports clk]
set_clock_transition -rise 0.1 [get_clocks CLK]
set_clock_transition -fall 0.1  [get_clocks CLK]


#defining input delay
foreach myport [get_ports -filter direction==input] {
    if {[get_property $myport direction] == "input" && [get_name $myport] != "clk"} {
        puts "Setting input delay for port: [get_name $myport]"
        set_input_delay -clock CLK  2 -max -rise [get_ports $myport]
        set_input_delay -clock CLK  2.5 -max -fall [get_ports $myport]
        set_input_delay -clock CLK  0.5 -min -rise [get_ports $myport]
        set_input_delay -clock CLK  0.1 -min -fall [get_ports $myport]
        set_input_transition 0.1 -min -rise [get_ports $myport]
        set_input_transition 0.05 -min -fall [get_ports $myport]
        set_input_transition  0.8 -max -rise [get_ports $myport]
        set_input_transition 0.6 -max -fall [get_ports $myport]
    } else {
        puts "-U- Skipping non-input port: [get_name $myport]"
    }  
}

#defining output delay
set_output_delay -clock CLK 1.5 -max -rise [get_ports q1]
set_output_delay -clock CLK 1.8 -max -fall [get_ports q1]
set_output_delay -clock CLK 0.2 -min -rise [get_ports q1]
set_output_delay -clock CLK 0.5 -min -fall [get_ports q1]

set_output_delay -clock CLK 1.5 -max -rise [get_ports out1]
set_output_delay -clock CLK 1.8 -max -fall [get_ports out1]
set_output_delay -clock CLK 0.2 -min -rise [get_ports out1]
set_output_delay -clock CLK 0.5 -min -fall [get_ports out1]


#sets the setup time for a path
set_assigned_check -setup 0.5 -from _2_/CK -to _2_/D
set_assigned_check -hold 0.2 -from _2_/CK -to _2_/D
set_assigned_check -setup 0.5 -from _3_/CK -to _3_/D

set_timing_derate -early 0.9
set_timing_derate -late 1.1

# set_disable_timing -from [get_ports _5_/A2] -to [get_ports _5_/ZN] _5_

# set_max_delay -from [get_ports d] -to [get_ports q1] 6

#to get the timing path
# get_full_name [get_timing_edges -from _3_/Q -to _2_/D]
# get_property [get_timing_edges -from _3_/Q -to _2_/D] delay_max_fall

#Done to see the delay using pathview GUI
report_checks -path_delay min_max -format full_clock_expanded -fields {slew cap input_pins nets fanout}  -endpoint_count 10 -unique_paths_to_endpoint -digits 4 > ./sta_report.rpt

#to know about the limits of the design
report_check_type

