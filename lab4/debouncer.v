`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:59:31 11/12/2019 
// Design Name: 
// Module Name:    debouncer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module debouncer(input clk, input btn, output reg debounced);
	reg[15:0] ctr;

	always @ (posedge clk) begin
		if (btn == 1'b0) begin
			ctr = 0;
			debounced = 0;
		end
		else begin
			ctr = ctr + 1;
			if (ctr == 30000)
			begin
				ctr = 0;
				debounced = 1;
			end
		end
	end

endmodule
