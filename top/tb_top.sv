`timescale 1ns/1ps

import uvm_pkg::*;
import my_tb_pkg::*;

module tb;

  // adjust interface to your declaration; 
  logic pclk, presetn;
  apb_if vif(pclk, presetn);

  // DUT instance
  apb_ram dut (
    .presetn (vif.presetn),
    .pclk    (vif.pclk),
    .psel    (vif.psel),
    .penable (vif.penable),
    .pwrite  (vif.pwrite),
    .paddr   (vif.paddr),
    .pwdata  (vif.pwdata),
    .prdata  (vif.prdata),
    .pready  (vif.pready),
    .pslverr (vif.pslverr)
  );

  // clock/reset
  initial begin pclk = 0; forever #10 pclk = ~pclk; end
  initial begin presetn = 0; #50 presetn = 1; end

  initial begin
    // make vif visible to components
    uvm_config_db#(virtual apb_if)::set(null, "*", "vif", vif);
    run_test("test");
  end
endmodule
