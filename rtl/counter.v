`timescale 1ps/1ps
`default_nettype none


module counter #(
    parameter P_BASE = 'd32 //- counter max
,   parameter P_BIT  = 'd32 //- counter bit
) (
    input   wire                    clk         //- clock
,   input   wire                    resetn      //- reset negative logic
,   input   wire                    enable      //- enable
,   input   wire                    up_dw       //- up:1, down:0
,   input   wire                    wenable     //- write enable
,   input   wire [(P_BIT-1):0]      wcount      //- write count value
,   output  reg  [(P_BIT-1):0]      count       //- count value
,   output  wire                    carry       //- carry
);

    // ---------------------------
    // write enable
    // ---------------------------

    wire w_wenable = wenable & (wcount < P_BASE);

    // ---------------------------
    // count up down
    // ---------------------------

    wire w_upflag = ~(count+1 < P_BASE);
    wire w_dwflag = (count == 'd0);

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            count   <=  {P_BIT{1'b0}};
        end else if (w_wenable) begin
            count   <=  wcount;
        end else if (enable) begin
            if (up_dw & w_upflag) begin
                count   <=  {P_BIT{1'b0}};
            end else if (up_dw) begin
                count   <=  count + 'd1;
            end else if (!up_dw & w_dwflag) begin
                count   <=  (P_BASE - 'd1);
            end else if (!up_dw) begin
                count   <=  count - 'd1;
            end
        end
    end

    // ---------------------------
    // carry
    // ---------------------------

    assign carry = ((w_upflag & up_dw) | (w_dwflag & !up_dw)) & enable;

endmodule // counter


`default_nettype wire
