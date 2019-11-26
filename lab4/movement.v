`timescale 1ns / 1ps

module movement (input clk, input btnU, input btnD, input btnL, input btnR, input reset, 
	output reg xpos, output reg ypos
    );
    initial begin
        xpos = 50;   //STARTING POSITION X
        ypos = 50;   //STARTING POSITION Y
    end

//    always @ (posedge clk) begin
//        /*if (reset) begin
//            xpos = START_XPOS;
//            ypos = START_YPOS;
//        end
//        else begin*/
//		if (btnU)
//			ypos = ypos - 20;
//		else if (btnD)
//			ypos = ypos + 20;
//		else if (btnL)
//			xpos = xpos - 20;
//		else if (btnR)
//			xpos = xpos + 20;
//        //end
//    end

endmodule
