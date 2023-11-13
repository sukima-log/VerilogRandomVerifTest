
`timescale 1ps/1ps
`default_nettype none

module pulse_test #(
    parameter P_BIT = 4
) (
    input wire                clk
,   input wire                resetn
,   input wire                enable
,   input wire                wenable
,   input wire [(P_BIT-1):0]  wcount
,   input wire [(P_BIT-1):0]  count
,   input wire                carry
);

  logic [15:0] fire_p_test;
  logic [15:0] pass_p_test = 0;
  logic [15:0] fail_p_test = 0;

  assign fire_p_test = pass_p_test + fail_p_test;

  // property 記述
  property p_test1 (integer nClock);
    @(posedge clk) disable iff(~resetn)
        $rose(carry) |-> ##nClock ~carry;
  endproperty

  assert property (p_test1(1)) begin
    pass_p_test = pass_p_test + 1;
  end else begin
    fail_p_test = fail_p_test + 1;
     $info("[SVA] Error : p_test1 assertion failed");
    //  $finish;
  end
    
endmodule

`default_nettype wire


//======================================================
// 本来は以下のように書きたいがxsimではサポートされていない
//======================================================

// `timescale 1ps/1ps
// `default_nettype none

// module pulse_test (
//     input   wire                clk
// ,   input   wire                resetn
// ,   input   wire                carry
// );

//   // property 記述
//   property p_test1 (x) ;
//     @(posedge clk ) disable iff(~resetn)
//         $rose(x) |-> ##1 ~x;
//   endproperty
 
// // assertion 記述
  // assert property (p_test1(carry)) else $error("p_test1 assertion failed");
    
// endmodule


// `default_nettype wire



