`define REF_FREQ 1000000   //1MHz

module sync_ff (
	output logic Q,
	input D,
	input Clock, nReset
	);

timeunit 1us; timeprecision 10ns;

always_ff @(posedge Clock, negedge nReset)
	if(~nReset)
		Q <= 0;
	else
		Q <= D;

endmodule

module sync_ff_32 (
	output logic [31:0] Q,
	input [31:0] D,
	input Clock, nReset
	);

timeunit 1us; timeprecision 10ns;

always_ff @(posedge Clock, negedge nReset)
	if(~nReset)
		Q <= 0;
	else
		Q <= D;

endmodule

module fq_measure(
	output logic [31:0] measured_freq,
	input input_freq,
	input ref_freq,
	input nReset
);

timeunit 1us; timeprecision 10ns;

logic [31:0] counter_i, counter_r, result;

logic state;

wire state_sync_in, state_sync_out;
wire [31:0] counter_r_sync_in, counter_r_sync_out;

sync_ff ff0 (.Q(state_sync_in), .D(state), .Clock(ref_freq), .nReset);
sync_ff ff1 (.Q(state_sync_out), .D(state_sync_in), .Clock(ref_freq), .nReset);

sync_ff_32 ff2 (.Q(counter_r_sync_in), .D(counter_r), .Clock(input_freq), .nReset);
sync_ff_32 ff3 (.Q(counter_r_sync_out), .D(counter_r_sync_in), .Clock(input_freq), .nReset);

always_ff @(posedge input_freq, negedge nReset)
	if(~nReset)
	begin
		counter_i <= 0;
		result <= 0;
	end
	else
		case(state)
		0: if(counter_r_sync_out >= `REF_FREQ) begin;
				result <= counter_i;
				state <= 1;
			end
			else
				counter_i <= counter_i + 1;
		
		1: begin
			counter_i <= 0;
			if (counter_r_sync_out == 0)
				state <= 0;
			end
		
		default: state <= 0;
		endcase

	
always_ff @(posedge ref_freq, negedge nReset)
	if(~nReset)
	begin
		counter_r <= 0;
	end
	else
	begin
		if(state_sync_out == 1)
			counter_r <= 0;
		else
			counter_r <= counter_r + 1;
	end

assign measured_freq = result;

endmodule
