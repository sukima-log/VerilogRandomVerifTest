
//- parameter
localparam P_BASE   = 'd10;
localparam P_BIT    = clogb2(P_BASE);

int unsigned wait_time;

//- random wait
task rand_wait();
    begin
        wait_time = $urandom_range(0, 1_234);
        #(wait_time);
    end
endtask

//- Class
class Transaction;
    // input variable declaration (default : public)
    rand reg                 enable  ;   // in   counter enable
    rand reg                 up_dw   ;   // in   1:up/0:down
    rand reg                 wenable ;   // in   write enable
    rand reg  [(P_BIT-1):0]  wcount  ;   // in   write count

    // random constraint
    constraint cl {
        // enable      inside  {0,1};
        // up_dw       inside  {0,1};
        // wenable     inside  {0,1};
        // wcount      inside  {[0:P_BASE], P_BASE+1};
        enable      dist    {0:/80, 1:/20};
        up_dw       dist    {0:/10, 1:/90};
        wenable     dist    {0:/80, 1:/20};
        wcount      dist    {[0:P_BASE]:/90, P_BASE+1:/10};
    }

    // constructor(Initialize)
    function new();
        this.enable     = 1'b0;
        this.up_dw      = 1'b1;
        this.wenable    = 1'b0;
        this.wcount     = P_BASE;
    endfunction

    // after randomize
    function void post_randomize();
        // $display("Post");
    endfunction
endclass // Transaction class

//- Input
reg                 enable  ;   // in   counter enable
reg                 up_dw   ;   // in   1:up/0:down
reg                 wenable ;   // in   write enable
reg  [(P_BIT-1):0]  wcount  ;   // in   write count
//- Output
reg  [(P_BIT-1):0]  count   ;   // out  count
reg                 carry   ;   // out  carry

//- top module
counter #(
    .P_BASE     (P_BASE     )   //- count max
,   .P_BIT      (P_BIT      )   //- counter bit
) counter (
    .clk        (clk        )   //- input   clock
,   .resetn     (resetn     )   //- input   reset (negative logic)

,   .enable     (enable     )   //- input   counter enable
,   .up_dw      (up_dw      )   //- input   up:1, down:0
,   .wenable    (wenable    )   //- input   write enable
,   .wcount     (wcount     )   //- input   write count value

,   .count      (count      )   //- output  coount value
,   .carry      (carry      )   //- output  carry
);

//- Instance
Transaction tr = new();
//- repeat
localparam repeat_num = 10;

initial begin
    // initiarize
    enable      = tr.enable;  
    up_dw       = tr.up_dw;   
    wenable     = tr.wenable;
    wcount      = tr.wcount; 

    @(posedge resetn)

    $display("test start");

    repeat(repeat_num) begin
        for (integer i=0; i<10; i++) begin
            $write("enable : %d, up/dw : %d, wenable : %d, wcount : %d ", enable, up_dw, wenable, wcount);
            //- wait posedge clock
            @(posedge clk);
            #(1);
            $display("= count : %d", count);
            #(1);
            //- High frequency change (sync)
            if(!tr.randomize()) $finish;
            enable      = tr.enable;
        end
        //- Low frequency change (sync)
        up_dw       = tr.up_dw;
        wcount      = tr.wcount;
        //- Low frequency change (unsync)
        rand_wait();
        wenable     = tr.wenable;
    end

    $display("test end");

    `ifdef SVA
    $display("");
    $display("----- assert result -----");
    $display("[SVA] pulse test : fire = %d, FAIL = %d",
                tbench.counter.pulse_test_inst.fire_p_test,
                tbench.counter.pulse_test_inst.fail_p_test);
    $display("");
    `endif

    $finish();
end