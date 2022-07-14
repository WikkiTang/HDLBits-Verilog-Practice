module top_module( 
    input [7:0] in,
    output [7:0] out
);
always_comb
	begin
        for(int i=0;i<8;i=i+1)
   			begin 
       		out[7-i]=in[i];   
   			end
	end
endmodule
