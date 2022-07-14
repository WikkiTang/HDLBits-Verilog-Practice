module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);//module add16 ( input[15:0] a, input[15:0] b, input cin, output[15:0] sum, output cout );
  
    wire cin1,cout1,cout2;
    wire [15:0] sum1,sum2;
    wire [31:0] x;
    assign cin1=sub;
  
    always@(*)
        begin
       	 	for(int i=0;i<32;i=i+1)
                x[i]=b[i]^sub;
        end
  
    add16 add16_1(a[15:0],x[15:0],cin1,sum1,cout1);
    add16 add16_2(a[31:16],x[31:16],cout1,sum2,cout2);
  
    assign sum={sum2,sum1};
    
endmodule
