class reset_dut extends uvm_sequence #(transaction);
  `uvm_object_utils(reset_dut)
 function new(string name="reset_dut");
	super.new(name);
endfunction

  virtual task body();
    transaction tr;
    repeat (15) begin
      `uvm_do_with(tr, { tr.op == OP_RST; })
    end
  endtask
endclass
