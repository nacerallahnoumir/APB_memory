class agent extends uvm_agent;
  `uvm_component_utils(agent)

  apb_config                    cfg;
  uvm_sequencer #(transaction)  seqr;
  driver                        d;
  monitor                       m;

  function new(string name="agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg = apb_config::type_id::create("cfg", this);
    m   = monitor   ::type_id::create("m",   this);

    if (cfg.is_active == UVM_ACTIVE) begin
      d    = driver   ::type_id::create("d",    this);
      seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
    end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (cfg.is_active == UVM_ACTIVE) begin
      d.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction
endclass
