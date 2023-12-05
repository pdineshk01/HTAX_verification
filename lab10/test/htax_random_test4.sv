class htax_random_test4 extends base_test;

	`uvm_component_utils(htax_random_test4)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", destport_random_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting htax random test",UVM_NONE)
	endtask : run_phase

endclass : htax_random_test4


///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////


class destport_random_vsequence extends htax_base_vseq;

  `uvm_object_utils(destport_random_vsequence)


  function new (string name = "destport_random_vsequence");
    super.new(name);
  endfunction : new

  task body();	
		// Exectuing 10 TXNs on ports {0,1,2,3} randomly 
   
	repeat(5) begin

        `uvm_do_on_with(req, p_sequencer.htax_seqr[0], { req.dest_port == 0;} )
        `uvm_do_on_with(req, p_sequencer.htax_seqr[0], { req.dest_port == 1;} )
        `uvm_do_on_with(req, p_sequencer.htax_seqr[0], { req.dest_port == 2;} )
        `uvm_do_on_with(req, p_sequencer.htax_seqr[0], { req.dest_port == 3;} )

			//USE `uvm_do_on_with to add constraints on req
    end




  endtask : body

endclass : destport_random_vsequence