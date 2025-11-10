class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  
  uvm_analysis_imp #(transaction, scoreboard) recv;

  bit [31:0] mirror [32] = '{default: 32'd0};

  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv", this);
  endfunction

  
  function void write(transaction tr);
    case (tr.op)
      OP_RST: begin
        `uvm_info("SCO", "RESET detected", UVM_LOW)
      end

      OP_WRITE: begin
        if (tr.PSLVERR) begin
          `uvm_info("SCO", "SLV ERROR during write", UVM_LOW)
        end else begin
          mirror[tr.PADDR] = tr.PWDATA;
          `uvm_info("SCO", $sformatf("WRITE addr=%0d wdata=%0d", tr.PADDR, tr.PWDATA), UVM_LOW)
        end
      end

      OP_READ: begin
        if (tr.PSLVERR) begin
          `uvm_info("SCO", "SLV ERROR during read", UVM_LOW)
        end else begin
          bit [31:0] exp = mirror[tr.PADDR];
          if (exp == tr.PRDATA)
            `uvm_info("SCO", "DATA matched", UVM_LOW)
          else
            `uvm_error("SCO", $sformatf("DATA mismatch addr=%0d exp=%0d got=%0d",
                                         tr.PADDR, exp, tr.PRDATA))
        end
      end
    endcase
  endfunction
endclass
