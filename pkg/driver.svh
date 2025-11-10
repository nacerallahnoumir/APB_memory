class driver extends uvm_driver #(transaction);
  `uvm_component_utils(driver)

  virtual apb_if vif;

  function new(string name="driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRV/NOVIF", "driver: virtual interface not set")
  endfunction

  task do_reset();
    repeat (5) begin
      vif.presetn <= 1'b0;
      vif.paddr   <= '0;
      vif.pwdata  <= '0;
      vif.pwrite  <= 1'b0;
      vif.psel    <= 1'b0;
      vif.penable <= 1'b0;
      @(posedge vif.pclk);
    end
  endtask

  task run_one(transaction tr);
    case (tr.op)
      OP_RST: begin
        vif.presetn <= 1'b0;
        vif.psel    <= 1'b0;
        vif.penable <= 1'b0;
        @(posedge vif.pclk);
      end

      OP_WRITE: begin
        vif.presetn <= 1'b1;
        vif.psel    <= 1'b1;
        vif.paddr   <= tr.PADDR;
        vif.pwdata  <= tr.PWDATA;
        vif.pwrite  <= 1'b1;
        @(posedge vif.pclk);
        vif.penable <= 1'b1;
        @(posedge vif.pclk); 
        @(negedge vif.pready);
        vif.penable <= 1'b0;
        tr.PSLVERR  =  vif.pslverr;
      end

      OP_READ: begin
        vif.presetn <= 1'b1;
        vif.psel    <= 1'b1;
        vif.paddr   <= tr.PADDR;
        vif.pwrite  <= 1'b0;
        @(posedge vif.pclk);
        vif.penable <= 1'b1;
        @(posedge vif.pclk);
        @(negedge vif.pready);
        vif.penable <= 1'b0;
        tr.PRDATA   =  vif.prdata;
        tr.PSLVERR  =  vif.pslverr;
      end
    endcase
  endtask

  virtual task run_phase(uvm_phase phase);
    transaction tr;
    do_reset();
    forever begin
      seq_item_port.get_next_item(tr);
      run_one(tr);
      seq_item_port.item_done();
    end
  endtask
endclass
