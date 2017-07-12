/******************************************************************
* Description
*	This is the top-level of a MIPS processor that can execute the next set of instructions:
*		add
*		addi
*		sub
*		ori
*		or
*		bne
*		beq
*		and
*		nor
* This processor is written Verilog-HDL. Also, it is synthesizable into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be execute. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer organization class at ITESO.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	12/06/2016
******************************************************************/


module MIPS_Processor
#(
	parameter MEMORY_DEPTH = 256
)

(
	// Inputs
	input clk,
	input reset,
	input [7:0] PortIn,
	// Output
	output [31:0] ALUResultOut,
	output [31:0] PortOut
);
//******************************************************************/
//******************************************************************/
assign  PortOut = 0;

//******************************************************************/
//******************************************************************/
// Data types to connect modules
wire BranchNE_wire;
wire BranchEQ_wire;
wire RegDst_wire;
wire NotZeroANDBrachNE;
wire ZeroANDBrachEQ;
wire ORForBranch;
wire ALUSrc_wire;
wire RegWrite_wire;
wire Zero_wire;
wire Mem_Read;
wire Memto_Reg;
wire Mem_Write;
wire [1:0] ForwardA_wire;
wire [1:0] ForwardB_wire;
wire [31:0] Mem_ReadData;
wire [31:0] MuxWR;//Salida del multiplexor de DataMemory
wire [31:0] ShiftLeft2_wire;
wire [27:0] ShiftLeft2_wire1;
wire [31:0] PCBranch_wire;
wire [31:0] PCJump_wire;
wire [31:0] PCJAL_wire;
wire [31:0] BPC_wire;
wire AND_wire;
wire [31:0]A_wire;
wire B_wire;
wire [31:0] C_wire;
wire [31:0] D_wire;
wire [31:0] E_wire;
wire JAL_wire;
wire J_wire;
wire JR_C; //wire de jr control para el multiplexor de jr
wire [2:0] ALUOp_wire;
wire [3:0] ALUOperation_wire;
wire [4:0] WriteRegister_wire;
wire [4:0] WriteRegister_Wire;
wire [4:0] EXMEM_WriteRegister_Wire;
wire [4:0] MEMWB_WriteRegister_Wire;
wire [31:0] MUX_PC_wire;
wire [31:0] PC_wire;
wire [31:0] Instruction_wire;
wire [31:0] ReadData1_wire;
wire [31:0] ReadData2_wire;
wire [31:0] InmmediateExtend_wire;
wire [31:0] ReadData2OrInmmediate_wire;
wire [31:0] ALUResult_wire;
wire [31:0] PC_4_wire;
wire [31:0] InmmediateExtendAnded_wire;
wire [31:0] PCtoBranch_wire;

wire [31:0] IFID_PC;
wire [31:0] IDEX_PC;
wire [31:0] EXMEM_PC;
wire [31:0] MEMWB_PC;
wire [31:0] IFID_Instrucion;
wire [31:0] IDEX_Instrucion;
wire [31:0] IDEX_InmmediateExtend_wire;
wire [31:0] IDEX_ReadData1_wire;
wire [31:0] IDEX_ReadData2_wire;
wire [31:0] EXMEM_ReadData1_wire;
wire [31:0] EXMEM_ReadData2_wire;
wire [31:0] IDEX_ALUResult_wire;
wire [31:0] EXMEM_ALUResult_wire;
wire [31:0] MEMWB_ALUResult_wire;
wire [31:0] IDEX_Zero_wire;
wire [4:0] EXMEM_WriteRegister_wire;
wire [4:0] MEMWB_WriteRegister_wire;
wire [31:0] EXMEM_JUPMwire;
wire [31:0] IDEX_JUMPwire;
wire [31:0] EXMEM_ANDBranch;
wire [31:0] MEMWB_MuxRegDst;
wire [31:0] EXMEM_MuxRegDst;
wire [31:0] EXMEM_BranchAdder;
wire [31:0] EXMEM_Zero;
wire [31:0] MEMWB_ALUResult;
wire [31:0] EXMEM_ALUResult;
wire [31:0] IDEX_SignExtend;
wire [31:0] EXMEM_Rt;
wire [31:0] EXMEM_Rs;
wire [31:0] IDEX_Rt;
wire [31:0] IDEX_Rs;
wire [31:0] IDEX_Instruction;
wire [31:0] IFID_Instruction;
wire [31:0] IDEX_PCBranch_wire;
wire [31:0] EXMEM_PCBranch_wire;
wire [31:0] IDEX_PCJump_wire;
wire [31:0] EXMEM_PCJump_wire;
wire [31:0] MEMWB_Mem_ReadData;


