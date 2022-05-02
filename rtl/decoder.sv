module decoder (
	input clk,
	input reset,
	input [3:0] code,
	output reg signed [15:0] predsample
);

	reg [15:0] step_sizes [89];
	wire [15:0] step;

	initial
		$readmemh("dat/step_table.dat", step_sizes);

	reg [7:0] index;
	assign step = step_sizes[index];

	wire signed [15:0] next_predsample;

	inverse_quantizer invquant_i (
		.prev_predicted(predsample),
		.code(code),
		.step_size(step),
		.predicted(next_predsample)
	);

	wire [7:0] next_index;

	step_adapter adapter_i (
		.last_index(index),
		.code(code),
		.new_index(next_index)
	);
	

	always_ff @(posedge clk) begin
		if(reset) begin
			predsample <= 16'b0;
			index <= 8'b0;
		end else begin
			predsample <= next_predsample;
			index <= next_index;
		end
	end

endmodule
