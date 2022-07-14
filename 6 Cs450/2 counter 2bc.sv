module top_module(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);
    logic [1:0] next_state;
    parameter SNT=2'b00, WNT=2'b01, WT=2'b10, ST=2'b11;
    
    always_ff@(posedge clk or posedge areset)
        begin
        if(areset)
            state<=WNT;
        else if(!train_valid)
            state<=state;  
    	  else
        	state<=next_state;
        end
    
  always_comb
      case(state)
          SNT:
              if(train_taken)
                  next_state=WNT;
              else
                  next_state=SNT;
          WNT:
              if(train_taken)
                  next_state=WT;
              else
                  next_state=SNT;
          WT:
              if(train_taken)
                  next_state=ST;
              else
                  next_state=WNT;
          ST:
              if(train_taken)
                  next_state=ST;
              else
                  next_state=WT;
      endcase
endmodule
