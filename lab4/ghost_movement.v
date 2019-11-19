`timescale 1ns / 1ps

module ghost_movement (input clk, input rst, output reg xpos, output reg ypos
    );

    parameter UP = 4'b0001;
    parameter DOWN = 4'b0010;
    parameter LEFT = 4'b0100;
    parameter RIGHT = 4'b1000;
    parameter GHOST_START_XPOS = 8;
    parameter GHOST_START_YPOS = 8;
    reg [3:0] curdir;

    initial begin
        xpos = GHOST_START_XPOS;   //GHOST STARTING POSITION X
        ypos = GHOST_START_YPOS;   //GHOST STARTING POSITION Y
        curdir = 0;
    end

    always @ (posedge clk) begin
        if (rst) begin
            xpos <= GHOST_START_XPOS;
            ypos <= GHOST_START_YPOS;
            curdir = 0;
        end
        else begin
          //TODO: check if valid move
          //TODO: generate random direction to go
            if (curdir == UP)
                ypos <= ypos - 1;
            else if (curdir == DOWN)
                ypos <= ypos + 1;
            else if (curdir == LEFT)
                xpos <= xpos - 1;
            else if (curdir == RIGHT)
                xpos <= xpos + 1;
        end
    end

endmodule
