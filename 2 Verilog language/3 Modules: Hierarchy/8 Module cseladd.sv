module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);//module add16 ( input[15:0] a, input[15:0] b, input cin, output[15:0] sum, output cout );
    wire cin1,cout1,cin2,cout2,cin3,cout3;
    wire [15:0] sum1,sum2,sum3,sum4;
    assign cin1=1'b0;
    assign cin2=1'b0;
    assign cin3=1'b1;
    add16 add16_1(a[15:0],b[15:0],cin1,sum1[15:0],cout1);
    add16 add16_2(a[31:16],b[31:16],cin2,sum2[15:0],cout2);
    add16 add16_3(a[31:16],b[31:16],cin3,sum3[15:0],cout3);
    
    always@(*)
        begin
            case(cout1)
                1'b0:sum4=sum2;
                1'b1:sum4=sum3;
            endcase
        end
    assign sum={sum4,sum1};
endmodule
