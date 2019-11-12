# Begin_DVE_Session_Save_Info
# DVE reload session
# Saved on Tue Nov 12 09:06:35 2019
# Designs open: 1
#   V1: /home/cc/eecs151/fa19/class/eecs151-abl/Desktop/fa19_team14/hardware/sim/bios_testbench.vpd
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Source.1: bios_testbench
#   Memory.1: bios_testbench.CPU.recv_fifo.fifo[31:0]
#   Memory.2: bios_testbench.CPU.trmt_fifo.fifo[31:0]
#   Wave.1: 37 signals
#   Group count = 2
#   Group off_chip_uart signal count = 20
# End_DVE_Session_Save_Info

# DVE version: G-2012.09
# DVE build date: Aug 24 2012 00:30:46


#<Session mode="Reload" path="/home/cc/eecs151/fa19/class/eecs151-abl/Desktop/fa19_team14/hardware/DVEfiles/session.tcl" type="Debug">

gui_set_loading_session_type Reload
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all
gui_clear_window -type Wave
gui_clear_window -type List

# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE Topleve session: 


# Create and position top-level windows :TopLevel.1

set TopLevel.1 TopLevel.1

# Docked window settings
set HSPane.1 HSPane.1
set Hier.1 Hier.1
set DLPane.1 DLPane.1
set Data.1 Data.1
set Console.1 Console.1
gui_sync_global -id ${TopLevel.1} -option true

# MDI window settings
set Source.1 Source.1
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}
set Memory.1 Memory.1
gui_update_layout -id ${Memory.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}
set Memory.2 Memory.2
gui_update_layout -id ${Memory.2} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}

# End MDI window settings


# Create and position top-level windows :TopLevel.2

set TopLevel.2 TopLevel.2

# Docked window settings
gui_sync_global -id ${TopLevel.2} -option true

# MDI window settings
set Wave.1 Wave.1
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 556} {child_wave_right 1358} {child_wave_colname 356} {child_wave_colvalue 196} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings


#</WindowLayout>

#<Database>

# DVE Open design session: 

if { ![gui_is_db_opened -db {/home/cc/eecs151/fa19/class/eecs151-abl/Desktop/fa19_team14/hardware/sim/bios_testbench.vpd}] } {
	gui_open_db -design V1 -file /home/cc/eecs151/fa19/class/eecs151-abl/Desktop/fa19_team14/hardware/sim/bios_testbench.vpd -nosource
}
gui_set_precision 10ps
gui_set_time_units 10ps
#</Database>

# DVE Global setting session: 


# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups
gui_load_child_values {bios_testbench.off_chip_uart}
gui_load_child_values {bios_testbench.CPU.on_chip_uart.uatransmit}


set _session_group_5 off_chip_uart
gui_sg_create "$_session_group_5"
set off_chip_uart "$_session_group_5"

gui_sg_addsignal -group "$_session_group_5" { bios_testbench.off_chip_uart.clk bios_testbench.off_chip_uart.reset bios_testbench.off_chip_uart.data_in bios_testbench.off_chip_uart.data_in_valid bios_testbench.off_chip_uart.data_in_ready bios_testbench.off_chip_uart.data_out bios_testbench.off_chip_uart.data_out_valid bios_testbench.off_chip_uart.data_out_ready bios_testbench.off_chip_uart.serial_in bios_testbench.off_chip_uart.serial_out bios_testbench.off_chip_uart.serial_in_reg bios_testbench.off_chip_uart.serial_out_reg bios_testbench.off_chip_uart.serial_out_tx bios_testbench.off_chip_uart.CLOCK_FREQ bios_testbench.off_chip_uart.BAUD_RATE bios_testbench.CPU.trmt_fifo.wr_addr bios_testbench.CPU.trmt_fifo.rd_addr bios_testbench.CPU.trmt_fifo.full bios_testbench.CPU.trmt_fifo.empty }
gui_set_radix -radix {decimal} -signals {V1:bios_testbench.off_chip_uart.CLOCK_FREQ}
gui_set_radix -radix {twosComplement} -signals {V1:bios_testbench.off_chip_uart.CLOCK_FREQ}
gui_set_radix -radix {decimal} -signals {V1:bios_testbench.off_chip_uart.BAUD_RATE}
gui_set_radix -radix {twosComplement} -signals {V1:bios_testbench.off_chip_uart.BAUD_RATE}

set _session_group_6 $_session_group_5|
append _session_group_6 uatransmit
gui_sg_create "$_session_group_6"
set off_chip_uart|uatransmit "$_session_group_6"

