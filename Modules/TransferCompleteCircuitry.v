`include "Headers/Lengths.v"

module TransferCompleteCircuitry #(
    parameter integer DATA_LENGTH = `DATA_LENGTH
)
(
    input [DATA_LENGTH - 1: 0] next_address,
    input [DATA_LENGTH - 1: 0] next_word_cnt,
    input [DATA_LENGTH - 1: 0] word_cnt,
    
    input [1: 0] ctrl_mode,
    input cinwc,

    output reg done
);

    always @*
        casex ({ctrl_mode, cinwc})
            'b00_0: done <= next_word_cnt == 1;
            'b00_1: done <= ~| next_word_cnt;
            'b01_0: done <= next_word_cnt + 1 == word_cnt;
            'b01_1: done <= next_word_cnt == word_cnt;
            'b10_x: done <= next_word_cnt == next_address;
            'b11_x: done <= 0;
            default: done <= 1'bx;
        endcase

endmodule // TransferCompleteCircuitry
