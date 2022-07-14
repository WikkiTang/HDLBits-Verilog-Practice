module top_module ( input clk, input d, output q );
wire w,x;
    my_dff dff1(clk,d,w);
    my_dff dff2(clk,w,x);
    my_dff dff3(clk,x,q);
endmodule
