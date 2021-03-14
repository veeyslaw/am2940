`include "Headers/Lengths.v"

module Counter #(
    parameter integer DATA_LENGTH = `DATA_LENGTH
)
(
    input clk,
    input res,
    input pl,
    
    input en,
    input inc,
    input dec,

    input cin, // counter in negated
    input [DATA_LENGTH - 1: 0] di,

    output reg con, // counter out negated
    output reg [DATA_LENGTH - 1: 0] do
);

    always @(posedge clk) begin
        con <= 1;

        if (res)
            do <= 0;

        else if (pl)
            do <= di;
        
        else if (en & ~ cin)
        	if (inc) begin
        		if (& do)
        			con <= 0;
        		
            	do <= do + 1;
            	
            end
        	else if (dec) begin
        		if (~| do)
        			con <= 0;
            	do <= do - 1;
            end
    end

endmodule // Counter

