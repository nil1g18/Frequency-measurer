`define REF_FREQ 1000000   //1MHz

module fq_measure_test;

timeunit 1us; timeprecision 10ns;

wire [31:0] measured_freq;
logic input_freq;
logic ref_freq;
logic nReset;

int counter;
int freq[6];

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

freq[0] = 1; //500000
freq[1] = 13; //38,461
freq[2] = 223; //2244
freq[3] = 756; //661
freq[4] = 3; //166,666
freq[5] = 9200; //54

#50 
while(1) #(freq[i]) input_freq = !input_freq;

end

initial
begin

for(int j = 0 ; j < 6; j++)
	#3000000 i = j;

#3000000 $stop;


end

always
	#0.5 ref_freq = !ref_freq;
	
always @(posedge ref_freq)
	counter <= counter + 1;

endmodule
