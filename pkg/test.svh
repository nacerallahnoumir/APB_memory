class test extends uvm_test;
  `uvm_component_utils(test)

  env          e;
  write_data   wdata;
  read_data    rdata;
  write_read   wrrd;
  writeb_readb wrrdb;
  write_err    werr;
  read_err     rerr;
  reset_dut    rstdut;

  function new(string name="test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e      = env         ::type_id::create("e",      this);
    wdata  = write_data  ::type_id::create("wdata",  this);
    rdata  = read_data   ::type_id::create("rdata",  this);
    wrrd   = write_read  ::type_id::create("wrrd",   this);
    wrrdb  = writeb_readb::type_id::create("wrrdb",  this);
    werr   = write_err   ::type_id::create("werr",   this);
    rerr   = read_err    ::type_id::create("rerr",   this);
    rstdut = reset_dut   ::type_id::create("rstdut", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    // wdata.start(e.a.seqr);
    // rdata.start(e.a.seqr);
    // wrrd.start(e.a.seqr);
    wrrdb.start(e.a.seqr);
    // werr.start(e.a.seqr);
    // rerr.start(e.a.seqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass
