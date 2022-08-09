An instance array or generate statement would be useful here.
 
 /* generate
        genvar i;
        for(i = 4; i < 400; i=i+4) begin : adder
            bcd_fadd fadd(a[i+3:i], b[i+3:i], cout_tmp[i-4], cout_tmp[i],sum[i+3:i]);
        end
    endgenerate
    */
