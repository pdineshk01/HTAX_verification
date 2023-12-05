class htax_random_test3 extends base_test;

	`uvm_component_utils(htax_random_test3)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", delay_random_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting htax random test",UVM_NONE)
	endtask : run_phase

endclass : htax_random_test3


///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////


class delay_random_vsequence extends htax_base_vseq;

  `uvm_object_utils(delay_random_vsequence)

  rand int delay;

  function new (string name = "delay_random_vsequence");
    super.new(name);
  endfunction : new

  task body();	


	repeat(5) begin
 	delay = $urandom_range(1,20);
	
      `uvm_do_on_with(req, p_sequencer.htax_seqr[0], { req.delay==delay;} )
			//USE `uvm_do_on_with to add constraints on req


    end




  endtask : body

endclass : delay_random_vsequence