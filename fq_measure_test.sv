`define REF_FREQ 1000000

module fq_measure_test;

timeunit 1us; timeprecision 10ns;

wire [31:0] measured_freq;
logic input_freq;
logic ref_freq;
logic nReset;

int counter;
int freq[3];

int i = 0;

fq_measure f0(.measured_freq,
	.input_freq,
	.ref_freq,
	.nReset
);

initial
begin
nReset = 0;
ref_freq = 0;
input_freq = 0;
#10 nReset = 1;

freq[0] = 7482;
freq[1] = 68921;
freq[2] = 223;

#50 
while(1) #(10000000/(2*freq[i])) input_freq = !input_freq;

end

initial
begin

#20000000 i = 1;
#20000000 i = 2;
#20000000 $stop;


end


always
	#(10000000/(2*`REF_FREQ)) ref_freq = !ref_freq;
	
	
always @(posedge ref_freq)
	counter <= counter + 1;

endmodule