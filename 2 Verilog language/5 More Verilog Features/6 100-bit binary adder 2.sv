module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );
    
    always@(*)
       begin 
           sum[0]=a[0]+b[0]+cin;
           if((a[0]&b[0]==1)
              |(a[0]&cin==1)
              |b[0]&cin==1)
                        cout[0]=1'b1;
                    else
                        cout[0]=0;
           for(int i=1;i<100;i=i+1)
                begin
                    sum[i]=a[i]+b[i]+cout[i-1];
                    if((a[i]&b[i]==1)
                       |(a[i]&cout[i-1]==1)
                       |b[i]&cout[i-1]==1)
                        cout[i]=1'b1;
                    else
                        cout[i]=0;
                end
        end
                    

endmodule