wire IDEX_Memto_Reg;
wire EXMEM_Memto_Reg;
wire MEMWB_Memto_Reg;
wire IDEX_JAL_wire;
wire EXMEM_JAL_wire;
wire MEMWB_JAL_wire;
wire IDEX_RegWrite_wire;
wire EXMEM_RegWrite_wire;
wire MEMWB_RegWrite_wire;
wire IDEX_Mem_Read;
wire EXMEM_Mem_Read;
wire IDEX_Mem_Write;
wire EXMEM_Mem_Write;
wire IDEX_J_wire;
wire EXMEM_J_wire;
wire IDEX_JR_C;
wire EXMEM_JR_C;
wire IDEX_RegDst_wire;
wire [2:0] IDEX_ALUOp_wire;
wire IDEX_BranchNE_wire;
wire IDEX_BranchEQ_wire;
wire IDEX_ALUSrc_wire;

wire [31:0] ALURs_wire;
wire [31:0] ALURt_wire;
wire [31:0] EXMEM_ALURt_wire;
wire DU_Selector_wire;
wire IFID_Write_wire;
wire PCWrite_wire;
integer ALUStatus;


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
ControlUnit
(
	.MemRead(Mem_Read),
	.MemtoReg(Memto_Reg),
	.MemWrite(Mem_Write),
	.OP(IFID_Instrucion[31:26]),
	.funct(IFID_Instrucion[5:0]),
	.RegDst(RegDst_wire),
	.BranchNE(BranchNE_wire),
	.BranchEQ(BranchEQ_wire),
	.ALUOp(ALUOp_wire),
	.ALUSrc(ALUSrc_wire),
	.RegWrite(RegWrite_wire),
	.JRControl(JR_C),
	.Jump(J_wire),
	.JAL(JAL_wire)
);

PC_Register
ProgramCounter
(
	.clk(clk),
	.reset(reset),
	.stop(PCWrite_wire),
	.NewPC(BPC_wire),
	.PCValue(PC_wire)
);


Adder32bits
PC_Puls_4
(
	.Data0(PC_wire),
	.Data1(32'h4),
	
	.Result(PC_4_wire)
);

RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(MEMWB_RegWrite_wire),
	.WriteRegister(MEMWB_WriteRegister_Wire),
	.ReadRegister1(IFID_Instrucion[25:21]),
	.ReadRegister2(IFID_Instrucion[20:16]),
	.WriteData(MuxWR),
	.ReadData1(ReadData1_wire),
	.ReadData2(ReadData2_wire)

);

ForwardUnit
Forward_Unit
(
	.Rs(IDEX_Instrucion[25:21]),
	.Rt(IDEX_Instrucion[20:16]),
	.EXMEM_RegWrite(EXMEM_RegWrite_wire),
	.MEMWB_RegWrite(MEMWB_RegWrite_wire),
	.EXMEM_WriteRegister(EXMEM_WriteRegister_Wire),
	.MEMWB_WriteRegister(MEMWB_WriteRegister_Wire),
	.ForwardA(ForwardA_wire),
	.ForwardB(ForwardB_wire)
);

