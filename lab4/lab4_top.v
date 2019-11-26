`timescale 1ns / 1ps

module lab4_top(
	input clk,
	input btnU,
	input btnD,
	input btnL,
	input btnR,
	input btnS,		//reset button (middle)
	output wire Hsync,       // horizontal sync output
    output wire Vsync,       // vertical sync output
    output wire [2:0] vgaRed,    // 3-bit VGA red output
    output wire [2:0] vgaGreen,    // 3-bit VGA green output
    output wire [1:0] vgaBlue,     // 3-bit VGA blue output
	output reg mhz25_clk_out,
	output [6:0] seg,
	output [3:0] an
	);

	//Create the pixel clock
	reg [26:0] mhz25_ctr;
	
	initial begin
		mhz25_ctr = 0;
	end

	always @ (posedge clk)
	begin
		mhz25_ctr = mhz25_ctr + 1;
		if (mhz25_ctr == 2)
			mhz25_clk_out = ~mhz25_clk_out;
	end

	//Debounce the buttons
	wire up;
	wire down;
	wire left;
	wire right;
	wire reset;
	debouncer du (.clk(clk), .btn(btnU), .debounced(up));
	debouncer dd (.clk(clk), .btn(btnD), .debounced(down));
	debouncer dl (.clk(clk), .btn(btnL), .debounced(left));
	debouncer dr (.clk(clk), .btn(btnR), .debounced(right));
	debouncer ds (.clk(clk), .btn(btnS), .debounced(reset));

	//Player Movement Handler
	wire [9:0] xpos;
	wire [8:0] ypos;
	//outputs x and y position to be displayed in map
	movement mv (.clk(clk), .btnU(up), .btnD(down), .btnL(left), .btnR(right),
		.reset(reset), .xpos(xpos), .ypos(ypos));

	//Ghost Movement Handler
//	wire [9:0] ghost_xpos;
//	wire [8:0] ghost_ypos;
//	ghost_movement gmv (.clk(clk), .reset(reset), .xpos(ghost_xpos), .ypos(ghost_ypos));
	
	//Display
	displaytop disp (.clk(clk), .xpos(xpos), .ypos(ypos), /*.RST_BTN(reset),*/ .Hsync(Hsync),
					.Vsync(Vsync), .vgaRed(vgaRed), .vgaGreen(vgaGreen), .vgaBlue(vgaBlue));
					
	//Scoring
	wire score_0;
	wire score_1;
	wire score_2;
	wire score_3;
	assign score_3 = 1;
	assign score_2 = 0;
	assign score_1 = 1;
	assign score_0 = 0;
	score_display sd(.clk(clk),.score_0(score_0), .score_1(score_1),
		.score_2(score_2),.score_3(score_3),.seg(seg),.an(an));

endmodule
