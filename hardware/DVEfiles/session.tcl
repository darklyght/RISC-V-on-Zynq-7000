# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Tue Nov 12 09:49:05 2019
# Designs open: 1
#   V1: /home/cc/eecs151/fa19/class/eecs151-abl/Desktop/fa19_team14/hardware/sim/bios_testbench.vpd
# Toplevel windows open: 1
# 	TopLevel.1
#   Source.1: bios_testbench
#   Memory.1: bios_testbench.CPU.recv_fifo.fifo[31:0]
#   Memory.2: bios_testbench.CPU.trmt_fifo.fifo[31:0]
#   Group count = 2
#   Group off_chip_uart signal count = 20
# End_DVE_Session_Save_Info

# DVE version: G-2012.09
# DVE build date: Aug 24 2012 00:30:46


#<Session mode="Full" path="/home/cc/eecs151/fa19/class/eecs151-abl/Desktop/fa19_team14/hardware/DVEfiles/session.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE Topleve session: 


# Create and position top-level windows :TopLevel.1

if {![gui_exist_window -window TopLevel.1]} {
    set TopLevel.1 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.1 TopLevel.1
}
gui_show_window -window ${TopLevel.1} -show_state normal -rect {{23 111} {739 817}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_set_toolbar_attributes -toolbar {&File} -dock_state top
gui_set_toolbar_attributes -toolbar {&File} -offset 0
gui_show_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_set_toolbar_attributes -toolbar {BackTrace} -dock_state top
gui_set_toolbar_attributes -toolbar {BackTrace} -offset 0
gui_show_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {Testbench} -dock_state top
gui_set_toolbar_attributes -toolbar {Testbench} -offset 0
gui_show_toolbar -toolbar {Testbench}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}

# End ToolBar settings

# Docked window settings
set HSPane.1 [gui_create_window -type HSPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 173]
catch { set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier] }
gui_set_window_pref_key -window ${HSPane.1} -key dock_width -value_type integer -value 173
gui_set_window_pref_key -window ${HSPane.1} -key dock_height -value_type integer -value -1
gui_set_window_pref_key -window ${HSPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 172} {height 382} {dock_state left} {dock_on_new_line true} {child_hier_colhier 140} {child_hier_coltype 100} {child_hier_colpd 0} {child_hier_col1 0} {child_hier_col2 1} {child_hier_col3 -1}}
set DLPane.1 [gui_create_window -type DLPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 173]
catch { set Data.1 [gui_share_window -id ${DLPane.1} -type Data] }
gui_set_window_pref_key -window ${DLPane.1} -key dock_width -value_type integer -value 173
gui_set_window_pref_key -window ${DLPane.1} -key dock_height -value_type integer -value 387
gui_set_window_pref_key -window ${DLPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DLPane.1} {{left 0} {top 0} {width 172} {height 382} {dock_state left} {dock_on_new_line true} {child_data_colvariable 140} {child_data_colvalue 100} {child_data_coltype 40} {child_data_col1 0} {child_data_col2 1} {child_data_col3 2}}
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 178]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value 717
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 178
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 716} {height 177} {dock_state bottom} {dock_on_new_line true}}
#### Start - Readjusting docked view's offset / size
set dockAreaList { top left right bottom }
foreach dockArea $dockAreaList {
  set viewList [gui_ekki_get_window_ids -active_parent -dock_area $dockArea]
  foreach view $viewList {
      if {[lsearch -exact [gui_get_window_pref_keys -window $view] dock_width] != -1} {
        set dockWidth [gui_get_window_pref_value -window $view -key dock_width]
        set dockHeight [gui_get_window_pref_value -window $view -key dock_height]
        set offset [gui_get_window_pref_value -window $view -key dock_offset]
        if { [string equal "top" $dockArea] || [string equal "bottom" $dockArea]} {
          gui_set_window_attributes -window $view -dock_offset $offset -width $dockWidth
        } else {
          gui_set_window_attributes -window $view -dock_offset $offset -height $dockHeight
        }
      }
  }
}
#### End - Readjusting docked view's offset / size
gui_sync_global -id ${TopLevel.1} -option true

