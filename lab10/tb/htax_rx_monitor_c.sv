///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

class htax_rx_monitor_c extends uvm_monitor;
		
	`uvm_component_utils(htax_rx_monitor_c)
	
	//Analysis port to communicate with Scoreboard
	uvm_analysis_port #(htax_rx_mon_packet_c) rx_collect_port;

	virtual interface htax_rx_interface htax_rx_intf;
	htax_rx_mon_packet_c rx_mon_packet;
	int pkt_len;

	covergroup cover_rx_packet;
    option.per_instance = 1;
    option.name = "cover_rx_packet";


    // Coverpoint for htax packet field : destination port
    VC_GNT : coverpoint htax_rx_intf.rx_vc_gnt  {
                                          bins vc1 = {1, 2, 3};
                                       		}

endgroup

	function new (string name, uvm_component parent);
		super.new(name, parent);
		rx_collect_port = new ("rx_collect_port", this);
		rx_mon_packet 	= new();
		this.cover_rx_packet = new();
	endfunction : new

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual htax_rx_interface)::get(this,"","rx_vif",htax_rx_intf))
			`uvm_fatal("RX_VIF",{"Virtual Interface needs to be set for ",get_full_name(),".rx_vif"})
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			pkt_len=0;

			@(posedge (|htax_rx_intf.rx_vc_gnt));	// waiting for vc_gnt to be asserted for sampling
		
			cover_rx_packet.sample();

			//Wait for rising edge of htax_rx_intf.rx_sot
			@(posedge (|htax_rx_intf.rx_sot))
				
			//On consequtive cycles append htax_rx_intf.rx_data to rx_mon_packet.data[] till htax_rx_intf.rx_eot pulse
			while(!htax_rx_intf.rx_eot==1) begin
				@(posedge htax_rx_intf.clk);
				rx_mon_packet.data = new [++pkt_len] (rx_mon_packet.data);
				rx_mon_packet.data[pkt_len-1] = htax_rx_intf.rx_data;
			end
			
			//Write the rx_mon_packet on anaylysis port
			rx_collect_port.write(rx_mon_packet);
		
		end
	endtask : run_phase
endclass : htax_rx_monitor_c
