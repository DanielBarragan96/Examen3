onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/clk
add wave -noupdate /MIPS_Processor_TB/DUV/Register_File/WriteRegister
add wave -noupdate -divider {PC Counter}
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/ProgramCounter/PCValue
add wave -noupdate -divider t0
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_t0/DataOutput
add wave -noupdate -divider t1
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_t1/DataOutput
add wave -noupdate -divider t2
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_t2/DataOutput
add wave -noupdate -divider t3
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_t3/DataOutput
add wave -noupdate -divider r1
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/Register_at/DataOutput
add wave -noupdate -divider {Register File}
add wave -noupdate -color Yellow -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/WriteData
add wave -noupdate -color Yellow -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/WriteRegister
add wave -noupdate -color Yellow -radix hexadecimal /MIPS_Processor_TB/DUV/Register_File/RegWrite
add wave -noupdate -divider ALU
add wave -noupdate -color {Cornflower Blue} -radix hexadecimal /MIPS_Processor_TB/DUV/ArithmeticLogicUnit/ALUOperation
add wave -noupdate -color {Cornflower Blue} -radix hexadecimal /MIPS_Processor_TB/DUV/ArithmeticLogicUnit/A
add wave -noupdate -color {Cornflower Blue} -radix hexadecimal /MIPS_Processor_TB/DUV/ArithmeticLogicUnit/B
add wave -noupdate -color {Cornflower Blue} -radix hexadecimal /MIPS_Processor_TB/DUV/ArithmeticLogicUnit/C
add wave -noupdate -color {Cornflower Blue} -radix hexadecimal /MIPS_Processor_TB/DUV/ArithmeticLogicUnit/ALUResult
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {50 ps}