gui_sg_addsignal -group "$_session_group_6" { bios_testbench.CPU.on_chip_uart.uatransmit.clk bios_testbench.CPU.on_chip_uart.uatransmit.reset bios_testbench.CPU.on_chip_uart.uatransmit.data_in bios_testbench.CPU.on_chip_uart.uatransmit.data_in_valid bios_testbench.CPU.on_chip_uart.uatransmit.data_in_ready bios_testbench.CPU.on_chip_uart.uatransmit.serial_out bios_testbench.CPU.on_chip_uart.uatransmit.tx_shift bios_testbench.CPU.on_chip_uart.uatransmit.bit_counter bios_testbench.CPU.on_chip_uart.uatransmit.clock_counter bios_testbench.CPU.on_chip_uart.uatransmit.state bios_testbench.CPU.on_chip_uart.uatransmit.next_state bios_testbench.CPU.on_chip_uart.uatransmit.CLOCK_FREQ bios_testbench.CPU.on_chip_uart.uatransmit.BAUD_RATE bios_testbench.CPU.on_chip_uart.uatransmit.SYMBOL_EDGE_TIME bios_testbench.CPU.on_chip_uart.uatransmit.CLOCK_COUNTER_WIDTH bios_testbench.CPU.on_chip_uart.uatransmit.IDLE bios_testbench.CPU.on_chip_uart.uatransmit.LATCH bios_testbench.CPU.on_chip_uart.uatransmit.SENDING }
gui_set_radix -radix {decimal} -signals {V1:bios_testbench.CPU.on_chip_uart.uatransmit.CLOCK_FREQ}
gui_set_radix -radix {twosComplement} -signals {V1:bios_testbench.CPU.on_chip_uart.uatransmit.CLOCK_FREQ}
gui_set_radix -radix {decimal} -signals {V1:bios_testbench.CPU.on_chip_uart.uatransmit.BAUD_RATE}
gui_set_radix -radix {twosComplement} -signals {V1:bios_testbench.CPU.on_chip_uart.uatransmit.BAUD_RATE}
gui_set_radix -radix {decimal} -signals {V1:bios_testbench.CPU.on_chip_uart.uatransmit.SYMBOL_EDGE_TIME}
gui_set_radix -radix {twosComplement} -signals {V1:bios_testbench.CPU.on_chip_uart.uatransmit.SYMBOL_EDGE_TIME}
gui_set_radix -radix {decimal} -signals {V1:bios_testbench.CPU.on_chip_uart.uatransmit.CLOCK_COUNTER_WIDTH}
gui_set_radix -radix {twosComplement} -signals {V1:bios_testbench.CPU.on_chip_uart.uatransmit.CLOCK_COUNTER_WIDTH}
gui_set_radix -radix {decimal} -signals {V1:bios_testbench.CPU.on_chip_uart.uatransmit.IDLE}
gui_set_radix -radix {unsigned} -signals {V1:bios_testbench.CPU.on_chip_uart.uatransmit.IDLE}
gui_set_radix -radix {decimal} -signals {V1:bios_testbench.CPU.on_chip_uart.uatransmit.LATCH}
gui_set_radix -radix {unsigned} -signals {V1:bios_testbench.CPU.on_chip_uart.uatransmit.LATCH}
gui_set_radix -radix {decimal} -signals {V1:bios_testbench.CPU.on_chip_uart.uatransmit.SENDING}
gui_set_radix -radix {unsigned} -signals {V1:bios_testbench.CPU.on_chip_uart.uatransmit.SENDING}

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 59471479



# Save global setting...

# Wave/List view global setting
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# Hier 'Hier.1'
gui_show_window -window ${Hier.1}
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {UnnamedProcess 1} {Function 1} {Block 1} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {PowSwitch 0} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {IsoCell 0} {ClassDef 1} }
gui_list_set_filter -id ${Hier.1} -text {*} -force
gui_change_design -id ${Hier.1} -design V1
catch {gui_list_expand -id ${Hier.1} bios_testbench}
catch {gui_list_expand -id ${Hier.1} bios_testbench.CPU}
catch {gui_list_expand -id ${Hier.1} bios_testbench.CPU.on_chip_uart}
catch {gui_list_select -id ${Hier.1} {bios_testbench.CPU.on_chip_uart.uatransmit}}
gui_view_scroll -id ${Hier.1} -vertical -set 5
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {LowPower 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {bios_testbench.CPU.on_chip_uart.uatransmit}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 5
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active bios_testbench /home/cc/eecs151/fa19/class/eecs151-abl/Desktop/fa19_team14/hardware/sim/bios_testbench.v
gui_view_scroll -id ${Source.1} -vertical -set 0
gui_src_set_reusable -id ${Source.1}

# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_wv_zoom_timerange -id ${Wave.1} 0 135558498
gui_list_add_group -id ${Wave.1} -after {New Group} {off_chip_uart}
gui_list_add_group -id ${Wave.1}  -after off_chip_uart {off_chip_uart|uatransmit}
gui_list_select -id ${Wave.1} {bios_testbench.CPU.trmt_fifo.rd_addr }
gui_seek_criteria -id ${Wave.1} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.1}
gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group off_chip_uart  -position in

gui_marker_move -id ${Wave.1} {C1} 59471479
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false

# View 'Memory.1'
gui_show_memory -window ${Memory.1} -memory {bios_testbench.CPU.recv_fifo.fifo[31:0][7:0]}
gui_set_memory_properties -window ${Memory.1} -columns 1 -address_factor -1 -address_offset 31 -start_address 31 -end_address 0 -address_radix 10
gui_set_radix -radix {hex} -signals {{bios_testbench.CPU.recv_fifo.fifo[31:0][7:0]}}
gui_set_radix -radix {unsigned} -signals {{bios_testbench.CPU.recv_fifo.fifo[31:0][7:0]}}
gui_view_scroll -id ${Memory.1} -vertical -set 0
gui_view_scroll -id ${Memory.1} -horizontal -set 0

# View 'Memory.2'
gui_show_memory -window ${Memory.2} -memory {bios_testbench.CPU.trmt_fifo.fifo[31:0][7:0]}
gui_set_memory_properties -window ${Memory.2} -columns 1 -address_factor -1 -address_offset 31 -start_address 31 -end_address 0 -address_radix 10
gui_set_radix -radix {hex} -signals {{bios_testbench.CPU.trmt_fifo.fifo[31:0][7:0]}}
gui_set_radix -radix {unsigned} -signals {{bios_testbench.CPU.trmt_fifo.fifo[31:0][7:0]}}
gui_view_scroll -id ${Memory.2} -vertical -set 0
gui_view_scroll -id ${Memory.2} -horizontal -set 0
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${Memory.2}
	gui_set_active_window -window ${HSPane.1}
}
if {[gui_exist_window -window ${TopLevel.2}]} {
	gui_set_active_window -window ${TopLevel.2}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

