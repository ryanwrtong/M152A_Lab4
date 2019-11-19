`timescale 1ns / 1ps

module movement (input clk, input btnU, input btnD, input btnL, input btnR, input rst, output xpos, output ypos
    );

    initial begin
        xpos = 1;   //STARTING POSITION X
        ypos = 1;   //STARTING POSITION Y
    end

    reg [3:0] curdir;
    always @ (posedge clk) begin
        if (rst) begin
            xpos = 1;
            ypos = 1;
        end
        else begin
            if (btnU)
                ypos = ypos - 1;
            else if (btnD)
                ypos = ypos + 1;
            else if (btnL)
                xpos = xpos - 1;
            else if (btnR)
                xpos = xpos + 1;
        end
    end

endmodule
