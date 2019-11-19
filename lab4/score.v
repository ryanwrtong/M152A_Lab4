`timescale 1ns / 1ps

module score_display(
		input clk,
		input [3:0] score_0,
		input [3:0] score_1,
		input [3:0] score_2,
		input [3:0] score_3,
		output reg [6:0] seg,
		output reg [3:0] an
);
	reg score_clk;
	reg [26:0] score_clk_counter;

	initial begin
		score_clk = 0;
		score_clk_counter = 0;
	end

	always @ (posedge clk) begin
		score_clk_counter <= score_clk_counter + 1;

		if (score_clk_counter == 100000)
		begin
			score_clk_counter <= 27'b0;
			score_clk = ~ score_clk;
		end
	end

	always @ (posedge score_clk) begin

	end

	// DISPLAY MODULE
	reg [1:0] anode_index;
	reg [3:0] seg_num;
	initial begin
		anode_index = 2'b0;
	end

	//DISPLAY ON SCREEN
	always @ (posedge score_clk)
	begin
		//get anode position
		case (anode_index)
			2'b00: begin
				an = 4'b0111;
				seg_num = score_0;
				anode_index = anode_index + 1;
			end
			2'b01: begin
				an = 4'b1011;
				seg_num = score_1;
				anode_index = anode_index + 1;
			end
			2'b10: begin
				an = 4'b1101;
				seg_num = score_2;
				anode_index = anode_index + 1;
			end
			2'b11: begin
				an = 4'b1110;
				seg_num = score_3;
				anode_index = 0;
			end
		endcase

		//get cathode number
		case(seg_num)
			 4'b0000: seg = 7'b1000000;
			 4'b0001: seg = 7'b1111001;
			 4'b0010: seg = 7'b0100100;
			 4'b0011: seg = 7'b0110000;
			 4'b0100: seg = 7'b0011001;
			 4'b0101: seg = 7'b0010010;
			 4'b0110: seg = 7'b0000010;
			 4'b0111: seg = 7'b1111000;
			 4'b1000: seg = 7'b0000000;
			 4'b1001: seg = 7'b0010000;
			 default: seg = 7'b1111111;
		endcase
	end
endmodule
