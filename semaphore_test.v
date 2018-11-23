
module sem_test_top(
);
	reg clk;
	reg reset;


	initial begin
		reset = 1;
	#1000	reset = 0;
		clk  <= 0;
	end

	always @(*) begin
	#100 	clk <= ~clk;
	end

	wire inst_valid;
	wire inst_ready;
	wire unpack_valid;
	wire [31:0] inst;

	wire [4:0]  lock_req;
	wire [31:0] lock_status;
	wire [4:0]  free_req;

	inst_test it(clk, reset, inst_valid, inst_ready, inst);
	rv_regfile_semaphore sem(clk, reset, lock_req, lock_status, free_req);
	rv_unpack unp(clk, reset, inst, inst_valid, inst_ready, lock_req, lock_status, free_req);

endmodule
