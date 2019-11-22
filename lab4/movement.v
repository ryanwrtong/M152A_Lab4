`timescale 1ns / 1ps

module movement (input clk, input btnU, input btnD, input btnL, input btnR, input reset, output reg xpos, output reg ypos
    );
    parameter START_XPOS = 1;
    parameter START_YPOS = 1;

    initial begin
        xpos = START_XPOS;   //STARTING POSITION X
        ypos = START_YPOS;   //STARTING POSITION Y
    end

    always @ (posedge clk) begin
        if (reset) begin
            xpos <= START_XPOS;
            ypos <= START_YPOS;
        end
        else begin
        //TODO: check valid move
            if (btnU)
                ypos <= ypos - 1;
            else if (btnD)
                ypos <= ypos + 1;
            else if (btnL)
                xpos <= xpos - 1;
            else if (btnR)
                xpos <= xpos + 1;
        end
    end

endmodule
