
################################################################
# This is a generated script based on design: bram_des
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source bram_des_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg400-1
#    set_property BOARD_PART em.avnet.com:microzed_7020:part0:1.0 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name two_brams_test

# This script was generated for a remote BD.
# set str_bd_folder C:/Projects/ProjFromScratch/proj_dir/bd
set str_bd_filepath ${str_bd_folder}/${design_name}/${design_name}.bd

# Check if remote design exists on disk
if { [file exists $str_bd_filepath ] == 1 } {
   puts "ERROR: The remote BD file path <$str_bd_filepath> already exists!"
   return 1
}

# Check if design exists in memory
set list_existing_designs [get_bd_designs -quiet $design_name]
if { $list_existing_designs ne "" } {
   puts "ERROR: The design <$design_name> already exists in this project!"
   puts "ERROR: Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."

   return 1
}

# Check if design exists on disk within project
set list_existing_designs [get_files */${design_name}.bd]
if { $list_existing_designs ne "" } {
   puts "ERROR: The design <$design_name> already exists in this project at location:"
   puts "   $list_existing_designs"
   puts "ERROR: Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."

   return 1
}

# Now can create the remote BD
create_bd_design -dir $str_bd_folder $design_name
current_bd_design $design_name

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set addra_cm [ create_bd_port -dir I -from 31 -to 0 addra_cm ]
  set addra_sam [ create_bd_port -dir I -from 9 -to 0 addra_sam ]
  set addrb_cm [ create_bd_port -dir I -from 31 -to 0 addrb_cm ]
  set addrb_sam [ create_bd_port -dir I -from 9 -to 0 addrb_sam ]
  set clk_in [ create_bd_port -dir I clk_in ]
  set dina [ create_bd_port -dir I -from 31 -to 0 dina ]
  set doutb_cm [ create_bd_port -dir O -from 31 -to 0 doutb_cm ]
  set doutb_sam [ create_bd_port -dir O -from 31 -to 0 doutb_sam ]
  set ena [ create_bd_port -dir I ena ]
  set enb [ create_bd_port -dir I enb ]
  set rst_in [ create_bd_port -dir I rst_in ]
  set wea_cm [ create_bd_port -dir I -from 3 -to 0 wea_cm ]
  set wea_sam [ create_bd_port -dir I -from 0 -to 0 wea_sam ]

  # Create instance: bram_controller_mode, and set properties
  set bram_controller_mode [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 bram_controller_mode ]
  set_property -dict [ list CONFIG.Enable_32bit_Address {true} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Enable_Rate {100} CONFIG.Port_B_Write_Rate {50} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {false} CONFIG.Use_RSTA_Pin {true} CONFIG.Use_RSTB_Pin {true} CONFIG.Write_Depth_A {256} CONFIG.use_bram_block {BRAM_Controller}  ] $bram_controller_mode

  # Create instance: standalone_mode, and set properties
  set standalone_mode [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 standalone_mode ]
  set_property -dict [ list CONFIG.Byte_Size {9} CONFIG.Enable_32bit_Address {false} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Enable_Rate {100} CONFIG.Port_B_Write_Rate {50} CONFIG.Register_PortA_Output_of_Memory_Primitives {true} CONFIG.Register_PortB_Output_of_Memory_Primitives {true} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Use_RSTA_Pin {false} CONFIG.Use_RSTB_Pin {false} CONFIG.Write_Depth_A {1024} CONFIG.use_bram_block {Stand_Alone}  ] $standalone_mode

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list CONFIG.CONST_VAL {0} CONFIG.CONST_WIDTH {4}  ] $xlconstant_1

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list CONFIG.CONST_VAL {0} CONFIG.CONST_WIDTH {1}  ] $xlconstant_2

  # Create port connections
  connect_bd_net -net addr_sam_1 [get_bd_ports addra_sam] [get_bd_pins standalone_mode/addra]
  connect_bd_net -net addra_cm [get_bd_ports addra_cm] [get_bd_pins bram_controller_mode/addra]
  connect_bd_net -net addrb_1 [get_bd_ports addrb_cm] [get_bd_pins bram_controller_mode/addrb]
  connect_bd_net -net addrb_sam_1 [get_bd_ports addrb_sam] [get_bd_pins standalone_mode/addrb]
  connect_bd_net -net bram_controller_mode_doutb_1 [get_bd_ports doutb_cm] [get_bd_pins bram_controller_mode/doutb]
  connect_bd_net -net clk_in1 [get_bd_ports clk_in] [get_bd_pins bram_controller_mode/clka] [get_bd_pins bram_controller_mode/clkb] [get_bd_pins standalone_mode/clka] [get_bd_pins standalone_mode/clkb]
  connect_bd_net -net dina_1 [get_bd_ports dina] [get_bd_pins bram_controller_mode/dina] [get_bd_pins standalone_mode/dina]
  connect_bd_net -net ena_1 [get_bd_ports ena] [get_bd_pins bram_controller_mode/ena] [get_bd_pins standalone_mode/ena]
  connect_bd_net -net enb_1 [get_bd_ports enb] [get_bd_pins bram_controller_mode/enb] [get_bd_pins standalone_mode/enb]
  connect_bd_net -net reset [get_bd_ports rst_in] [get_bd_pins bram_controller_mode/rsta] [get_bd_pins bram_controller_mode/rstb]
  connect_bd_net -net standalone_mode_doutb_2 [get_bd_ports doutb_sam] [get_bd_pins standalone_mode/doutb]
  connect_bd_net -net we_1 [get_bd_ports wea_cm] [get_bd_pins bram_controller_mode/wea]
  connect_bd_net -net wea_2 [get_bd_ports wea_sam] [get_bd_pins standalone_mode/wea]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins bram_controller_mode/web] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins standalone_mode/web] [get_bd_pins xlconstant_2/dout]

  # Create address segments
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


