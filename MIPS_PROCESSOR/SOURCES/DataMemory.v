/******************************************************************
* Description
*	This is the data memory for the MIPS processor
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/

module DataMemory 
#(	parameter DATA_WIDTH=32,
	parameter MEMORY_DEPTH = 256

)
(
	input [DATA_WIDTH-1:0] WriteData,
	input [DATA_WIDTH-1:0]  Address,
	input MemWrite,MemRead, clk,
	output  [DATA_WIDTH-1:0]  ReadData
);
	
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[MEMORY_DEPTH-1:0];
	wire [DATA_WIDTH-1:0] ReadDataAux;
	wire [DATA_WIDTH-1:0] RealAddress;
	wire [DATA_WIDTH-1:0] Address1;
	
	assign Address1 = Address - 'h10010000;
	assign RealAddress = {2'b0, Address1[31:2]};
	

	always @ (posedge clk)
	begin
		// Write
		if (MemWrite)
			ram[RealAddress] <= WriteData;
	end
	assign ReadDataAux = ram[RealAddress];
  	assign ReadData = {DATA_WIDTH{MemRead}}& ReadDataAux;

endmodule
