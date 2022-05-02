module inverse_quantizer(
	input  [15:0] prev_predicted,
	input [3:0] code,
	input [15:0] step_size,
	output logic [15:0] predicted);


	wire [15:0] staged_diffq [4];    
	assign staged_diffq[0] = step_size >> 3;
	for(genvar i = 1; i <= 3; i = i + 1) begin
		assign staged_diffq[i] = code[i - 1] ? staged_diffq[i - 1] + step_size >> (i - 1) : staged_diffq[i - 1];
	end


	wire  [18:0] sample_ext;
	wire  [18:0] diffq_ext;
	assign sample_ext = { {3{prev_predicted[15]}}, prev_predicted};
	assign diffq_ext = {3'b0, staged_diffq[3]};

	wire  [18:0] predicted_ext;

	assign predicted_ext = code[3] ? sample_ext - diffq_ext : sample_ext + diffq_ext;

	always_comb begin
		if(predicted_ext > 19'd32767)
			predicted = 16'd32767;
		else if ($signed(predicted_ext) < -19'd32768) 
			predicted = -16'd32768;
		else 
			predicted = predicted_ext[15:0];
	end

endmodule