`timescale 1ps/1ps
`default_nettype none


module tbench ();

//==============================================================================
//-- tbench : RESET generator
//==============================================================================
    reg resetn;
 
    initial begin
        resetn = 1'b0;
        #1_234_000
        resetn = 1'b1;
    end

//==============================================================================
//-- tbench : CLOCK generator
//==============================================================================
    real    FREQ_CLK = 100.0/*MHz*/;
    reg     clk;

    initial begin
        clk = 1'b0;
        forever #(1_000_000_000 / (FREQ_CLK*1_000) / 2) clk = ~clk;
    end

//==============================================================================
//-- tbench : Test Target
//==============================================================================

    `include "tp.sv"
    

    function integer clogb2 (
        input integer value
    );    
        begin  
            value = value-1;  
            for (clogb2=0; value>0; clogb2=clogb2+1) begin
              value = value>>1;
            end
        end  
    endfunction

endmodule

`default_nettype wire