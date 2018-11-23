`include "rv32ui_def.v"

module rv_unpack(
	input clk,
	input reset,
	
	input [31:0] instr,
	input [31:0] instr_addr,
	input        inst_valid,
	output       inst_ready,

	output reg [4:0]  lock_req,

	input [31:0] lock_status,

	output reg [4:0]  rs1_addr,
	output reg        rs1_addr_valid,
	input      [31:0] rs1_data,
	input             rs1_data_valid,

	output reg [4:0]  rs2_addr,
	output reg        rs2_addr_valid,
	input      [31:0] rs2_data,
	input             rs2_data_valid,

	output reg [4:0]  rdest_addr,
	output reg        rdest_addr_valid,
	output reg [31:0] rdest_data,

	output reg [31:0] load_addr,
	output reg        load_addr_valid,
	input             load_addr_ready,
	output reg [2:0]  load_width,
	input      [31:0] load_data,
	input             load_data_valid,

	output reg [31:0] str_addr,
	output reg        str_addr_valid,
	input             str_addr_ready,
	output reg [2:0]  str_width,
	output reg [31:0] str_data,

	output reg [31:0] brc_target,
	output reg brc_target_valid

);
	reg branch_pending;

	reg [6:0]  opcode;
	reg [4:0]  rd;
	reg [2:0]  funct3;
	reg [4:0]  rs1;
	reg [4:0]  rs2;
	reg [7:0]  funct7;
	reg [31:0] imm;
	reg [31:0] pc;

	assign inst_ready = ~(lock_status[rs1] | lock_status[rs2] | fu_stall | branch_pending);

	//Fetch/unpack
	always @(posedge clk) begin
		if(reset) begin
			branch_pending <= 0;
			pc        <= 0;
			opcode    <= 0;
			lock_req  <= 0;
			imm[31:0] <= 0;
			rd        <= 0;
			rs1       <= 0;
			rs2       <= 0;
			funct3    <= 0;
			funct7    <= 0;
		end else if(inst_ready & inst_valid) begin
			pc        <= instr_addr;
			opcode    <= instr[6:0];
			lock_req  <= 0;
			imm[31:0] <= 32'b0;
			rd        <= 0;
			rs1       <= 0;
			rs2       <= 0;
			funct3    <= 0;
			funct7    <= 0;


			case(instr[6:0])
			//U Type
			`OPC_LUI,
			`OPC_AUIPC,
			`OPC_FENCE,
			`OPC_ECALL: begin
				pc         <= instr_addr;
				rd         <= instr[11:7];
				lock_req   <= instr[11:7];
				imm[31:12] <= instr[31:12];
			end

			//UJ Type
			`OPC_JAL: begin
				branch_pending <= 1;
				pc         <= instr_addr;
				rd         <= instr[11:7];
				lock_req   <= instr[11:7];
				imm[19:12] <= instr[19:12];
				imm[11]    <= instr[20];
				imm[4:1]   <= instr[24:21];
				imm[10:5]  <= instr[30:25];
				imm[31:20] <= {12{instr[31]}}; 

			end

			//I Type
			`OPC_LOAD,
			`OPC_IMM,
			`OPC_CSR: begin
				pc         <= instr_addr;
				rd         <= instr[11:7];
				lock_req   <= instr[11:7];
				funct3     <= instr[14:12];
				rs1        <= instr[19:15];
				imm[11:0]  <= instr[31:20];
			end

			`OPC_JALR: begin
				branch_pending <= 1;
				pc         <= instr_addr;
				rd         <= instr[11:7];
				lock_req   <= instr[11:7];
				funct3     <= instr[14:12];
				rs1        <= instr[19:15];
				imm[11:0]  <= instr[31:20];
			end

			//R Type
			`OPC_REG: begin
				pc         <= instr_addr;
				rd         <= instr[11:7];
				lock_req   <= instr[11:7];
				funct3     <= instr[14:12];
				rs1        <= instr[19:15];
				rs2        <= instr[24:20];
				funct7     <= instr[31:25];
			end

			//S Type
			`OPC_STORE: begin
				pc         <= instr_addr;
				lock_req   <= 0;
				imm[4:0]   <= instr[11:7];
				funct3     <= instr[14:12];
				rs1        <= instr[19:15];
				rs2        <= instr[24:20];
				imm[11:5]  <= instr[31:25];
			end

			//SB Type
			`OPC_BRANCH: begin
				branch_pending <= 1;
				pc         <= instr_addr;
				lock_req   <= 0;
				imm[11]    <= instr[7];
				imm[4:1]   <= instr[11:8];
				funct3     <= instr[14:12];
				rs1        <= instr[19:15];
				rs2        <= instr[24:20];
				imm[10:5]  <= instr[30:25];
				imm[12]    <= instr[31];
			end

			endcase

		end else begin
			if(brc_done)
				branch_pending <= 0;
			lock_req  <= 0;
		end
	end

	reg [31:0] rsv_pc;
	reg [6:0]  rsv_opcode;
	reg [4:0]  rsv_rd;
	reg [31:0] rsv_imm;
	reg [2:0]  rsv_funct3;
	reg [6:0]  rsv_funct7;

	//rsv - Register reserve/stall
	always @(posedge clk) begin
		if(reset) begin
			//inst_ready <= 0;
			rs1_addr_valid <= 0;
			rs2_addr_valid <= 0;
			rsv_rd         <= 0;
			rsv_opcode     <= 0;
		end else begin
			//Source registers of current instruction already have write pending?
			if(~inst_ready & ~branch_pending) begin
				rs1_addr_valid <= 0;
				rs2_addr_valid <= 0;
				rsv_opcode     <= 0;
			end else begin
				rs1_addr_valid <= 1;
				rs2_addr_valid <= 1;
				rsv_pc         <= pc;
				rsv_rd         <= rd;
				rs1_addr       <= rs1;
				rs2_addr       <= rs2;
				rsv_imm        <= imm;
				rsv_funct3     <= funct3;
				rsv_funct7     <= funct7;
				rsv_opcode     <= opcode;
			end
		end
	end

	reg [31:0] rft_pc;
	reg [6:0]  rft_opcode;
	reg [4:0]  rft_rd;
	reg [31:0] rft_imm;
	reg [2:0]  rft_funct3;
	reg [6:0]  rft_funct7;

	//rft - Register fetch
	always @(posedge clk) begin
		if(reset) begin
			rft_opcode <= 0;
			rft_rd     <= 0;
			rft_imm    <= 0;
			rft_funct3 <= 0;
			rft_funct7 <= 0;
		end else begin
			rft_opcode <= rsv_opcode;
			rft_pc     <= rsv_pc;
			rft_rd     <= rsv_rd;
			rft_imm    <= rsv_imm;
			rft_funct3 <= rsv_funct3;
			rft_funct7 <= rsv_funct7;
		end
	end

	//dcd - Decode

	reg str_valid;
	reg load_valid;
	reg alu_valid;
	reg [31:0] dcd_pc;
	reg [4:0]  dcd_rd;
	reg [31:0] dcd_op_a;
	reg [31:0] dcd_op_b;
	reg [31:0] dcd_imm;
	reg [2:0]  dcd_funct3;
	reg [6:0]  dcd_funct7;

	always @(posedge clk) begin
		if(reset) begin
			load_valid <= 0;
			str_valid  <= 0;
			alu_valid  <= 0;
			brc_valid  <= 0;
			dcd_rd     <= 0;
			dcd_op_a   <= 0;
			dcd_op_b   <= 0;
			dcd_funct3 <= 0;
			dcd_funct7 <= 0;
		end else begin
			load_valid <= 0;
			str_valid  <= 0;
			alu_valid  <= 0;
			brc_valid  <= 0;

			if(~fu_stall) begin
				case(rft_opcode)
				`OPC_REG: begin
					alu_valid  <= 1;
					dcd_pc     <= rft_pc;
					dcd_rd     <= rft_rd;
					dcd_op_a   <= rs1_data_valid ? rs1_data : 0;
					dcd_op_b   <= rs2_data_valid ? rs2_data : 0;
					dcd_funct3 <= rft_funct3;
					dcd_funct7 <= rft_funct7;
				end

				`OPC_IMM: begin
					alu_valid  <= 1;
					dcd_pc     <= rft_pc;
					dcd_rd     <= rft_rd;
					dcd_op_a   <= rs1_data_valid ? rs1_data : 0;
					dcd_op_b   <= rft_imm;
					dcd_funct3 <= rft_funct3;
					dcd_funct7 <= rft_funct7;
				end

				`OPC_LOAD: begin
					load_valid <= 1;
					dcd_pc     <= rft_pc;
					dcd_rd     <= rft_rd;
					dcd_op_a   <= rs1_data_valid ? rs1_data : 0;
					dcd_op_b   <= rft_imm;
					dcd_funct3 <= rft_funct3;
				end

				`OPC_STORE: begin
					str_valid  <= 1;
					dcd_pc     <= rft_pc;
					dcd_rd     <= rft_rd;
					dcd_op_a   <= rs1_data_valid ? rs1_data : 0;
					dcd_op_b   <= rs2_data_valid ? rs2_data : 0;
					dcd_imm    <= rft_imm;
					dcd_funct3 <= rft_funct3;
					dcd_funct7 <= rft_funct7;
				end

				`OPC_JAL: begin
					$display("JAL");
					brc_valid <= 1;
					dcd_rd   <= rft_rd;
					dcd_pc   <= rft_pc;
					dcd_imm  <= rft_imm;
					dcd_op_a <= rft_pc;
				end

				`OPC_JALR: begin
					$display("JALR");
					brc_valid <= 1;
					dcd_rd   <= rft_rd;
					dcd_pc   <= rft_pc;
					dcd_imm  <= rft_imm;
					dcd_op_a <= rs1_data_valid ? rs1_data : 0;
				end
						
				endcase
			end
		end
	end

	//alu - ALU ops
	reg        alu_wb;
	reg [4:0]  alu_rd;
	reg [31:0] alu_data;

	always @(posedge clk) begin
		if(reset) begin
			alu_rd   <= 0;
			alu_wb   <= 0;
			alu_data <= 0;
		end else begin
			alu_wb <= 0;

			if(alu_valid) begin
				case(dcd_funct3)
				`FUNCT3_ADD: begin
					alu_wb <= 1;
					alu_rd <= dcd_rd;
					alu_data <= dcd_funct7[5] ? dcd_op_a - dcd_op_b
					                          : dcd_op_a + dcd_op_b;
				end

				`FUNCT3_OR: begin
					alu_wb <= 1;
					alu_rd <= dcd_rd;
					alu_data <= dcd_op_a | dcd_op_b;
				end

				`FUNCT3_XOR: begin
					alu_wb <= 1;
					alu_rd <= dcd_rd;
					alu_data <= dcd_op_a ^ dcd_op_b;
				end
				endcase
			end
		end
	end

	//mem - Memory operations

	always @(posedge clk) begin
		if(reset) begin
			str_addr  <= 0;
			str_addr_valid <= 0;
			str_data  <= 0;
			str_width <= 0;
		end else begin
			if(str_valid) begin
				str_width <= dcd_funct3;
				str_addr  <= dcd_op_a + dcd_imm;
				str_data  <= dcd_op_b;
				str_addr_valid <= 1;
			end else begin
				str_addr_valid <= 0;
			end
		end
	end


	wire fu_stall;

	reg [1:0] load_state;
	reg load_stall;
	reg [4:0] load_rd;
	reg load_wb;
	
	`define LOAD_INIT  0
	`define LOAD_ADDR  1
	`define LOAD_WB    2

	assign fu_stall = load_stall | brc_stall;

	always @(posedge clk) begin
		if(reset) begin
			load_state <= `LOAD_INIT;
			load_addr <= 0;
			load_rd   <= 0;
			load_wb   <= 0;
			load_addr_valid <= 0;
			load_width <= 0;
			load_stall <= 0;
		end else begin
			case(load_state)
			`LOAD_INIT: begin
				if(load_valid) begin
					load_addr_valid <= 1;
					load_addr  <= dcd_op_a + dcd_imm;
					load_width <= dcd_funct3;
					load_state <= `LOAD_ADDR;
					load_stall <= 1;
					load_rd    <= dcd_rd;
				end else begin
					load_addr_valid <= 0;
				end
			end

			`LOAD_ADDR: begin
				if(load_addr_valid & load_addr_ready) begin	
					load_state <= `LOAD_WB;
					load_addr_valid <= 0;
					load_wb <= 1;
				end
			end

			`LOAD_WB: begin
				if(load_data_valid) begin
					load_wb    <= 0;
					load_stall <= 0;
					load_state <= `LOAD_INIT;
				end
			end
			endcase
		end
	end

	//brc - Branch operations

	reg brc_stall;
	reg brc_valid;
	reg brc_done;
	reg [31:0] link_target;
	reg brc_wb;
	reg [4:0] brc_rd;
	
	always @(posedge clk) begin
		if(reset) begin
			brc_stall <= 0;
			brc_done  <= 0;
			brc_wb    <= 0;
		end else begin
			brc_done  <= 0;
			brc_wb    <= 0;

			if(~brc_stall) begin
				if(brc_valid) begin
					link_target <= dcd_pc + 4;
					brc_rd <= dcd_rd;
					brc_stall <= 1;
					brc_target <= dcd_op_a + dcd_imm;
					brc_target_valid <= 1;
				end
			end else if((brc_target == instr_addr) && inst_valid) begin
				brc_target_valid <= 0;
				brc_stall <= 0;
				brc_wb <= 1;
				brc_done <= 1;
			end else begin
				brc_target_valid <= 0;
			end
		end
	end 

	//wb - Writeback

	always @(posedge clk) begin
		if(reset) begin
			rdest_addr_valid <= 0;
			rdest_addr <= 0;
			rdest_data <= 0;
		end else begin
			rdest_addr_valid <= 0;

			if(alu_wb) begin
				rdest_addr_valid <= 1;
				rdest_addr <= alu_rd;
				rdest_data <= alu_data;
			end else if(load_wb) begin
				if(load_data_valid) begin
					rdest_addr_valid <= 1;
					rdest_addr <= load_rd;
					rdest_data <= load_data;
				end
			end else if(brc_wb) begin
				rdest_addr_valid <= 1;
				rdest_addr <= brc_rd;
				rdest_data <= link_target;
			end
		end
	end


endmodule

			
