 module apb_ram(input presetn,
				input pclk,
				input sel,
				input penable,
				input pwrite,
				input [31:0] paddr,pwdata,
				output reg [31:0] prdata,
				output reg pready,pslverr   //pslverr it will be 1 in case we applied an address beyond the limit 
				) ;
reg [31:0] memory [32];
typedef enum{idle =0,setup=1,access=2,transfer=3} state_type;
state_type state = idle;
always @(posedge pclk)
begin 
	if(presetn==1'b0)
	begin
		state <= idle;
		prdata<= 32'h00000000;
		pready <=1'b0;
		pslverr<=1'b0;
		
		// reset the memory
		for(int i =0; i<32;i++)
		begin 
			memory[i]<=0;
		end 
	end
	else 
	begin
		case(state)
		idle : begin 
					prdata<= 32'h00000000;
					pready <=1'b0;
					pslverr<=1'b0;
					state <= setup;
				end
		
		setup :begin
					if (sel== 1'b1)
							state<=access;
					else 
							state <= setup;
				end
		
		access :begin
					if (pwrite && penable) begin
						
							if (paddr<32) begin
								pslverr <= 1'b0;
								pready<=1'b1;
								memory[paddr]<= pwdata;
								state <= transfer;
							end
							else begin
								pslverr <= 1'b1;
								pready<=1'b1;
								state <= transfer;
							end	
					end
							
					else if (!pwrite && penable) begin
						
							if (paddr<32) begin
								pslverr <= 1'b0;
								pready<=1'b1;
								prdata<= memory[paddr];
								state <= transfer;
							end
							else begin
								pslverr <= 1'b1;
								pready<=1'b1;
								state <= transfer;
								prdata<= 32'hxxxxxxxx;
							end	
					end
						
				end 
			
		transfer:begin
					
					state<=setup;
					pslverr <= 1'b0;
					pready<=1'b0;
				end 
		default : state<=idle;
		endcase
	end
end
endmodule
 
 
