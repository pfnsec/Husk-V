
module rv_mem(
	input clk, 
	input reset,

	input       [31:0] load_addr,
	input              load_addr_valid,
	output reg         load_addr_ready,
	input       [2:0]  load_width,
	output reg  [31:0] load_data,
	output reg         load_data_valid,

	input       [31:0] str_addr,
	input              str_addr_valid,
	output reg         str_addr_ready,
	input       [2:0]  str_width,
	input       [31:0] str_data,

	output reg  [5:0]  waddr_b,
	output reg  [31:0] wdata_b,
	output reg         waddr_b_valid,

	output reg         rvm_arvalid,
	output reg         rvm_awvalid,
	output reg         rvm_bready,
	output reg         rvm_rready,
	output reg         rvm_wlast,
	output reg         rvm_wvalid,
	output reg  [5:0]  rvm_arid,
	output reg  [5:0]  rvm_awid,
	output reg  [5:0]  rvm_wid,
	output reg  [1:0]  rvm_arburst,
	output reg  [1:0]  rvm_arlock,
	output reg  [2:0]  rvm_arsize,
	output reg  [1:0]  rvm_awburst,
	output reg  [1:0]  rvm_awlock,
	output reg  [2:0]  rvm_awsize,
	output reg  [2:0]  rvm_arprot,
	output reg  [2:0]  rvm_awprot,
	output reg  [31:0] rvm_araddr,
	output reg  [31:0] rvm_awaddr,
	output reg  [63:0] rvm_wdata,
	output reg  [3:0]  rvm_arcache,
	output reg  [3:0]  rvm_arlen,
	output reg  [3:0]  rvm_arqos,
	output reg  [3:0]  rvm_awcache,
	output reg  [3:0]  rvm_awlen,
	output reg  [3:0]  rvm_awqos,
	output reg  [7:0]  rvm_wstrb,
	input              rvm_arready,
	input              rvm_awready,
	input              rvm_bvalid,
	input              rvm_rlast,
	input              rvm_rvalid,
	input              rvm_wready,
	input       [5:0]  rvm_bid,
	input       [5:0]  rvm_rid,
	input       [1:0]  rvm_bresp,
	input       [1:0]  rvm_rresp,
	input       [63:0] rvm_rdata,

	input              cfg_arvalid,
	input       [2:0]  cfg_arprot,
	input       [31:0] cfg_araddr,
	input              cfg_awvalid,
	input              cfg_bready,
	input              cfg_rready,
	input       [2:0]  cfg_awprot,
	input       [31:0] cfg_awaddr,
	input       [31:0] cfg_wdata,
	input              cfg_wvalid,
	input       [3:0]  cfg_wstrb,
	output reg         cfg_arready,
	output reg         cfg_awready,
	output reg         cfg_wready,
	output reg         cfg_bvalid,
	output reg  [1:0]  cfg_bresp,
	output reg  [1:0]  cfg_rresp,
	output reg         cfg_rvalid,
	output reg  [31:0] cfg_rdata
);

	parameter burst_len = 16;


	reg [2:0] rvm_state;

	`define RVM_INIT 0
	`define RVM_ 0

	always @(posedge clk) begin
		if(reset) begin
			rvm_arvalid <= 0;
			rvm_awvalid <= 0;
			rvm_bready  <= 0;
			rvm_rready  <= 0;
			rvm_wlast   <= 0;
			rvm_wvalid  <= 0;
			rvm_arid    <= 0;
			rvm_awid    <= 0;
			rvm_wid     <= 0;
			rvm_arburst <= 2'b01;
			rvm_arlock  <= 0;
			rvm_arsize  <= 3'b011;
			rvm_awburst <= 0;
			rvm_awlock  <= 0;
			rvm_awsize  <= 0;
			rvm_arprot  <= 0;
			rvm_awprot  <= 0;
			rvm_araddr  <= 0;
			rvm_awaddr  <= 0;
			rvm_wdata   <= 0;
			rvm_arcache <= 4'b0011;
			rvm_arlen   <= burst_len - 1;
			rvm_arqos   <= 0;
			rvm_awcache <= 0;
			rvm_awlen   <= 0;
			rvm_awqos   <= 0;
			rvm_wstrb   <= 0;
		end else begin
		end
	end



	reg [2:0] cfg_rstate;
	`define RD_IDLE   0
	`define RD_OUTPUT 1

	reg [2:0] cfg_wstate;
	`define WR_IDLE 0
	`define WR_WAIT 1
	`define WR_RESP 2

	reg [31:0] cfg_awaddr_buf; 

	always @(posedge clk) begin
		if(reset) begin
			cfg_arready <= 1;
			cfg_awready <= 1;
			cfg_bvalid  <= 0;
			cfg_rvalid  <= 0;
			cfg_wready  <= 0;
			cfg_bresp   <= 0;
			cfg_rresp   <= 0;
			cfg_rdata   <= 0;

			cfg_rstate  <= `RD_IDLE;
			cfg_wstate  <= `WR_IDLE;

			cfg_awaddr_buf <= 0;
		end else begin
			case(cfg_rstate)
			`RD_IDLE: begin
				cfg_arready <= 1;

				if(cfg_arvalid & cfg_arready) begin
					cfg_arready <= 0;
					cfg_rresp   <= 2'b00; //resp(OKAY)
					cfg_rstate  <= `RD_OUTPUT;
					cfg_rvalid  <= 1;

					case(cfg_araddr[7:0])
					8'h00: begin
					end
						
					default: begin
						cfg_rresp  <= 2'b10; //Address invalid - resp(SLVERR)
						cfg_rvalid <= 1;
					end

					endcase
				end

			end

			`RD_OUTPUT: begin
				cfg_arready <= 0;

				if(cfg_rvalid & cfg_rready) begin
					cfg_arready <= 1;
					cfg_rstate  <= `RD_IDLE;
					cfg_rvalid  <= 0;
				end
			end

			endcase

			case(cfg_wstate)
			`WR_IDLE: begin
				cfg_awready <= 1;

				if(cfg_awvalid & cfg_awready) begin
					cfg_awready <= 0;
					cfg_wready  <= 1;
					cfg_wstate  <= `WR_WAIT;
					cfg_bvalid  <= 0;

					cfg_awaddr_buf <= cfg_awaddr;

				end
			end


			`WR_WAIT: begin
				if(cfg_wready & cfg_wvalid) begin
					cfg_bresp   <= 2'b00; //resp(OKAY)
					cfg_wstate  <= `WR_RESP;
					cfg_wready  <= 0;
					cfg_bvalid  <= 1;

					case(cfg_awaddr_buf[7:0])
					8'h00: begin
					end
						
					default:
						cfg_bresp <= 2'b10; //Address invalid - resp(SLVERR)
					
					endcase
			
				end
			end

			`WR_RESP: begin
				if(cfg_bready & cfg_bvalid) begin
					cfg_bvalid  <= 0;
					cfg_wstate  <= `WR_IDLE;
				end
			end

			endcase
		end
	end

	reg [31:0] mem_buf [127:0];

	always @(posedge clk) begin
		if(reset) begin
			load_addr_ready <= 0;
			load_data       <= 0;
			load_data_valid <= 0;

			str_addr_ready  <= 0;
		end else begin
			load_data_valid <= 0;

			if(~load_addr_ready) begin
				load_addr_ready <= 1;
			end else if(load_addr_ready & load_addr_valid) begin
				load_addr_ready <= 0;
				load_data <= mem_buf[load_addr[6:0]];
				load_data_valid <= 1;
			end 

			if(~str_addr_ready) begin
				str_addr_ready <= 1;
			end else if(str_addr_ready & str_addr_valid) begin
				mem_buf[str_addr[6:0]] <= str_data;
				str_addr_ready <= 0;
			end
		end
	end


endmodule
