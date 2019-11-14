`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:40:50 11/14/2019 
// Design Name: 
// Module Name:    lab4_one 
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
module lab4_top(input clk, output reg mhz25_clk_out);
	reg [26:0] mhz25_ctr;

	initial
		mhz25_ctr = 0;
	
	always @ (posedge clk)
	begin
		mhz25_ctr = mhz25_ctr + 1;
		if (mhz25_ctr == 2)
			mhz25_clk_out = ~mhz25_clk_out;
	end
	
endmodule