HazardUnit
Hazard_Unit
(
	.Rs(IFID_Instrucion[25:21]),
	.Rt(IFID_Instrucion[20:16]),
	.IDEX_MemRead(IDEX_Mem_Read),
	.IDEX_Rt(IDEX_Instrucion[20:16]),
	.DU_Selector(DU_Selector_wire),
	.IFID_Write(IFID_Write_wire),
	.PCWrite(PCWrite_wire)
	
);

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
Register
#(
	.N(32)
)
Register_IFID_PC
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(PC_4_wire),
	.DataOutput(IFID_PC)

);


Register
#(
	.N(32)
)
Register_IDEX_PC
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(IFID_PC),
	.DataOutput(IDEX_PC)

);


Register
#(
	.N(32)
)
Register_EXMEM_PC
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(IDEX_PC),
	.DataOutput(EXMEM_PC)

);
 
Register
#(
	.N(32)
)
Register_IFID_Instruction
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(Instruction_wire[31:0]),
	.DataOutput(IFID_Instrucion)

);


Register
#(
	.N(32)
)
Register_IDEX_Instruction
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(IFID_Instrucion),
	.DataOutput(IDEX_Instrucion)

);

Register
#(
	.N(32)
)
Register_IDEX_Rs
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(ReadData1_wire),
	.DataOutput(IDEX_ReadData1_wire)

);

Register
#(
	.N(32)
)
Register_IDEX_Rt
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(ReadData2_wire),
	.DataOutput(IDEX_ReadData2_wire)

);

Register
#(
	.N(32)
)
Register_EXMEM_Rs
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(IDEX_ReadData1_wire),
	.DataOutput(EXMEM_ReadData1_wire)

);

Register
#(
	.N(32)
)
Register_EXMEM_Rt
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(IDEX_ReadData2_wire),
	.DataOutput(EXMEM_ReadData2_wire)

);

Register
#(
	.N(32)
)
Register_IDEX_SignExtend
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(InmmediateExtend_wire),
	.DataOutput(IDEX_InmmediateExtend_wire)

);


Register
#(
	.N(32)
)
Register_EXMEM_ALUResult
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(ALUResult_wire),
	.DataOutput(EXMEM_ALUResult_wire)

);

Register
#(
	.N(32)
)
Register_MEMWB_ALUResult
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(EXMEM_ALUResult_wire),
	.DataOutput(MEMWB_ALUResult_wire)

);

Register
#(
	.N(1)
)
Register_EXMEM_Zero
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(Zero_wire),
	.DataOutput(EXMEM_Zero_wire)

);

Register
#(
	.N(32)
)
Register_IDEX_BranchAdder
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(PCBranch_wire),
	.DataOutput(IDEX_PCBranch_wire)

);

Register
#(
	.N(32)
)
Register_EXMEM_BranchAdder
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(IDEX_PCBranch_wire),
	.DataOutput(EXMEM_PCBranch_wire)

);


Register
#(
	.N(5)
)
Register_EXMEM_MuxRegDst
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(WriteRegister_wire),
	.DataOutput(EXMEM_WriteRegister_wire)

);

Register
#(
	.N(5)
)
Register_MEMWB_MuxRegDst
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(EXMEM_WriteRegister_wire),
	.DataOutput(MEMWB_WriteRegister_wire)

);


Register
#(
	.N(1)
)
Register_EXMEM_ANDBranch
(
	.clk(~clk),
	.reset(reset),
   .enable(1'b1),
	.DataInput(B_wire),
	.DataOutput(EXMEM_B_wire)

);

Register
#(
	.N(32)
)
Register_IDEX_JUMPwire
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(PCJump_wire),
	.DataOutput(IDEX_PCJump_wire)

);

Register
#(
	.N(32)
)
Register_EXMEM_JUMPwire
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(IDEX_PCJump_wire),
	.DataOutput(EXMEM_PCJump_wire)

);

Register
#(
	.N(32)
)
Register_MEMWB_LW
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(Mem_ReadData),
	.DataOutput(MEMWB_Mem_ReadData)

);

Register
#(
	.N(5)
)
Register_EXMEM_WriteRegister_Wire
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(WriteRegister_Wire),
	.DataOutput(EXMEM_WriteRegister_Wire)

);

Register
#(
	.N(5)
)
Register_MEMWB_WriteRegister_Wire
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(EXMEM_WriteRegister_Wire),
	.DataOutput(MEMWB_WriteRegister_Wire)

);

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

Register
#(
	.N(1)
)
Register_IDEX_RegWrite
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(RegWrite_wire1),
	.DataOutput(IDEX_RegWrite_wire)

);

Register
#(
	.N(1)
)
Register_EXMEM_RegWrite
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(IDEX_RegWrite_wire),
	.DataOutput(EXMEM_RegWrite_wire)

);

Register
#(
	.N(1)
)
Register_MEMWB_RegWrite
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(EXMEM_RegWrite_wire),
	.DataOutput(MEMWB_RegWrite_wire)

);

Register
#(
	.N(1)
)
Register_IDEX_MemtoReg
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(Memto_Reg1),
	.DataOutput(IDEX_Memto_Reg)

);

Register
#(
	.N(1)
)
Register_EXMEM_MemtoReg
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(IDEX_Memto_Reg),
	.DataOutput(EXMEM_Memto_Reg)

);

Register
#(
	.N(1)
)
Register_MEMWB_MemtoReg
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(EXMEM_Memto_Reg),
	.DataOutput(MEMWB_Memto_Reg)

);


Register
#(
	.N(1)
)
Register_IDEX_jal
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(JAL_wire),
	.DataOutput(IDEX_JAL_wire)

);

Register
#(
	.N(1)
)
Register_EXMEM_jal
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(IDEX_JAL_wire),
	.DataOutput(EXMEM_JAL_wire)

);

Register
#(
	.N(1)
)
Register_MEMWB_jal
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(EXMEM_JAL_wire),
	.DataOutput(MEMWB_JAL_wire)

);


Register
#(
	.N(1)
)
Register_IDEX_Mem_Read
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(Mem_Read1),
	.DataOutput(IDEX_Mem_Read)

);

Register
#(
	.N(1)
)
Register_EXMEM_Mem_Read
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(IDEX_Mem_Read),
	.DataOutput(EXMEM_Mem_Read)

);


Register
#(
	.N(1)
)
Register_IDEX_Mem_Write
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(Mem_Write1),
	.DataOutput(IDEX_Mem_Write)

);

Register
#(
	.N(1)
)
Register_EXMEM_Mem_Write
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(IDEX_Mem_Write),
	.DataOutput(EXMEM_Mem_Write)

);

Register
#(
	.N(1)
)
Register_IDEX_JR_C
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(JR_C),
	.DataOutput(IDEX_JR_C)

);

Register
#(
	.N(1)
)
Register_EXMEM_JR_C
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(IDEX_JR_C),
	.DataOutput(EXMEM_JR_C)

);
	
Register
#(
	.N(1)
)
Register_IDEX_J_wire
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(J_wire),
	.DataOutput(IDEX_J_wire)

);

Register
#(
	.N(1)
)
Register_EXMEM_J_wire
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(IDEX_J_wire),
	.DataOutput(EXMEM_J_wire)

);
	
	
Register
#(
	.N(1)
)
Register_IDEX_RegDst
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(RegDst_wire),
	.DataOutput(IDEX_RegDst_wire)

);

Register
#(
	.N(3)
)
Register_IDEX_ALUOp
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(ALUOp_wire),
	.DataOutput(IDEX_ALUOp_wire)

);

Register
#(
	.N(1)
)
Register_IDEX_ALUSrc
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(ALUSrc_wire),
	.DataOutput(IDEX_ALUSrc_wire)

);


Register
#(
	.N(1)
)
Register_IDEX_BranchNE_wire
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(BranchNE_wire),
	.DataOutput(IDEX_BranchNE_wire)

);

Register
#(
	.N(1)
)
Register_IDEX_BranchEQ_wire
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(BranchEQ_wire),
	.DataOutput(IDEX_BranchEQ_wire)

);

