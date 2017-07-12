/******************************************************************
* Description
*	Forward Unit
* Author:
*	Sergio Chung/Daniel Barragan
* Date:
*	08/07/2017
******************************************************************/

module ForwardUnit 
(
	input [4:0] Rs,
	input [4:0] Rt,
	input EXMEM_RegWrite,
	input MEMWB_RegWrite,
	input [4:0] EXMEM_WriteRegister, //Rd
	input [4:0] MEMWB_WriteRegister, //Rd
	output reg [1:0]ForwardA,
	output reg [1:0]ForwardB
);


   always @ (Rs or Rt or EXMEM_RegWrite or EXMEM_WriteRegister or MEMWB_RegWrite or MEMWB_WriteRegister )
     begin
		if((EXMEM_RegWrite==1) && (EXMEM_WriteRegister != 0) && (EXMEM_WriteRegister == Rs))
			ForwardA = 2'b10;
		else if((EXMEM_RegWrite==1) && (EXMEM_WriteRegister != 0) && (EXMEM_WriteRegister == Rt))
			ForwardB = 2'b10;
		else if((MEMWB_RegWrite == 1) && (MEMWB_WriteRegister != 0) && (EXMEM_WriteRegister != Rs) && (MEMWB_WriteRegister == Rs))
			ForwardA = 2'b01;
		else if( (MEMWB_RegWrite == 1) && (MEMWB_WriteRegister != 0) && (EXMEM_WriteRegister != Rt) && (MEMWB_WriteRegister ==Rt))
			ForwardB = 2'b01;
		else 
			begin
			ForwardA = 2'b00;
			ForwardB = 2'b00;
			end
	  end 
	  
endmodule 