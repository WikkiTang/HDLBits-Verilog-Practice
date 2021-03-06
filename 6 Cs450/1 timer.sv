module top_module(
	input clk, 
	input load, 
	input [9:0] data, 
	output tc
);

    logic [9:0] counter;
    always_ff@(posedge clk)
        begin
            if(load)
                begin
                counter<=data;
                end
            else if(counter>1'b0)
                counter<=counter-1'b1;
        end
    
    assign tc=counter?1'b0:1'b1;
endmodule
