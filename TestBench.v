`include "Headers/Lengths.v"

module TestBench;
    reg clk;
	wire oed;
	reg oena;
	reg cinac;
	reg cinwc;
	reg [`INSTR_LENGTH - 1: 0] instruction;
	reg [`DATA_LENGTH - 1: 0] load_data;
	wire [`DATA_LENGTH - 1: 0] data;
	wire [`DATA_LENGTH - 1: 0] output_address;
	wire conac;
	wire conwc;
	wire done;
	wire done_or_not_conwc;
	
    
    AM2940_top AM2940_top(
        .clk(clk),
        .oena(oena),
        .cinac(cinac),
        .cinwc(cinwc),
        .instruction(instruction),
        // INOUTS
        .data(data),
        // OUTPUTS
        .output_address(output_address),
        .conac(conac),
        .conwc(conwc),
        .done(done)
    );


    initial begin
        clk <= 0;
        forever #10 clk = ~clk;
    end
    
    assign oed = instruction == 0
    				| instruction == 5
    				| instruction == 6;
    				
    assign data = oed ? load_data : 'hZZ;
    
    assign done_or_not_conwc = done | ~ conwc;
    
    initial begin
    	oena <= 1;
    	cinac <= 0;
    	cinwc <= 0;
    	
    	// 0 -> control
    	instruction <= 0;
    	load_data <= 0;
    	
    	#10
    	// citeste control
    	instruction <= 1;
    	
    	#20
    	// 9 -> wc, wcr
    	instruction <= 6;
    	load_data <= 9;
    	
    	#20
    	// 15 -> ac, ar
    	instruction <= 5;
    	load_data <= 15;
       	
       	#20
       	// citeste word counter
       	instruction <= 2;
       	
       	#20
       	// citeste address counter
       	instruction <= 3;
    	
    	#20
    	// en counters, oena
    	instruction <= 7;
    	oena <= 0;
    	
    	// genereaza 15 - 23 si sa semnaleze done odata cu 23
       	#180
    	// 101 -> control
    	instruction <= 0;
    	load_data <= 5;
       	oena <= 1;
       	
       	#20 
       	// reinitialize counters
       	instruction <= 4;
    	
    	#20
    	// en counters, oena
    	instruction <= 7;
    	oena <= 0;
    	
    	#180
       	// 2 -> control
       	instruction <= 0;
    	load_data <= 2;
       	oena <= 1;
       	
       	#20
       	// 5 -> address counter
       	instruction <= 5;
       	load_data <= 'hfe;
       	
       	#20
       	// 10 -> word counter
       	instruction <= 6;
       	load_data <= 2;
    	
    	#20
    	instruction <= 7;
    	oena <= 0;
    	
    	#100
    	// 7 -> control
       	instruction <= 0;
    	load_data <= 7;
       	oena <= 1;
       	
       	#20
       	// 5 -> address counter
       	instruction <= 5;
       	load_data <= 'h7;
       	
       	#20
       	// 10 -> word counter
       	instruction <= 6;
       	load_data <= 'hF0;
    	
    	#20
    	instruction <= 7;
    	oena <= 0;
    	
    	#340
    	instruction <= 0;
    	load_data <= 1;
    	oena <= 1;
    	
    end

    initial begin
        $dumpfile("TestBench.vcd");
        $dumpvars(0, TestBench);
        
        #2000
        $finish;
    end
endmodule // TestBench
