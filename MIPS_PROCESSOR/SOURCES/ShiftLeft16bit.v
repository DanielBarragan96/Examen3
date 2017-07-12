/******************************************************************
* Description
*	This performs a shift left opeartion in roder to calculate the brances.
*	1.0
* Author:
*	Sergio Chung/ Daniel Barragan
* Date:
*	28/06/17
******************************************************************/
module ShiftLeft16bit 
(   
	input [25:0]  DataInput,
   output reg [27:0] DataOutput

);
   always @ (DataInput)
     DataOutput = {DataInput[25:0], 1'b0, 1'b0};

endmodule // leftShift2