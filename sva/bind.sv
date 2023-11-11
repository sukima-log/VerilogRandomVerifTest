
`define DEBUG

`ifdef DEBUG

bind tbench.counter pulse_test pulse_test_inst (
    .clk    (clk)
,   .resetn (resetn)
,   .carry  (carry)
);

`endif