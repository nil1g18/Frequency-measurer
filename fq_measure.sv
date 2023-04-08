`define REF_FREQ 1000000   //1MHz

module fq_measure(
	output logic [31:0] measured_freq,
	input input_freq,
	input ref_freq,
	input nReset
);

timeunit 1us; timeprecision 10ns;

logic [31:0] counter_i, counter_r, result;
logic enable_count;
logic reset;

logic state;

always_ff @(posedge input_freq, negedge nReset)
	if(~nReset)	begin
		counter_i <= 0;
		result <= 0;
		end
	else
		case(state)
	
		0: begin
			if(counter_r >= 1000000) begin
				result <= counter_i;
				state <= 1;
			end
			else 
				counter_i <= counter_i + 1;
			end
		
		1: begin
			counter_i <= 0;
			state <= 0;
			end
		
		default: state <= 0;
		endcase
	
always_ff @(posedge ref_freq, negedge nReset)
	if(~nReset) 
		counter_r <= 0;
	else
		if(reset)
			counter_r <= 0;
		else
			counter_r <= counter_r + 1;

assign reset = (state == 1);
assign measured_freq = result;

endmodule