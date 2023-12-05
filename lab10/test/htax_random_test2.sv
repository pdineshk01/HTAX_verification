class htax_random_test2 extends base_test;

	`uvm_component_utils(htax_random_test2)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", multiplepacket_random_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting htax random test",UVM_NONE)
	endtask : run_phase

endclass : htax_random_test2


///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////


class multiplepacket_random_vsequence extends htax_base_vseq;

  `uvm_object_utils(multiplepacket_random_vsequence)

  rand int port;

  function new (string name = "multiplepacket_random_vsequence");
    super.new(name);
  endfunction : new

  task body();	
		// Exectuing 10 TXNs on ports {0,1,2,3} randomly 
   
	repeat(2) begin
	port = $urandom_range(0,3);

	for(int i=0;i<4;i++)
		for(int j=3;j<64;j++)
	
      `uvm_do_on_with(req, p_sequencer.htax_seqr[port], { req.dest_port == i; req.length == j;} )

			//USE `uvm_do_on_with to add constraints on req
    end




  endtask : body

endclass : multiplepacket_random_vsequence