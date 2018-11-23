
module rv_regfile_semaphore(
	input clk,
	input reset,

	input [4:0] lock_req,

	output reg [31:0] lock_status,

	input [4:0] free_req
);

	always @(posedge clk) begin
		if(reset) begin
			lock_status <= 0;
		end else begin
			if(free_req) begin
				if(~lock_status[free_req])
					$display("Register x%d freed, but wasn't allocated!", free_req);
				else
					$display("Register x%d freed", free_req);

				lock_status[free_req] <= 0;
			end 

			if(lock_req) begin
				if(lock_status[lock_req])
					$display("Register x%d locked, but was already allocated!", lock_req);
				else
					$display("Register x%d locked", lock_req);

				lock_status[lock_req] <= 1;
			end 
		end
	end

endmodule

	
module rv_regfile(
	input clk,
	input reset,

	input [4:0] raddr_a,
	input raddr_a_valid,
	input [4:0] raddr_b,
	input raddr_b_valid,

	output reg [31:0] rdata_a,
	output reg rdata_a_valid,
	output reg [31:0] rdata_b,
	output reg rdata_b_valid,

	input [4:0]  waddr_a,
	input [31:0] wdata_a,
	input wr_a_valid,

	input [4:0]  waddr_b,
	input [31:0] wdata_b,
	input wr_b_valid
);

	reg [31:0] reg_file [31:1];
	integer i;

	initial begin
		for(i = 1; i < 32; i = i + 1) begin
			reg_file[i] <= 1;
		end
	end

	always @(posedge clk) begin
		if(reset) begin
			rdata_a <= 0;
			rdata_a_valid <= 0;
			rdata_b <= 0;
			rdata_b_valid <= 0;
		end else begin
			rdata_a_valid <= 0;

			if(raddr_a_valid) begin
				if(raddr_a)
					rdata_a <= reg_file[raddr_a];
				else
					rdata_a <= 0;

				rdata_a_valid <= 1;
			end

			rdata_b_valid <= 0;

			if(raddr_b_valid) begin
				if(raddr_b)
					rdata_b <= reg_file[raddr_b];
				else
					rdata_b <= 0;

				rdata_b_valid <= 1;
			end

			if(wr_a_valid && waddr_a) begin
				reg_file[waddr_a] <= wdata_a;
			end

			if(wr_b_valid && waddr_b) begin
				reg_file[waddr_b] <= wdata_b;
			end
		end
	end 

endmodule
