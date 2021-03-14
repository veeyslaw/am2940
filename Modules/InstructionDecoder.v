`include "Headers/Lengths.v"

module InstructionDecoder (
	input [`INSTR_LENGTH - 1: 0] instruction,
	input [`CTRL_LENGTH - 1: 0] control,
	
    output plar, // parallel load address reg
    output plwcr, // parallel load word count reg
    output plcr, // parallel load control reg
    
    output sela, // select address
    output selw, // select word count
    output [1: 0] seld, // select data
    
    output resac, // reset address counter
    output plac, // parallel load address counter
    output enac, // enable count address counter
    output incac, // increment address counter
    output decac, // decrement address counter

    output reswc, // reset word count counter
    output plwc, // parallel load word count counter
    output enwc, // enable count word counter
    output incwc, // increment word counter
    output decwc // decrement word counter
);

    wire [1: 0] ctrl_mode;
    
    assign ctrl_mode = control[1: 0];

	// REGS
    assign plar = instruction == 5;
    assign plwcr = instruction == 6;
    assign plcr = instruction == 0;
    
    // MUXS
    assign sela = instruction == 4;
    assign selw = instruction == 4;
    assign seld = instruction[1: 0] - 1;
    
    // ADDR CNT
    assign resac = 0;
    assign plac = instruction[2: 1] == 'b10;
    assign enac = instruction == 7;
    assign incac = ~ control[2];
    assign decac = control[2];
    
    // WRD CNT
    assign reswc = instruction == 4 & ctrl_mode == 1
    				| instruction == 6 & ctrl_mode == 1;
    assign plwc = instruction[2] & ~ instruction[0];
    assign enwc = instruction == 7 & ctrl_mode != 2;
    assign incwc = ctrl_mode[0];
    assign decwc = ctrl_mode == 0;

endmodule // InstructionDecoder
