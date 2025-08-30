
#creating a virtual clock
create_clock -name VIRTUAL_CLK -period 10

#creating input clock
create_clock -name CLK -period 10 -waveform {0 5} [get_ports clk]
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
        set_input_transition  0.8 -min -rise [get_ports $myport]
        set_input_transition 0.6 -min -fall [get_ports $myport]
    } else {
        puts "Skipping non-input port: [get_name $myport]"
    }  
}

#defining output delay
set_output_delay -clock CLK 1.5 -max -rise [get_ports q1]
set_output_delay -clock CLK 1.8 -max -fall [get_ports q1]
set_output_delay -clock CLK 0.2 -min -rise [get_ports q1]
set_output_delay -clock CLK 0.5 -min -fall [get_ports q1]


#sets the setup time for a path
set_assigned_check -setup 0.5 -from _5_/CK -to _5_/D
set_assigned_check -setup 0.5 -from _6_/CK -to _6_/D

#to get the timing path
get_full_name [get_timing_edges -from _4_/ZN -to _5_/D]
get_property [get_timing_edges -from _4_/ZN -to _5_/D] delay_max_fall

#Done to see the delay using pathview GUI
report_checks -path_delay min_max -format full_clock_expanded -fields {slew cap input_pins nets fanout}  -endpoint_count 10 -unique_paths_to_endpoint -digits 4 > ./sta_report.rpt

#to know about the limits of the design
report_check_type



proc find_fanin {pin} {
    foreach fanin [get_fanin -to $pin] {
        puts "fanin: [get_full_name $fanin]"
    }
}

proc find_fanout {pin} {
    foreach fanin [get_fanout -from $pin] {
        puts "fanout: [get_full_name $fanin]"
    }
}

proc print_list {my_list} {
    foreach item $my_list {
        puts "Item: [get_full_name $item] [get_property $item sense]"
    }

}