Register
#(
	.N(32)
)
Register_EXMEM_ALURt_wire
(
	.clk(~clk),
	.reset(reset),
	.enable(1'b1),
	.DataInput(ALURt_wire),
	.DataOutput(EXMEM_ALURt_wire)

);


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
ProgramMemory
#(
	.MEMORY_DEPTH(MEMORY_DEPTH)
)
ROMProgramMemory
(
	.Address(PC_wire),
	.stop(IFID_Write_wire),
	.Instruction(Instruction_wire)
);

DataMemory//Nuevo
MemoriaRAM
(
	.WriteData(EXMEM_ALURt_wire), //EXMEM_ReadData2_wire
	.Address(EXMEM_ALUResult_wire),
	.MemWrite(EXMEM_Mem_Write),
	.MemRead(EXMEM_Mem_Read),
	.clk(clk),
	.ReadData(Mem_ReadData)	
);	

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////


Multiplexer2to1
#(
	.NBits(32)
)
MUX_DataMemory//si la intruccion no hace uso de memoria pasa ALUResult
(
	.Selector(MEMWB_Memto_Reg),
	.MUX_Data0(MEMWB_ALUResult_wire),
	.MUX_Data1(MEMWB_Mem_ReadData),
	
	.MUX_Output(MuxWR)

);

/*
Multiplexer2to1
#(
	.NBits(32)
)
MUX_WriteData_JAL//si la instruccion es JAL, se guarda el valor de PC+4
(
	.Selector(MEMWB_JAL_wire),
	.MUX_Data0(E_wire),
	.MUX_Data1(EXMEM_PC),
	
	.MUX_Output(MuxWR)

);
*/
////////////////////////////////////////////////////////////////////////////////////////////



Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForRTypeAndIType//Multiplexor para Rt y Rd
(
	.Selector(IDEX_RegDst_wire),
	.MUX_Data0(IDEX_Instrucion[20:16]),
	.MUX_Data1(IDEX_Instrucion[15:11]),
	
	.MUX_Output(WriteRegister_Wire)

);

/*
Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForRTypeAndIType_JAL//Multiplexor para el resultado del pasado y si la instruccion es JAL, se guarda R31(ra)
(
	.Selector(MEMWB_JAL_wire),
	.MUX_Data0(MEMWB_WriteRegister_wire),
	.MUX_Data1(5'b11111),
	
	.MUX_Output(WriteRegister_Wire)

);

*/
/////////////////////////////////////////////////////////////////////////////////////////

SignExtend
SignExtendForConstants
(   
	.DataInput(IFID_Instrucion[15:0]),
   .SignExtendOutput(InmmediateExtend_wire)
);


ShiftLeft2
Shifter_Branch
(
	.DataInput(IDEX_InmmediateExtend_wire),
	.DataOutput(ShiftLeft2_wire)
);


Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForReadDataAndInmediate
(
	.Selector(IDEX_ALUSrc_wire),
	.MUX_Data0(ALURt_wire),
	.MUX_Data1(IDEX_InmmediateExtend_wire),
	
	.MUX_Output(ReadData2OrInmmediate_wire)

);

Adder32bits
PCBranch//adder PC+signextended para ir al mux del branch
(
	.Data0(IDEX_PC),
	.Data1(ShiftLeft2_wire),
	
	.Result(PCBranch_wire)
);

ShiftLeft16bit
ShifterJump//hacemos shift de 26bits, para la operacion del jump que se concatena con la parte alta de PC
(
	.DataInput(IFID_Instrucion[25:0]),
	.DataOutput(ShiftLeft2_wire1)
);

/*
AdderJump
PCJump//concatenamos la parte alta con la instrucción de 28bits (despues del shift left)
(
	.Data0(IFID_PC[31:28]),
	.Data1(ShiftLeft2_wire1),
	
	.Result(PCJump_wire)
);
*/

