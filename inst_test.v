`include "rv32ui_def.v"

module inst_test(
	input clk,
	input reset,

	output reg inst_valid,
	input inst_ready,
	output reg [31:0] instr,
	output [31:0] instr_addr,

	input [31:0] brc_target,
	input brc_target_valid

);

	reg [31:0] inst_buf[31:0];

	reg [4:0] addr;
	assign instr_addr = 0 | addr;

	always @(posedge clk) begin
		if(reset) begin

/*
			inst_buf[0]  = {`FUNCT7_ADD, `X9,  `X8,  `FUNCT3_ADD, `X7,  `OPC_REG};
			inst_buf[1]  = {`FUNCT7_ADD, `X8,  `X7,  `FUNCT3_ADD, `X6,  `OPC_REG};
			inst_buf[2]  = {`FUNCT7_ADD, `X7,  `X6,  `FUNCT3_ADD, `X5,  `OPC_REG};
			inst_buf[3]  = {`FUNCT7_ADD, `X6,  `X5,  `FUNCT3_ADD, `X4,  `OPC_REG};
			inst_buf[4]  = {`FUNCT7_ADD, `X5,  `X4,  `FUNCT3_ADD, `X3,  `OPC_REG};
			inst_buf[5]  = {`FUNCT7_ADD, `X4,  `X3,  `FUNCT3_ADD, `X2,  `OPC_REG};
			inst_buf[6]  = {`FUNCT7_ADD, `X3,  `X2,  `FUNCT3_ADD, `X1,  `OPC_REG};
			inst_buf[7]  = {`FUNCT7_ADD, `X2,  `X1,  `FUNCT3_ADD, `X0,  `OPC_REG};
*/

/*
			inst_buf[0 ]  = {`FUNCT7_ADD, `X2,  `X1,  `FUNCT3_ADD, `X0,  `OPC_REG};
			inst_buf[1 ]  = {`FUNCT7_ADD, `X3,  `X2,  `FUNCT3_ADD, `X1,  `OPC_REG};
			inst_buf[2 ]  = {`FUNCT7_ADD, `X4,  `X3,  `FUNCT3_ADD, `X2,  `OPC_REG};
			inst_buf[3 ]  = {`FUNCT7_ADD, `X5,  `X4,  `FUNCT3_ADD, `X3,  `OPC_REG};
			inst_buf[4 ]  = {`FUNCT7_ADD, `X6,  `X5,  `FUNCT3_ADD, `X4,  `OPC_REG};
			inst_buf[5 ]  = {`FUNCT7_ADD, `X7,  `X6,  `FUNCT3_ADD, `X5,  `OPC_REG};
			inst_buf[6 ]  = {`FUNCT7_ADD, `X8,  `X7,  `FUNCT3_ADD, `X6,  `OPC_REG};
			inst_buf[7 ]  = {`FUNCT7_ADD, `X9,  `X8,  `FUNCT3_ADD, `X7,  `OPC_REG};
			inst_buf[8 ]  = {`FUNCT7_ADD, `X10, `X9,  `FUNCT3_ADD, `X8,  `OPC_REG};
			inst_buf[9 ]  = {`FUNCT7_ADD, `X11, `X10, `FUNCT3_ADD, `X9,  `OPC_REG};
			inst_buf[10] = {`FUNCT7_ADD, `X12, `X11, `FUNCT3_ADD, `X10, `OPC_REG};
			inst_buf[11] = {`FUNCT7_ADD, `X13, `X12, `FUNCT3_ADD, `X11, `OPC_REG};
			inst_buf[12] = {`FUNCT7_ADD, `X14, `X13, `FUNCT3_ADD, `X12, `OPC_REG};
			inst_buf[13] = {`FUNCT7_ADD, `X15, `X14, `FUNCT3_ADD, `X13, `OPC_REG};
			inst_buf[14] = {`FUNCT7_ADD, `X16, `X15, `FUNCT3_ADD, `X14, `OPC_REG};
			inst_buf[15] = {`FUNCT7_ADD, `X17, `X16, `FUNCT3_ADD, `X15, `OPC_REG};
			inst_buf[16] = {`FUNCT7_ADD, `X18, `X17, `FUNCT3_ADD, `X16, `OPC_REG};
			inst_buf[17] = {`FUNCT7_ADD, `X19, `X18, `FUNCT3_ADD, `X17, `OPC_REG};
			inst_buf[18] = {`FUNCT7_ADD, `X20, `X19, `FUNCT3_ADD, `X18, `OPC_REG};
			inst_buf[19] = {`FUNCT7_ADD, `X21, `X20, `FUNCT3_ADD, `X19, `OPC_REG};
			inst_buf[20] = {`FUNCT7_ADD, `X22, `X21, `FUNCT3_ADD, `X20, `OPC_REG};
			inst_buf[21] = {`FUNCT7_ADD, `X23, `X22, `FUNCT3_ADD, `X21, `OPC_REG};
			inst_buf[22] = {`FUNCT7_ADD, `X24, `X23, `FUNCT3_ADD, `X22, `OPC_REG};
			inst_buf[23] = {`FUNCT7_ADD, `X25, `X24, `FUNCT3_ADD, `X23, `OPC_REG};
			inst_buf[24] = {`FUNCT7_ADD, `X26, `X25, `FUNCT3_ADD, `X24, `OPC_REG};
			inst_buf[25] = {`FUNCT7_ADD, `X27, `X26, `FUNCT3_ADD, `X25, `OPC_REG};
			inst_buf[26] = {`FUNCT7_ADD, `X28, `X27, `FUNCT3_ADD, `X26, `OPC_REG};
			inst_buf[27] = {`FUNCT7_ADD, `X29, `X28, `FUNCT3_ADD, `X27, `OPC_REG};
			inst_buf[28] = {`FUNCT7_ADD, `X30, `X29, `FUNCT3_ADD, `X28, `OPC_REG};
			inst_buf[29] = {`FUNCT7_ADD, `X31, `X30, `FUNCT3_ADD, `X29, `OPC_REG};
			inst_buf[30] = {`FUNCT7_ADD, `X0,  `X31, `FUNCT3_ADD, `X30, `OPC_REG};
			inst_buf[31] = {`FUNCT7_ADD, `X1,  `X0,  `FUNCT3_ADD, `X31, `OPC_REG};
*/

/*

			inst_buf[31] = {`FUNCT7_ADD, `X2,  `X1,  `FUNCT3_ADD, `X0,  `OPC_REG};
			inst_buf[30] = {`FUNCT7_ADD, `X3,  `X2,  `FUNCT3_ADD, `X1,  `OPC_REG};
			inst_buf[29] = {`FUNCT7_ADD, `X4,  `X3,  `FUNCT3_ADD, `X2,  `OPC_REG};
			inst_buf[28] = {`FUNCT7_ADD, `X5,  `X4,  `FUNCT3_ADD, `X3,  `OPC_REG};
			inst_buf[27] = {`FUNCT7_ADD, `X6,  `X5,  `FUNCT3_ADD, `X4,  `OPC_REG};
			inst_buf[26] = {`FUNCT7_ADD, `X7,  `X6,  `FUNCT3_ADD, `X5,  `OPC_REG};
			inst_buf[25] = {`FUNCT7_ADD, `X8,  `X7,  `FUNCT3_ADD, `X6,  `OPC_REG};
			inst_buf[24] = {`FUNCT7_ADD, `X9,  `X8,  `FUNCT3_ADD, `X7,  `OPC_REG};
			inst_buf[23] = {`FUNCT7_ADD, `X10, `X9,  `FUNCT3_ADD, `X8,  `OPC_REG};
			inst_buf[22] = {`FUNCT7_ADD, `X11, `X10, `FUNCT3_ADD, `X9,  `OPC_REG};
			inst_buf[21] = {`FUNCT7_ADD, `X12, `X11, `FUNCT3_ADD, `X10, `OPC_REG};
			inst_buf[20] = {`FUNCT7_ADD, `X13, `X12, `FUNCT3_ADD, `X11, `OPC_REG};
			inst_buf[19] = {`FUNCT7_ADD, `X14, `X13, `FUNCT3_ADD, `X12, `OPC_REG};
			inst_buf[18] = {`FUNCT7_ADD, `X15, `X14, `FUNCT3_ADD, `X13, `OPC_REG};
			inst_buf[17] = {`FUNCT7_ADD, `X16, `X15, `FUNCT3_ADD, `X14, `OPC_REG};
			inst_buf[16] = {`FUNCT7_ADD, `X17, `X16, `FUNCT3_ADD, `X15, `OPC_REG};
			inst_buf[15] = {`FUNCT7_ADD, `X18, `X17, `FUNCT3_ADD, `X16, `OPC_REG};
			inst_buf[14] = {`FUNCT7_ADD, `X19, `X18, `FUNCT3_ADD, `X17, `OPC_REG};
			inst_buf[13] = {`FUNCT7_ADD, `X20, `X19, `FUNCT3_ADD, `X18, `OPC_REG};
			inst_buf[12] = {`FUNCT7_ADD, `X21, `X20, `FUNCT3_ADD, `X19, `OPC_REG};
			inst_buf[11] = {`FUNCT7_ADD, `X22, `X21, `FUNCT3_ADD, `X20, `OPC_REG};
			inst_buf[10] = {`FUNCT7_ADD, `X23, `X22, `FUNCT3_ADD, `X21, `OPC_REG};
			inst_buf[9]  = {`FUNCT7_ADD, `X24, `X23, `FUNCT3_ADD, `X22, `OPC_REG};
			inst_buf[8]  = {`FUNCT7_ADD, `X25, `X24, `FUNCT3_ADD, `X23, `OPC_REG};
			inst_buf[7]  = {`FUNCT7_ADD, `X26, `X25, `FUNCT3_ADD, `X24, `OPC_REG};
			inst_buf[6]  = {`FUNCT7_ADD, `X27, `X26, `FUNCT3_ADD, `X25, `OPC_REG};
			inst_buf[5]  = {`FUNCT7_ADD, `X28, `X27, `FUNCT3_ADD, `X26, `OPC_REG};
			inst_buf[4]  = {`FUNCT7_ADD, `X29, `X28, `FUNCT3_ADD, `X27, `OPC_REG};
			inst_buf[3]  = {`FUNCT7_ADD, `X30, `X29, `FUNCT3_ADD, `X28, `OPC_REG};
			inst_buf[2]  = {`FUNCT7_ADD, `X31, `X30, `FUNCT3_ADD, `X29, `OPC_REG};
			inst_buf[1]  = {`FUNCT7_ADD, `X0,  `X31, `FUNCT3_ADD, `X30, `OPC_REG};
			inst_buf[0]  = {`FUNCT7_ADD, `X1,  `X0,  `FUNCT3_ADD, `X31, `OPC_REG};
*/

			inst_buf[0]  = {`FUNCT7_ADD, `X1,  `X1,  `FUNCT3_XOR, `X2, `OPC_REG};
			inst_buf[1]  = {`FUNCT7_ADD, `X2,  `X2,  `FUNCT3_XOR, `X1, `OPC_REG};
			inst_buf[2]  = {7'b0,	`X1,	`X2,	`FUNCT3_SW,	 5'b0,	 `OPC_STORE};
			inst_buf[3]  = {12'b1,  `X2,  `FUNCT3_ADD, `X2, `OPC_IMM};
			inst_buf[4]  = {12'b1,  `X1,  `FUNCT3_ADD, `X1, `OPC_IMM};
			inst_buf[5]  = {12'b0,  `X0,    3'b0, `X0, `OPC_JALR};
			inst_buf[6]  = {`FUNCT7_ADD, `X0,  `X0,  `FUNCT3_XOR, `X0, `OPC_REG};
			inst_buf[7]  = {`FUNCT7_ADD, `X0,  `X0,  `FUNCT3_XOR, `X0, `OPC_REG};
			inst_buf[8]  = {`FUNCT7_ADD, `X0,  `X0,  `FUNCT3_XOR, `X0, `OPC_REG};

/*

			inst_buf[6]  = {12'b0,  `X0,    3'b0, `X0, `OPC_JALR};
			inst_buf[7]  = {12'b0,  `X0,    3'b0, `X0, `OPC_JALR};
			inst_buf[8]  = {12'b0,  `X0,    3'b0, `X0, `OPC_JALR};
/*
			inst_buf[6]  = 
			inst_buf[7]  = 
			inst_buf[8]  = 
			inst_buf[9]  = 
			inst_buf[10] = 
			inst_buf[11] = 
			inst_buf[12] = 
			inst_buf[13] = 
			inst_buf[14] = 
			inst_buf[15] = 
			inst_buf[16] = 
			inst_buf[17] = 
			inst_buf[18] = 
			inst_buf[19] = 
			inst_buf[20] = 
			inst_buf[21] = 
			inst_buf[22] = 
			inst_buf[23] = 
			inst_buf[24] = 
			inst_buf[25] = 
			inst_buf[26] = 
			inst_buf[27] = 
			inst_buf[28] = 
			inst_buf[29] = 
			inst_buf[30] = 
			inst_buf[31] = 
*/

			instr <= 0;
			inst_valid <= 0;
			addr <= 0;
		end else begin
			if(inst_valid & inst_ready) begin
				addr <= addr + 1;
				instr <= inst_buf[addr];
			end else if(brc_target_valid) begin
				addr <= brc_target;
				inst_valid <= 0;
			end else begin
				instr <= inst_buf[addr];
				inst_valid <= 1;
			end
		end
	end

endmodule
