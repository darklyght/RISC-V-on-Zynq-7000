gui_state_default_create -off -ini

# Globals
gui_set_state_value -category Globals -key recent_databases -value {{gui_open_db -file /home/cc/eecs151/fa19/class/eecs151-abl/Desktop/fa19_team14/hardware/sim/bios_testbench.vpd -design V1} {gui_open_db -file sim/bios_testbench.vpd}}

# Layout

# list_value_column

# Sim

# Assertion

# Stream

# Data

# TBGUI

# Driver

# Class

# Member

# ObjectBrowser

# UVM

# Local

# Backtrace

# Exclusion

# SaveSession

# FindDialog
gui_create_state_key -category FindDialog -key m_pMatchCase -value_type bool -value false
gui_create_state_key -category FindDialog -key m_pMatchWord -value_type bool -value false
gui_create_state_key -category FindDialog -key m_pUseCombo -value_type string -value {}
gui_create_state_key -category FindDialog -key m_pWrapAround -value_type bool -value true


gui_state_default_create -off
