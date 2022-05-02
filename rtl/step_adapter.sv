module step_adapter(
	input  [7:0]  last_index,
	input [3:0] code,
	output logic  [7:0] new_index
);

	reg [7:0] idx_tab [16];

	initial
		$readmemh("rtl/dat/index_table.dat", idx_tab);

	wire [7:0] idx_unsat;
	assign idx_unsat = last_index + idx_tab[code];

	always_comb begin
		if(idx_unsat[7])
			new_index = 0;
		else if(idx_unsat > 88)
			new_index = 88;
		else
			new_index = idx_unsat;
	end



endmodule