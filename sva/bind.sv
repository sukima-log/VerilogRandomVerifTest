
// `define SVA

`ifdef SVA

bind tbench.counter pulse_test #(
    .P_BIT  (4)
) pulse_test_inst (
    .clk    (clk)
,   .resetn (resetn)
,   .enable (enable)
,   .wenable(wenable)
,   .wcount (wcount)
,   .count  (count)
,   .carry  (carry)
);

`endif