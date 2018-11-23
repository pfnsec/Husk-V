`ifndef RV32UI_VH
`define RV32UI_VH

`define XLEN 32

/*
//U Type
imm[31:12] rd 0110111 LUI
imm[31:12] rd 0010111 AUIPC

//UJ Type
imm[20|10:1|11|19:12] rd 1101111 JAL

//I Type
imm[11:0] rs1 000 rd 1100111 JALR

imm[11:0] rs1 000 rd 0000011 LB
imm[11:0] rs1 001 rd 0000011 LH
imm[11:0] rs1 010 rd 0000011 LW
imm[11:0] rs1 100 rd 0000011 LBU
imm[11:0] rs1 101 rd 0000011 LHU

imm[11:0] rs1 000 rd 0010011 ADDI
imm[11:0] rs1 010 rd 0010011 SLTI
imm[11:0] rs1 011 rd 0010011 SLTIU
imm[11:0] rs1 100 rd 0010011 XORI
imm[11:0] rs1 110 rd 0010011 ORI
imm[11:0] rs1 111 rd 0010011 ANDI

//Also I Type (ewww...)
0000000 shamt rs1 001 rd 0010011 SLLI
0000000 shamt rs1 101 rd 0010011 SRLI
0100000 shamt rs1 101 rd 0010011 SRAI

csr rs1 001 rd 1110011 CSRRW
csr rs1 010 rd 1110011 CSRRS
csr rs1 011 rd 1110011 CSRRC

csr zimm 101 rd 1110011 CSRRWI
csr zimm 110 rd 1110011 CSRRSI
csr zimm 111 rd 1110011 CSRRCI

//SB Type
imm[12|10:5] rs2 rs1 000 imm[4:1|11] 1100011 BEQ
imm[12|10:5] rs2 rs1 001 imm[4:1|11] 1100011 BNE
imm[12|10:5] rs2 rs1 100 imm[4:1|11] 1100011 BLT
imm[12|10:5] rs2 rs1 101 imm[4:1|11] 1100011 BGE
imm[12|10:5] rs2 rs1 110 imm[4:1|11] 1100011 BLTU
imm[12|10:5] rs2 rs1 111 imm[4:1|11] 1100011 BGEU


//S Type
imm[11:5] rs2 rs1 000 imm[4:0] 0100011 SB
imm[11:5] rs2 rs1 001 imm[4:0] 0100011 SH
imm[11:5] rs2 rs1 010 imm[4:0] 0100011 SW


//R Type
0000000 rs2 rs1 000 rd 0110011 ADD
0100000 rs2 rs1 000 rd 0110011 SUB
0000000 rs2 rs1 001 rd 0110011 SLL
0000000 rs2 rs1 010 rd 0110011 SLT
0000000 rs2 rs1 011 rd 0110011 SLTU
0000000 rs2 rs1 100 rd 0110011 XOR
0000000 rs2 rs1 101 rd 0110011 SRL
0100000 rs2 rs1 101 rd 0110011 SRA
0000000 rs2 rs1 110 rd 0110011 OR
0000000 rs2 rs1 111 rd 0110011 AND

//U Type
0000 pred succ 00000 000 00000 0001111 FENCE
0000 0000 0000 00000 001 00000 0001111 FENCE.I

000000000000 00000 000 00000 1110011 ECALL
000000000001 00000 000 00000 1110011 EBREAK

*/


//U Type
`define OPC_LUI     7'b0110111 
`define OPC_AUIPC   7'b0010111 
`define OPC_FENCE   7'b0001111 

`define OPC_ECALL   7'b1110011 

//UJ Type
`define OPC_JAL     7'b1101111 

//I Type
`define OPC_JALR    7'b1100111 
`define FUNCT3_JALR 3'b000


`define OPC_LOAD   7'b0000011 

`define FUNCT3_LB  3'b000
`define FUNCT3_LH  3'b001
`define FUNCT3_LW  3'b010
`define FUNCT3_LBU 3'b100
`define FUNCT3_LHU 3'b101


`define OPC_IMM 7'b0010011 

`define FUNCT3_ADDI  3'b000
`define FUNCT3_SLTI  3'b010
`define FUNCT3_SLTIU 3'b011
`define FUNCT3_XORI  3'b100
`define FUNCT3_ORI   3'b110
`define FUNCT3_ANDI  3'b111
`define FUNCT3_SLLI  3'b001
`define FUNCT3_SRLI  3'b101
`define FUNCT3_SRAI  3'b101


`define OPC_CSR    7'b1110011 

`define FUNCT3_CSRRW 3'b001
`define FUNCT3_CSRRS 3'b010
`define FUNCT3_CSRRC 3'b011

`define FUNCT3_CSRRWI 3'b101
`define FUNCT3_CSRRSI 3'b110
`define FUNCT3_CSRRCI 3'b111


//SB Type
`define OPC_BRANCH 7'b1100011 

`define FUNCT3_BEQ  3'b000
`define FUNCT3_BNE  3'b001
`define FUNCT3_BLT  3'b100
`define FUNCT3_BGE  3'b101
`define FUNCT3_BLTU 3'b110
`define FUNCT3_BGEU 3'b111


//S Type
`define OPC_STORE  7'b0100011 

`define FUNCT3_SB 3'b000
`define FUNCT3_SH 3'b001
`define FUNCT3_SW 3'b010


//R Type
`define OPC_REG  7'b0110011 

`define FUNCT7_ADD 7'b0000000 
`define FUNCT3_ADD 3'b000 

`define FUNCT7_SUB 7'b0100000 
`define FUNCT3_SUB 3'b000 

`define FUNCT7_SLL 7'b0000000 
`define FUNCT3_SLL 3'b001 

`define FUNCT7_SLT 7'b0000000 
`define FUNCT3_SLT 3'b010 

`define FUNCT7_SLTU 7'b0000000 
`define FUNCT3_SLTU 3'b011 

`define FUNCT7_XOR 7'b0000000 
`define FUNCT3_XOR 3'b100 

`define FUNCT7_SRL 7'b0000000 
`define FUNCT3_SRL 3'b101 

`define FUNCT7_SRA 7'b0100000 
`define FUNCT3_SRA 3'b101 

`define FUNCT7_OR 7'b0000000 
`define FUNCT3_OR 3'b110 

`define FUNCT7_AND 7'b0000000 
`define FUNCT3_AND 3'b111 

`define X0  5'd0
`define X1  5'd1
`define X2  5'd2
`define X3  5'd3
`define X4  5'd4
`define X5  5'd5
`define X6  5'd6
`define X7  5'd7
`define X8  5'd8
`define X9  5'd9
`define X10 5'd10
`define X11 5'd11
`define X12 5'd12
`define X13 5'd13
`define X14 5'd14
`define X15 5'd15
`define X16 5'd16
`define X17 5'd17
`define X18 5'd18
`define X19 5'd19
`define X20 5'd20
`define X21 5'd21
`define X22 5'd22
`define X23 5'd23
`define X24 5'd24
`define X25 5'd25
`define X26 5'd26
`define X27 5'd27
`define X28 5'd28
`define X29 5'd29
`define X30 5'd30
`define X31 5'd31


`endif
