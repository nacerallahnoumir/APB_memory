class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  virtual apb_if vif;
  uvm_analysis_port #(transaction) send;

  function new(string name="monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    send = new("send", this);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("MON/NOVIF", "monitor: virtual interface not set")
  endfunction

  virtual task run_phase(uvm_phase phase);
    transaction tr;
    forever begin
      @(posedge vif.pclk);
      if (!vif.presetn) begin
        tr = transaction::type_id::create("tr");
        tr.op = OP_RST;
        `uvm_info("MON", "System reset detected", UVM_LOW)
        send.write(tr);
      end
      else if (vif.psel && vif.penable &&  vif.pwrite) begin 
        tr = transaction::type_id::create("tr");
        tr.op      = OP_WRITE;
        tr.PADDR   = vif.paddr;
        tr.PWDATA  = vif.pwdata;
        tr.PSLVERR = vif.pslverr;
        send.write(tr);
      end
      else if (vif.psel && vif.penable && !vif.pwrite) begin 
        tr = transaction::type_id::create("tr");
        tr.op      = OP_READ;
        tr.PADDR   = vif.paddr;
        tr.PRDATA  = vif.prdata;
        tr.PSLVERR = vif.pslverr;
        send.write(tr);
      end
    end
  endtask
endclass
