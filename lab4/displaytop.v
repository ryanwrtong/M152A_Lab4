module displaytop(
    input wire clk,             // board clock: 100 MHz on Arty/Basys3/Nexys
    //input wire RST_BTN,         // reset button
    output wire Hsync,       // horizontal sync output
    output wire Vsync,       // vertical sync output
    output wire [2:0] vgaRed,    // 3-bit VGA red output
    output wire [2:0] vgaGreen,    // 3-bit VGA green output
    output wire [1:0] vgaBlue     // 3-bit VGA blue output
    );

    //wire rst = ~RST_BTN;    // reset is active low on Arty & Nexys Video
    wire rst = 0;  // reset is active high on Basys3 (BTNC)

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
    wire sq_a, sq_b, sq_c, sq_d;
    assign sq_a = ((x > 120) & (y >  40) & (x < 280) & (y < 200)) ? 1 : 0;
    assign sq_b = ((x > 200) & (y > 120) & (x < 360) & (y < 280)) ? 1 : 0;
    assign sq_c = ((x > 280) & (y > 200) & (x < 440) & (y < 360)) ? 1 : 0;
    assign sq_d = ((x > 360) & (y > 280) & (x < 520) & (y < 440)) ? 1 : 0;

    assign vgaRed[2:2] = sq_b;         // square b is red
	assign vgaRed[1:1] = sq_b;
	assign vgaRed[0:0] = sq_b;
    assign vgaGreen[2] = sq_d;  // squares a and d are green
	assign vgaGreen[1] = sq_d;
	assign vgaGreen[0] = sq_d;
	assign vgaBlue[1:1] = sq_c;        // square c is blue
	assign vgaBlue[0:0] = sq_c; 
endmodule

