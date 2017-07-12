/******************************************************************
* Description
*	Multiplexor para señales de control
* Author:
*	Sergio Chung/Daniel Barragan
* Date:
*	09/07/2017
******************************************************************/

module Multiplexer2to1Reg
(
	input Selector,
	input MUX_Data0,
	input MUX_Data1,
	
	output reg MUX_Output

);

	always@(Selector,MUX_Data1,MUX_Data0) begin
		if(Selector)
			MUX_Output = MUX_Data1;
		else
			MUX_Output = MUX_Data0;
	end

endmodule