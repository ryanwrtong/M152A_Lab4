`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:03:58 11/14/2019 
// Design Name: 
// Module Name:    vga 
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
module hvsync_generator(
    input clk,
    output Hsync,
    output Vsync,
    output reg inDisplayArea,
    output reg [9:0] CounterX,
    output reg [8:0] CounterY
  );
    reg vga_HS, vga_VS;

    wire CounterXmaxed = (CounterX == 800); // 16 + 48 + 96 + 640
    wire CounterYmaxed = (CounterY == 525); // 10 + 2 + 33 + 480

    always @(posedge clk)
    if (CounterXmaxed)
      CounterX <= 0;
    else
      CounterX <= CounterX + 1;

    always @(posedge clk)
    begin
      if (CounterXmaxed)
      begin
        if(CounterYmaxed)
          CounterY <= 0;
        else
          CounterY <= CounterY + 1;
      end
    end

    always @(posedge clk)
    begin
      vga_HS <= (CounterX > (640 + 16) && (CounterX < (640 + 16 + 96)));   // active for 96 clocks
      vga_VS <= (CounterY > (480 + 10) && (CounterY < (480 + 10 + 2)));   // active for 2 clocks
    end

    always @(posedge clk)
    begin
        inDisplayArea <= (CounterX < 640) && (CounterY < 480);
    end

    assign Hsync = ~vga_HS;
    assign Vsync = ~vga_VS;

endmodule

module VGADemo(
    input mhz25_clk, output reg [2:0] pixel, output hsync_out, output vsync_out
);
    wire inDisplayArea;
    wire [9:0] CounterX;

    hvsync_generator hvsync(
      .clk(mhz25_clk),
      .Hsync(hsync_out),
      .Vsync(vsync_out),
      .CounterX(CounterX),
      //.CounterY(CounterY),
      .inDisplayArea(inDisplayArea)
    );

    always @(posedge mhz25_clk)
    begin
      if (inDisplayArea)
        pixel <= 3'b111;
      else // if it's not to display, go dark
        pixel <= 3'b000;
    end

endmodule

module lab4_display(
					output reg [2:0] vgaR, output reg [2:0] vgaG, output reg [1:0] vgaB);
endmodule
