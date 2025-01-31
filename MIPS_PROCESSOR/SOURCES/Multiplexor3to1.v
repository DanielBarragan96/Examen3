/******************************************************************
* Description
*	Mux 3to1
* Author:
*	Sergio Chung/Daniel Barragan
* Date:
*	08/07/2017
******************************************************************/

module Multiplexor3to1
#(
	parameter NBits=32
)
(
	input [1:0] Selector,
	input [NBits-1:0] MUX_Data0,
	input [NBits-1:0] MUX_Data1,
	input [NBits-1:0] MUX_Data2,
	
	output reg [NBits-1:0] MUX_Output

);

	always@(Selector,MUX_Data1,MUX_Data0) begin
		if(Selector == 'b00)
			MUX_Output = MUX_Data0;
		else if (Selector == 'b10)
			MUX_Output = MUX_Data1;
		else
			MUX_Output = MUX_Data2;
	end

endmodule