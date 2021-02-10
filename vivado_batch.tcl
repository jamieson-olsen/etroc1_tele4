# Simple TCL script for Vivado builds
# Jamieson Olsen <jamieson@fnal.gov>
#
# vivado -mode tcl -source vivado_batch.tcl

# general setup stuff...

set_param general.maxThreads 4
set outputDir ./output
file mkdir $outputDir
set_part xc7k325t-ffg900-2

# load the sources and constraints...

read_vhdl ../src/kc705_package.vhd
read_vhdl ../src/top_level.vhd

read_vhdl ../src/oei/hdl/burst_traffic_controller.vhd
read_vhdl ../src/oei/hdl/ethernet_interface.vhd
read_vhdl ../src/oei/hdl/params_package.vhd

read_vhdl ../src/oei/data_manager/burst_controller_sm.vhd
read_vhdl ../src/oei/data_manager/data_manager.vhd
read_vhdl ../src/oei/data_manager/ram_comm_dec.vhd
read_vhdl ../src/oei/data_manager/rx_ctl.vhd
read_vhdl ../src/oei/data_manager/tx_seq_ctl.vhd

read_vhdl ../src/oei/ethernet_controller/address_container.vhd
read_vhdl ../src/oei/ethernet_controller/crc_splice.vhd
read_vhdl ../src/oei/ethernet_controller/ethernet_controller.vhd
read_vhdl ../src/oei/ethernet_controller/icmp_ping_checksum_calc.vhd
read_vhdl ../src/oei/ethernet_controller/reset_mgr.vhd
read_vhdl ../src/oei/ethernet_controller/arp_reply.vhd
read_vhdl ../src/oei/ethernet_controller/create_packet.vhd
read_vhdl ../src/oei/ethernet_controller/ethernet_controller_wrapper.vhd
read_vhdl ../src/oei/ethernet_controller/icmp_ping_shift_reg.vhd
read_vhdl ../src/oei/ethernet_controller/udp_data_splicer.vhd
read_verilog ../src/oei/ethernet_controller/crc_chk.v
read_vhdl ../src/oei/ethernet_controller/dataout_mux.vhd
read_vhdl ../src/oei/ethernet_controller/fifo.vhd
read_vhdl ../src/oei/ethernet_controller/ip_checksum_calc.vhd
read_vhdl ../src/oei/ethernet_controller/user_addrs_mux.vhd
read_verilog ../src/oei/ethernet_controller/crc_gen.v
read_vhdl ../src/oei/ethernet_controller/decipherer.vhd
read_vhdl ../src/oei/ethernet_controller/filter_data_out.vhd
read_vhdl ../src/oei/ethernet_controller/or33.vhd
read_vhdl ../src/oei/ethernet_controller/xmii_handler.vhd

# Load IP core container file should be *.XCIX container
# which includes the output products.  XCIX does not
# require synth_ip and generate_target commands
read_ip ../src/ip/gig_ethernet_pcs_pma_0.xcix

# Load IP module as *.xci
#read_ip ../src/ip/gig_ethernet_pcs_pma_0.xci
#set_property target_language VHDL [current_project]
#generate_target all [get_files ../src/ip/gig_ethernet_pcs_pma_0.xci]

# Load general constraints...

read_xdc -verbose ./constraints.xdc

# synth design...

synth_design -top top_level
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_power -file $outputDir/post_synth_power.rpt
report_utilization -file $outputDir/post_synth_util.rpt

# place...

opt_design
place_design
phys_opt_design -directive AggressiveFanoutOpt
write_checkpoint -force $outputDir/post_place
report_timing_summary -file $outputDir/post_place_timing_summary.rpt
report_timing -sort_by group -max_paths 100 -path_type summary -file $outputDir/post_place_timing.rpt

# route...

route_design
write_checkpoint -force $outputDir/post_route

# generate reports...

report_timing_summary -file $outputDir/post_route_timing_summary.rpt
report_timing -sort_by group -max_paths 100 -path_type summary -file $outputDir/post_route_timing.rpt
report_clock_utilization -file $outputDir/clock_util.rpt
report_utilization -file $outputDir/post_route_util.rpt
report_power -file $outputDir/post_route_power.rpt
report_drc -file $outputDir/post_imp_drc.rpt
report_io -file $outputDir/io.rpt

# write out VHDL and constraints for timing sim...

#write_vhdl -force $outputDir/vivpram_impl_netlist.v
#write_xdc -no_fixed_only -force $outputDir/bft_impl.xdc

# generate bitstream...

write_bitstream -force $outputDir/pulsar2b_oei_test.bit

# write out ILA debug probes file
# write_debug_probes -force $outputDir/probes.ltx

