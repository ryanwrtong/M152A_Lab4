module displaytop(
    input wire clk,             // board clock: 100 MHz on Arty/Basys3/Nexys
	input wire [9:0] xpos,
	input wire [8:0] ypos,
    //input wire RST_BTN,         // reset button
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
    always @(posedge clk)
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000

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

    // Four overlapping squares
    /*wire blockArr [8:0][9:0];
	genvar Yindex;
	genvar Xindex;
	generate
		for(Yindex=0; Yindex<9; Yindex=Yindex+1) begin
			for(Xindex=0; Xindex<10; Xindex=Xindex+1) begin
				assign blockArr[Yindex][Xindex] = (2 > 1) ? 1 : 0; //((x > 20+(30*Xindex)) & (y > 20+(30*Yindex)) & (x < 50+(30*Xindex)) & (y < 50+(30*Yindex))) ? 1 : 0;
				
			end
		end
	endgenerate*/
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

