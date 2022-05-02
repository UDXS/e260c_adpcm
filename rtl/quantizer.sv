module quantizer(
	input [15:0] sample,
	input [15:0] prev_predicted,
	input [15:0] step_size,
	output [3:0] code);


	wire  [15:0] diff;
	wire diff_neg;
	wire [15:0] diff_norm;

	assign diff = sample - prev_predicted;
	assign diff_neg = diff[15];
	assign diff_norm = diff_neg ? -diff : diff; 


	assign code[3] = diff_neg;

	wire  signed [15:0] staged_diff [4];
	assign staged_diff[3] = diff_norm;


	for(genvar i = 2; i >= 0; i = i - 1) begin
		assign code[i] = staged_diff[i + 1] >= (step_size >> (2 - i));
		assign staged_diff[i] = staged_diff[i + 1] - (step_size >> (2 - i));
	end

endmodule