# MDI window settings
set Source.1 [gui_create_window -type {Source}  -parent ${TopLevel.1}]
gui_show_window -window ${Source.1} -show_state maximized
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}
set Memory.1 [gui_create_window -type {Memory}  -parent ${TopLevel.1}]
gui_show_window -window ${Memory.1} -show_state maximized
gui_update_layout -id ${Memory.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}
set Memory.2 [gui_create_window -type {Memory}  -parent ${TopLevel.1}]
gui_show_window -window ${Memory.2} -show_state maximized
gui_update_layout -id ${Memory.2} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.1}

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


set _session_group_7 off_chip_uart
gui_sg_create "$_session_group_7"
set off_chip_uart "$_session_group_7"

gui_sg_addsignal -group "$_session_group_7" { bios_testbench.off_chip_uart.clk bios_testbench.off_chip_uart.reset bios_testbench.off_chip_uart.data_in bios_testbench.off_chip_uart.data_in_valid bios_testbench.off_chip_uart.data_in_ready bios_testbench.off_chip_uart.data_out bios_testbench.off_chip_uart.data_out_valid bios_testbench.off_chip_uart.data_out_ready bios_testbench.off_chip_uart.serial_in bios_testbench.off_chip_uart.serial_out bios_testbench.off_chip_uart.serial_in_reg bios_testbench.off_chip_uart.serial_out_reg bios_testbench.off_chip_uart.serial_out_tx bios_testbench.off_chip_uart.CLOCK_FREQ bios_testbench.off_chip_uart.BAUD_RATE bios_testbench.CPU.trmt_fifo.wr_addr bios_testbench.CPU.trmt_fifo.rd_addr bios_testbench.CPU.trmt_fifo.full bios_testbench.CPU.trmt_fifo.empty }
gui_set_radix -radix {decimal} -signals {V1:bios_testbench.off_chip_uart.CLOCK_FREQ}
gui_set_radix -radix {twosComplement} -signals {V1:bios_testbench.off_chip_uart.CLOCK_FREQ}
gui_set_radix -radix {decimal} -signals {V1:bios_testbench.off_chip_uart.BAUD_RATE}
gui_set_radix -radix {twosComplement} -signals {V1:bios_testbench.off_chip_uart.BAUD_RATE}

set _session_group_8 $_session_group_7|
append _session_group_8 uatransmit
gui_sg_create "$_session_group_8"
set off_chip_uart|uatransmit "$_session_group_8"

gui_sg_addsignal -group "$_session_group_8" { bios_testbench.CPU.on_chip_uart.uatransmit.clk bios_testbench.CPU.on_chip_uart.uatransmit.reset bios_testbench.CPU.on_chip_uart.uatransmit.data_in bios_testbench.CPU.on_chip_uart.uatransmit.data_in_valid bios_testbench.CPU.on_chip_uart.uatransmit.data_in_ready bios_testbench.CPU.on_chip_uart.uatransmit.serial_out bios_testbench.CPU.on_chip_uart.uatransmit.tx_shift bios_testbench.CPU.on_chip_uart.uatransmit.bit_counter bios_testbench.CPU.on_chip_uart.uatransmit.clock_counter bios_testbench.CPU.on_chip_uart.uatransmit.state bios_testbench.CPU.on_chip_uart.uatransmit.next_state bios_testbench.CPU.on_chip_uart.uatransmit.CLOCK_FREQ bios_testbench.CPU.on_chip_uart.uatransmit.BAUD_RATE bios_testbench.CPU.on_chip_uart.uatransmit.SYMBOL_EDGE_TIME bios_testbench.CPU.on_chip_uart.uatransmit.CLOCK_COUNTER_WIDTH bios_testbench.CPU.on_chip_uart.uatransmit.IDLE bios_testbench.CPU.on_chip_uart.uatransmit.LATCH bios_testbench.CPU.on_chip_uart.uatransmit.SENDING }
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
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
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
#</Session>

