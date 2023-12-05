class htax_random_test extends base_test;

	`uvm_component_utils(htax_random_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", longpack_random_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting htax random test",UVM_NONE)
	endtask : run_phase

endclass : htax_random_test


///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////


class longpack_random_vsequence extends htax_base_vseq;

  `uvm_object_utils(longpack_random_vsequence)

  rand int port;

  function new (string name = "longpack_random_vsequence");
    super.new(name);
  endfunction : new

  task body();	


	repeat(5) begin
 	//port = $urandom_range(0,3);
	fork
      `uvm_do_on_with(pkt0, p_sequencer.htax_seqr[0], { pkt0.length ==40; pkt0.dest_port == 0; pkt0.delay==15;} )
			//USE `uvm_do_on_with to add constraints on req
      `uvm_do_on_with(pkt1,  p_sequencer.htax_seqr[1], { pkt1.length ==40; pkt1.dest_port == 1;pkt1.delay==15;} )
      `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], { pkt2.length ==40 ; pkt2.dest_port == 2;pkt2.delay==15;} )
			//USE `uvm_do_on_with to add constraints on req
      `uvm_do_on_with(pkt3,  p_sequencer.htax_seqr[3], { pkt3.length ==40 ; pkt3.dest_port == 3;pkt3.delay==15;} )

	join	

    end




  endtask : body

endclass : longpack_random_vsequence