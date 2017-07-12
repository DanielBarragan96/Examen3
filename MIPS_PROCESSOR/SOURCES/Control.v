/******************************************************************
* Description
*	This is control unit for the MIPS processor. The control unit is 
*	in charge of generation of the control signals. Its only input 
*	corresponds to opcode from the instruction.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/
module Control
(
	input [5:0]OP,
	input [5:0]funct,//agregamos funct para saber si la instruccion es JR
	output RegDst,
	output BranchEQ,
	output BranchNE,
	output JRControl,
	output MemRead,
	output MemtoReg,
	output MemWrite,
	output ALUSrc,
	output RegWrite,
	output Jump,
	output JAL,
	output [2:0]ALUOp
);
localparam R_Type = 0;
localparam I_Type_ADDI = 6'h8;
localparam I_Type_ANDI = 6'h0c;
localparam I_Type_ORI = 6'h0d;
localparam I_Type_LUI = 6'h0f;
localparam I_Type_BEQ = 6'h4;
localparam I_Type_BNE = 6'h5;
localparam J_Type_JUMP = 6'h2;
localparam R_Type_JR = 6'h8;
localparam I_Type_LW = 6'h23;
localparam I_Type_SW = 6'h2b;
localparam J_Type_JAL = 6'h3;

reg [13:0] ControlValues;

always@(OP or funct) begin
	casex(OP)
		R_Type:       ControlValues=(funct==R_Type_JR) ? 14'b1_001_00_00_01_0_111 : 14'b1_001_00_00_00_0_111;//con el funct comparamos si activar o no JR
		I_Type_ADDI:  ControlValues= 14'b0_101_00_00_00_0_100;
		I_Type_ANDI:  ControlValues= 14'b0_101_00_00_00_0_011;
		I_Type_ORI:	  ControlValues= 14'b0_101_00_00_00_0_101;	
		I_Type_LUI:	  ControlValues= 14'b0_101_00_00_00_0_001;
		I_Type_BEQ:	  ControlValues= 14'bx_0x0_x0_01_00_0_010;
		I_Type_BNE:	  ControlValues= 14'bx_0x0_x0_10_00_0_110;
		J_Type_JUMP:  ControlValues= 14'bx_xx0_x0_00_10_0_xxx;
		I_Type_LW:	  ControlValues= 14'b0_111_10_00_00_0_100;
		I_Type_SW:	  ControlValues= 14'bx_1x0_01_00_00_0_100;
		J_Type_JAL:   ControlValues= 14'bx_xx1_x0_00_00_1_xxx;
		
		default:
						  ControlValues= 14'b0000_0000_0000_00;
		endcase
	
end

	
assign RegDst = ControlValues[13];
assign ALUSrc = ControlValues[12];
assign MemtoReg = ControlValues[11];
assign RegWrite = ControlValues[10];
assign MemRead = ControlValues[9];
assign MemWrite = ControlValues[8];
assign BranchNE = ControlValues[7];
assign BranchEQ = ControlValues[6];
assign Jump = ControlValues[5];
assign JRControl = ControlValues[4];
assign JAL = ControlValues[3];
assign ALUOp = ControlValues[2:0];	

endmodule


