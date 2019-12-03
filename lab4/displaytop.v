`timescale 1ns / 1ps
module displaytop(
    input wire clk,             // board clock: 100 MHz on Arty/Basys3/Nexys
	input wire btnU,
	input wire btnD,
	input wire btnL,
	input wire btnR,
	input wire btnS,         // reset button
    output wire Hsync,       // horizontal sync output
    output wire Vsync,       // vertical sync output
    output wire [2:0] vgaRed,    // 3-bit VGA red output
    output wire [2:0] vgaGreen,    // 3-bit VGA green output
    output wire [1:0] vgaBlue,     // 3-bit VGA blue output
	output wire score_0,
	output wire score_1,
	output wire score_2,
	output wire score_3
    );

    wire rst = 0; //~RST_BTN;    // reset is active low on Arty & Nexys Video

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;
    always @(posedge clk) begin
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000
	end

	//pellets and scoring
	reg [17:0] gridVisited [17:0];
	reg score0;
	reg score1;
	reg score2;
	reg score3;

    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511

    vga640x480 display (
        .i_clk(clk),
        .i_pix_stb(pix_stb),
        .i_rst(rst),
        .o_hs(Hsync), 
        .o_vs(Vsync), 
        .o_x(x), 
        .o_y(y)
    );

	//Player Movement Handler
	reg [9:0] xpos;
	reg [8:0] ypos;
	reg [26:0] mhz1_ctr;
	reg mhz1_clk;
	initial begin
        xpos = 50;   //STARTING POSITION X
        ypos = 50;   //STARTING POSITION Y
	mhz1_ctr = 0;
	for (int i=0; i<=17; i++)
		for (int j=0; j <=17; j++)
			gridVisited[i][j] = 0;
	score0 = 0;
	score1 = 0;
	score2 = 0;
	score3 = 0;
    end
	
	//Movement clock
	always @ (posedge clk)
	begin
		mhz1_ctr = mhz1_ctr + 1;
		if (mhz1_ctr == 5)
			mhz1_clk = ~mhz1_clk;
	end
	
    always @ (posedge mhz1_clk) begin
        if (btnS) begin
            xpos = 50;
            ypos = 50;
        end
        else begin
			if (btnU) begin
				if (ypos - 20 > 45)
					ypos = ypos - 20;
				if (gridVisited[xpos][ypos] == 0)
				begin
					gridVisited[xpos][ypos] = 1;
					score0++;
				end
				
			end
			else if (btnD) begin
				if (ypos + 20 < 395)
					ypos = ypos + 20;
				if (gridVisited[xpos][ypos] == 0)
				begin
					gridVisited[xpos][ypos] = 1;
					score0++;
				end
			end
			else if (btnL) begin
				if (xpos - 20 > 45)
					xpos = xpos - 20;
				if (gridVisited[xpos][ypos] == 0)
				begin
					gridVisited[xpos][ypos] = 1;
					score0++;
				end
			end
			else if (btnR) begin
				if (xpos + 20 < 395)
					xpos = xpos + 20;
				if (gridVisited[xpos][ypos] == 0)
				begin
					gridVisited[xpos][ypos] = 1;
					score0++;
				end
			end
	if (score0 == 10)
	begin
		if (score1 == 9 && score2 == 9 && score3 == 9)
			score0 = 9;
		else begin
			score0 = 0;
			score1++;
		end
	end
	if (score1 == 10)
	begin
		if (score2 == 9 && score3 == 9)
			score1 = 9;
		else begin
			score1 = 0;
			score2++;
		end
	end
	if (score2 == 10)
	begin
		if (score3 == 9)
			score2 = 9;
		else begin
			score2 = 0;
			score3++;
		end
	end
	if (score3 == 10)
	begin
		score3 = 9;
	end
	
	score_0 = score0;
	score_1 = score1;
	score_2 = score2;
	score_3 = score3;
        end
    end

	

	//Ghost Movement Handler
//	wire [9:0] ghost_xpos;
//	wire [8:0] ghost_ypos;
//	ghost_movement gmv (.clk(clk), .reset(reset), .xpos(ghost_xpos), .ypos(ghost_ypos));
	
	
	//Draw map
    assign grid = ((((x > 20) & (x < 40)) | ((y >  20) & (y < 40)) | ((x > 400) & (x < 420)) | ((y > 400) & (y < 420))) & (x > 20) & (y > 20) &(x < 420) & (y < 420)) ? 1 : 0;
	assign box1 = ((x > 60) & (y > 60) & (x < 210) & (y < 210)) ? 1 : 0;
	assign box2 = ((x > 230) & (y > 60) & (x < 380) & (y < 210)) ? 1 : 0;
	assign box3 =  ((x > 60) & (y > 230) & (x < 210) & (y < 380)) ? 1 : 0;
	assign box4 =  ((x > 230) & (y > 230) & (x < 380) & (y < 380)) ? 1 : 0;
    /*assign sq_b = ((x > 120) & (y > 120) & (x < 220) & (y < 220)) ? 1 : 0;
    assign sq_c = ((x > 220) & (y > 200) & (x < 320) & (y < 320)) ? 1 : 0;
    assign sq_d = ((x > 320) & (y > 280) & (x < 420) & (y < 420)) ? 1 : 0;*/
	
	assign pacman = ((x < xpos + 6) & (x > xpos - 6) & (y < ypos + 6) & (y > ypos - 6)) ? 1 : 0;

    assign vgaRed[2:2] = pacman;
	assign vgaRed[1:1] = pacman;
	assign vgaRed[0:0] = pacman;
    assign vgaGreen[2] = 0;
	assign vgaGreen[1] = 0;
	assign vgaGreen[0] = 0;
	assign vgaBlue[1:1] = grid | box1 | box2 | box3 | box4;
	assign vgaBlue[0:0] = grid | box1 | box2 | box3 | box4;
endmodule

