`include "Headers/Lengths.v"

module Register #(
	parameter integer DATA_LENGTH = `DATA_LENGTH
)
(
    input clk,
    input pl,
    
    input [DATA_LENGTH - 1: 0] di,
    output reg [DATA_LENGTH - 1: 0] do
);

    always @(posedge clk)
        if (pl)
            do <= di;

endmodule // Register

