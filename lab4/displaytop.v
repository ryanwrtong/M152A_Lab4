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
    output wire [1:0] vgaBlue     // 3-bit VGA blue output
    );

    wire rst = 0; //~RST_BTN;    // reset is active low on Arty & Nexys Video

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;
    always @(posedge clk) begin
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000
	end

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
	reg [9:0] g_xpos;
	reg [8:0] g_ypos;
	reg [9:0] g2_xpos;
	reg [8:0] g2_ypos;
	reg died;
	reg [26:0] mhz1_ctr;
	reg mhz1_clk;
	reg tgl_gdir;
	initial begin
        xpos = 50;   //STARTING POSITION X
        ypos = 50;   //STARTING POSITION Y
		died = 0;
		g_xpos = 300;
		g_ypos = 300;
		g2_xpos = 320;
		g2_ypos = 300;
		mhz1_ctr = 0;
		tgl_gdir = 0;
    end

	//Movement clock
	always @ (posedge clk)
	begin
		mhz1_ctr = mhz1_ctr + 1;
		if (mhz1_ctr == 5)
			mhz1_clk = ~mhz1_clk;
	end

    always @ (posedge mhz1_clk) begin
        if (btnS || died) begin
            xpos = 50;
            ypos = 50;
			g_xpos = 300;
			g_ypos = 300;
			g2_xpos = 320;
			g2_ypos = 300;
			died = 0;
        end
		else if ((xpos == g_xpos && ypos == g_ypos) || (xpos == g2_xpos && ypos == g2_ypos))
			died = 1;
        else begin
			if (btnU) begin
				if (ypos - 1 > 45)
					ypos = ypos - 10;
			end
			else if (btnD) begin
				if (ypos + 1 < 395)
					ypos = ypos + 10;
			end
			else if (btnL) begin
				if (xpos - 1 > 45)
					xpos = xpos - 10;
			end
			else if (btnR) begin
				if (xpos + 1 < 395)
					xpos = xpos + 10;
			end

			if (!tgl_gdir) begin
				if (xpos < g_xpos && g_xpos - 1 > 45)
					g_xpos = g_xpos - 10;
				else if (g_xpos + 1 < 395)
					g_xpos = g_xpos + 10;
			end
			else begin
				if (ypos < g_ypos && g_ypos - 1 > 45)
					g_ypos = g_ypos - 10;
				else if (g_ypos + 1 < 395)
					g_ypos = g_ypos + 10;
			end

			if (xpos < g2_xpos && g2_xpos - 1 > 45)
				g2_xpos = g2_xpos - 10;
			else if (ypos < g2_ypos && g2_ypos - 1 > 45)
				g2_ypos = g2_ypos - 10;
			else if (g2_xpos + 1 < 395)
				g2_xpos = g2_xpos + 10;
			else if (g2_ypos + 1 < 395)
				g2_ypos = g2_ypos + 10;

			tgl_gdir = ~ tgl_gdir;
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
	assign ghost = ((x < g_xpos + 6) & (x > g_xpos - 6) & (y < g_ypos + 6) & (y > g_ypos - 6)) ? 1 : 0;
	assign ghost2 = ((x < g2_xpos + 6) & (x > g2_xpos - 6) & (y < g2_ypos + 6) & (y > g2_ypos - 6)) ? 1 : 0;

    assign vgaRed[2:2] = pacman | ghost2;
	assign vgaRed[1:1] = pacman | ghost2;
	assign vgaRed[0:0] = pacman | ghost2;
    assign vgaGreen[2] = ghost | ghost2;
	assign vgaGreen[1] = ghost | ghost2;
	assign vgaGreen[0] = ghost | ghost2;
	assign vgaBlue[1:1] = grid | box1 | box2 | box3 | box4;
	assign vgaBlue[0:0] = grid | box1 | box2 | box3 | box4;
endmodule

