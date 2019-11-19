`timescale 1ns / 1ps

module lab4_top(
	input clk,
	input btnU,
	input btnD,
	input btnL,
	input btnR,
	input btnS,		//reset button (middle)
	output reg mhz25_clk_out
	);

	//Create the pixel clock
	reg [26:0] mhz25_ctr;

	initial
		mhz25_ctr = 0;

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
	debouncer ds (.clk(clk), .btn(btnR), .debounced(reset));

	//Player Movement Handler
	wire [9:0] xpos;
	wire [9:0] ypos;
	// outputs x and y position to be displayed in map
	movement mv (.clk(clk), .btnU(up), .btnD(down), .btnL(left), .btnR(right),
		.rst(reset), .xpos(xpos), .ypos(ypos));

	//Ghost Movement Handler
	wire [9:0] ghost_xpos;
	wire [9:0] ghost_ypos;
	ghost_movement gmv (.clk(clk), .rst(reset), .xpos(ghost_xpos), .ypos(ghost_ypos));


	//Scoring
	//TODO: connect scoring, add reset to scoring

endmodule
