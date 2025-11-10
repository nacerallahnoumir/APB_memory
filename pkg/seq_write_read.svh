class write_read extends uvm_sequence #(transaction);
  `uvm_object_utils(write_read)
  function new(string name="write_read"); 
	super.new(name); 
endfunction

  virtual task body();
    transaction tr = transaction::type_id::create("tr");
    repeat (20) begin
      tr.addr_c.constraint_mode(1);
      tr.addr_c_err.constraint_mode(0);

      start_item(tr); 
	  assert(tr.randomize()); 
	  tr.op = OP_WRITE; 
	  finish_item(tr);
      start_item(tr);
	  assert(tr.randomize()); 
	  tr.op = OP_READ;  
	  finish_item(tr);
    end
  endtask
endclass