Multiplexer2to1
#(
	.NBits(1)
)
MUX_ForBEQ_BNE//vemos si se va a usar BEQ o BNE 
(
	.Selector(IDEX_BranchEQ_wire),
	.MUX_Data0(IDEX_BranchNE_wire),
	.MUX_Data1(IDEX_BranchEQ_wire),
	
	.MUX_Output(B_wire)

);

ANDGate
BranchANDZero//and del branch
(
	.A(EXMEM_Zero_wire),
	.B(EXMEM_B_wire),
	.C(AND_wire)
	
);


Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForPC_Shifter//si la intruccion no es branch, pasa el PC+4
(
	.Selector(AND_wire),
	.MUX_Data0(PC_4_wire), //EXMEM_PC
	.MUX_Data1(EXMEM_PCBranch_wire),
	
	.MUX_Output(BPC_wire)  //C_wire

);
/*

Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForJR//si la instruccion es JR, se pasa lo que contenga Rs, si no pasa PC+4
(
	.Selector(EXMEM_JR_C),
	.MUX_Data0(C_wire),
	.MUX_Data1(EXMEM_ReadData1_wire),
	
	.MUX_Output(D_wire)

);


Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForJ//si la instruccion es JR, se pasa el valor concatenado del signextend + PC+4
(
	.Selector(EXMEM_J_wire),
	.MUX_Data0(D_wire),
	.MUX_Data1(EXMEM_PCJump_wire),
	
	.MUX_Output(A_wire)

);


Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForPC_JAL//si la instruccion es JAL, pasamos la direccion del jump
(
	.Selector(EXMEM_JAL_wire),
	.MUX_Data0(A_wire),
	.MUX_Data1(EXMEM_PCJump_wire),
	
	.MUX_Output(BPC_wire)

);

*/

ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(IDEX_ALUOp_wire),
	.ALUFunction(IDEX_Instrucion[5:0]),
	.ALUOperation(ALUOperation_wire)

);



ALU
ArithmeticLogicUnit 
(
	.ALUOperation(ALUOperation_wire),
	.A(ALURs_wire),
	.B(ReadData2OrInmmediate_wire),
	.C(IDEX_Instrucion[10:6]),
	.Zero(Zero_wire),
	.ALUResult(ALUResult_wire)
);

assign ALUResultOut = ALUResult_wire;

Multiplexor3to1
#(
	.NBits(32)
)
MUX_ForForwardA//Multiplexor ForwardUnit
(
	.Selector(ForwardA_wire),
	.MUX_Data0(IDEX_ReadData1_wire),
	.MUX_Data1(EXMEM_ALUResult_wire),
	.MUX_Data2(MuxWR),
	
	.MUX_Output(ALURs_wire)

);


Multiplexor3to1
#(
	.NBits(32)
)
MUX_ForForwardB//Multiplexor ForwardUnit
(
	.Selector(ForwardB_wire),
	.MUX_Data0(IDEX_ReadData2_wire),
	.MUX_Data1(EXMEM_ALUResult_wire),
	.MUX_Data2(MuxWR),
	
	.MUX_Output(ALURt_wire)

);

Multiplexer2to1Reg
MUX_IDEXRegWrite
(
	.Selector(DU_Selector_wire),
	.MUX_Data0(RegWrite_wire),
	.MUX_Data1(1'b0),
	
	.MUX_Output(RegWrite_wire1)

);

Multiplexer2to1Reg
MUX_IDEXMemWrite
(
	.Selector(DU_Selector_wire),
	.MUX_Data0(Mem_Write),
	.MUX_Data1(1'b0),
	
	.MUX_Output(Mem_Write1)

);

Multiplexer2to1Reg
MUX_IDEXMemRead
(
	.Selector(DU_Selector_wire),
	.MUX_Data0(Mem_Read),
	.MUX_Data1(1'b0),
	
	.MUX_Output(Mem_Read1)

);

Multiplexer2to1Reg
MUX_IDEXMemtoReg
(
	.Selector(DU_Selector_wire),
	.MUX_Data0(Memto_Reg),
	.MUX_Data1(1'b0),
	
	.MUX_Output(Memto_Reg1)

);
endmodule

