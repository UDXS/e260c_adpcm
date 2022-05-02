module inverse_quantizer(
	input  [15:0] prev_predicted,
	input [3:0] code,
	input [15:0] step_size,
	output logic [15:0] predicted);


	wire [18:0] staged_diffq [4];    
	assign staged_diffq[0] = step_size >> 3;
	for(genvar i = 1; i <= 3; i = i + 1) begin
		assign staged_diffq[i] = code[i - 1] ? staged_diffq[i - 1] + (step_size >> (i - 1)) : staged_diffq[i - 1];
	end


	wire  [18:0] sample_ext;
	assign sample_ext = { {3{prev_predicted[15]}}, prev_predicted};

	wire signed [18:0] predicted_ext;

	assign predicted_ext = code[3] ? sample_ext - staged_diffq[3] : sample_ext + staged_diffq[3];

	always_comb begin
		if (predicted_ext > 32767)
			predicted = -32767;
		else if (predicted_ext < -32768)
			predicted = -32768;
		else
			predicted = predicted_ext[15:0];
	end

endmodule