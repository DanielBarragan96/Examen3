/******************************************************************
* Description
*	Hazard Detection Unit
* Author:
*	Sergio Chung/Daniel Barragan
* Date:
*	08/07/2017
******************************************************************/

module HazardUnit 
(
	input [4:0] Rs,
	input [4:0] Rt,
	input IDEX_MemRead,
	input [4:0] IDEX_Rt,
	output reg DU_Selector,
	output reg IFID_Write,
	output reg PCWrite
);


   always @ (Rs or Rt or IDEX_MemRead or IDEX_Rt)
     begin
		if(IDEX_MemRead && ((IDEX_Rt == Rs) || (IDEX_Rt == Rt)))
			begin
			DU_Selector = 1;
			IFID_Write = 1;
			PCWrite = 1;
			end
		else
			DU_Selector = 0;
			IFID_Write = 0;
			PCWrite = 0;
	  end 
	  
endmodule 