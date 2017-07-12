/******************************************************************
* Description
*	This is a  an adder that can be parameterized in its bit-width.
*	1.0
* Author:
*	Sergio Chung/ Daniel Barragan
* Date:
*	28/06/17
******************************************************************/

module AdderJump
#
(
	parameter NBits=32
)
(
	input [3:0] Data0,
	input [27:0] Data1,
	
	output [NBits-1:0] Result
);

assign Result = {Data0[3:0], Data1[27:0]};


endmodule