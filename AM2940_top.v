`include "Headers/Lengths.v"

module AM2940_top (
    input clk,
    input oena, // output enable neg address
    
    input cinac, // carry in neg address counter
    input cinwc, // carry in neg word count counter
    
    input [`INSTR_LENGTH - 1: 0] instruction,
    
    inout [`DATA_LENGTH - 1: 0] data,
     
    output [`DATA_LENGTH - 1: 0] output_address,
    
    output conac, // carry out neg address counter
    output conwc, // carry out neg word count counter
    
    output done
);
    
    wire [`DATA_LENGTH - 1: 0] address;
    wire [`DATA_LENGTH - 1: 0] word_cnt;
    wire [`CTRL_LENGTH - 1: 0] control;

    wire [`DATA_LENGTH - 1: 0] sel_address; // selected address
    wire [`DATA_LENGTH - 1: 0] sel_word_cnt; // selected word count
    
    wire [`DATA_LENGTH - 1: 0] next_address;
    wire [`DATA_LENGTH - 1: 0] next_word_cnt;
    
    wire plar; // parallel load address reg
    wire plwcr; // parallel load word count reg
    wire plcr; // parallel load control reg
    
    wire sela; // select address
    wire selw; // select word count
    wire [1: 0] seld; // select data
    
    wire resac; // reset address counter
    wire plac; // parallel load address counter
    wire enac; // enable count address counter
    wire incac; // increment address counter
    wire decac; // decrement address counter

    wire reswc; // reset word count counter
    wire plwc; // parallel load word count counter
    wire enwc; // enable count word counter
    wire incwc; // increment word counter
    wire decwc; // decrement word counter
    
    wire oed;
    wire [`DATA_LENGTH - 1: 0] sel_data;
    wire [`DATA_LENGTH - 1: 0] next_data;
    
    
    assign oed = ~ instruction[2] & | instruction[1: 0];
    assign data = oed ? sel_data : 'hZZ;
    
    assign oend = instruction == 0
    				| instruction == 5
    				| instruction == 6;
    				
    assign next_data = oend ? data: sel_data;
    
	assign output_address = oena ? 'hZZ : next_address;

	// MODULES
	InstructionDecoder InstructionDecoder (
		.instruction(instruction),
		.control(control),
		// OUTPUTS
		.plar(plar),
		.plwcr(plwcr),
		.plcr(plcr),
		.sela(sela),
		.selw(selw),
		.seld(seld),
		.resac(resac),
		.plac(plac),
		.enac(enac),
		.incac(incac),
		.decac(decac),
		.reswc(reswc),
		.plwc(plwc),
		.enwc(enwc),
		.incwc(incwc),
		.decwc(decwc)
	);
	
    Register AddressRegister (
        .clk(clk),
        .pl(plar),
        .di(next_data),
        // OUTPUTS
        .do(address)
    );

    Register WordCountRegister (
        .clk(clk),
        .pl(plwcr),
        .di(next_data),
        // OUTPUTS
        .do(word_cnt)
    );

    Register #(.DATA_LENGTH(`CTRL_LENGTH)) ControlRegister (
        .clk(clk),
        .pl(plcr),
        .di(next_data[2:0]),
        // OUTPUTS
        .do(control)
    );

    Mux2To1 AddressMux (
        .sel(sela),
        .di0(next_data),
        .di1(address),
        // OUTPUTS
        .do(sel_address)
    );

    Mux2To1 WordCountMux (
        .sel(selw),
        .di0(next_data),
        .di1(word_cnt),
        // OUTPUTS
        .do(sel_word_cnt)
    );

    Mux3To1 DataMux (
        .sel(seld),
        .di0({5'b11111, control}),
        .di1(next_word_cnt),
        .di2(next_address),
        // OUTPUTS
        .do(sel_data)
    );

    Counter AddressCounter (
        .clk(clk),
        .res(resac),
        .pl(plac),
        .en(enac),
        .inc(incac),
        .dec(decac),
        .cin(cinac),
        .di(sel_address),
        // OUTPUTS
        .con(conac),
        .do(next_address)
    );

    Counter WordCountCounter (
        .clk(clk),
        .res(reswc),
        .pl(plwc),
        .en(enwc),
        .inc(incwc),
        .dec(decwc),
        .cin(cinwc),
        .di(sel_word_cnt),
        // OUTPUTS
        .con(conwc),
        .do(next_word_cnt)
    );
    
    TransferCompleteCircuitry TransferCompleteCircuitry (
    	.next_address(next_address),
    	.next_word_cnt(next_word_cnt),
    	.word_cnt(word_cnt),
    	.ctrl_mode(control[1: 0]),
    	.cinwc(cinwc),
    	// OUTPUTS
    	.done(done)
    );

endmodule // AM2940_top

