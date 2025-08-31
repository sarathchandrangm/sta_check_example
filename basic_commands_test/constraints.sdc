
#creating a virtual clock
create_clock -name VIRTUAL_CLK -period 10

#creating input clock
create_clock -name CLK -period 10 -waveform {0 5} [get_ports clk]
set_clock_latency -clock CLK 1.5 [get_ports clk]
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
set_assigned_check -hold 0.2 -from _5_/CK -to _5_/D
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

proc prin_pin_info {pin} {
    puts "Pin: [get_full_name $pin]"
    puts "Direction: [get_property $pin direction]"
    puts "Slack Max: [get_property $pin slack_max]"
    puts "Slack Min: [get_property $pin slack_min]"
    puts "Slew Max: [get_property $pin slew_max]"
    puts "Slew Min: [get_property $pin slew_min]"
}

proc analyze_pin {pin} {
    prin_pin_info $pin
    puts "Fanin pins:"
    print_list [get_fanin -to $pin]
    puts "Fanout pins:"
    print_list [get_fanout -from $pin]
}

proc list_points { start end } {
    set points_list [get_property [find_timing_path -from $start -to $end] points]
    set slack [get_property [find_timing_path -from $start -to $end] slack]
    puts "Total Points: [llength $points_list] Slack: $slack"
    set point_count 1
    foreach point $points_list {
        puts "Point $point_count: [get_full_name [get_property $point pin]]"
        # prin_pin_info [get_property $point pin]
        puts "Arrival : [get_property $point arrival] Slack: [get_property $point slack] "
        incr point_count
    }
}


proc expand_timing_edges { inst_obj } {
    set edges [get_timing_edges -of_objects $inst_obj]
    set count 1
    foreach timing_arc [lindex $edges 0] {
        puts "$count.Name: [get_full_name $timing_arc]"
        # puts "From: [get_full_name [get_property $timing_arc from_pin]] To: [get_full_name [get_property $timing_arc to_pin]]"
        puts "Delay Max Rise: [get_property $timing_arc delay_max_rise]"
        puts "Delay Max fall: [get_property $timing_arc delay_max_fall]"
        puts "Delay Min Rise: [get_property $timing_arc delay_min_rise]"
        puts "Delay Min fall: [get_property $timing_arc delay_min_fall]"
        puts "Sense : [get_property $timing_arc sense]"
        puts "-----------------------------"
        incr count
    }
}