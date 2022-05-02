module adpcm_tb();

	reg clk;
	reg reset;

	reg [15:0] sample;
	wire [3:0] code;

    encoder enc_i(
    .clk(clk),
	.reset(reset),
	.sample(sample),
	.code(code));

	wire [15:0] predsample;

    decoder dec_i(
	.clk(clk),
	.reset(reset),
	.code(code),
	.predsample(predsample));

	reg [7:0] wave_tab [256];
	integer i;

	initial begin
		$display ("ADPCM Benchmark by D. Markarian");
		$readmemh ("rtl/dat/wave.dat", wave_tab);

		#1 clk = 1;
		#1 clk = 0;
		reset = 1;
		#1 clk = 1;
		#1 clk = 0;
		reset = 0;

		for(i = 0; i < 256; i++) begin
			sample = {wave_tab[i], wave_tab[i]};
			#1 clk = 1;
			#1 clk = 0;
			$display("i = %d s = 0x%X c(s) = 0x%X p(c(s))= 0x%X, ", i, sample, code, predsample);
		end


	end



endmodule