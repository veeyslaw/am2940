`include "Headers/Lengths.v"

module Mux2To1 #(
    parameter integer DATA_LENGTH = `DATA_LENGTH
)
(
    input sel,

    input [DATA_LENGTH - 1: 0] di0,
    input [DATA_LENGTH - 1: 0] di1,

    output [DATA_LENGTH - 1: 0] do
);

    assign do = sel ? di1 : di0;

endmodule // Mux2To1

module Mux3To1 #(
    parameter DATA_LENGTH = `DATA_LENGTH
)
(
    input [1: 0] sel,

    input [DATA_LENGTH - 1: 0] di0,
    input [DATA_LENGTH - 1: 0] di1,
    input [DATA_LENGTH - 1: 0] di2,

    output [DATA_LENGTH - 1: 0] do
);

    assign do = sel[1] ? di2 :
                    sel[0] ? di1 : di0;

endmodule // Mux3To1

