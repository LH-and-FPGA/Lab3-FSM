module top #(
    parameter WIDTH = 16
) (
    input logic [WIDTH-1:0] N,
    input logic en,
    input logic rst,
    input logic clk,
    input logic trigger,
    output logic [7:0] data_out
);
    logic cmd_delay;
    logic cmd_seq;
    logic tick1;
    clktick Clktick(
        .clk(clk),
        .rst(rst),
        .en(en),
        .N(N),
        .tick(tick1)
    );

    logic [6:0] K;
    lfsr_7 Lfsr_7(
        .clk(clk),
        .rst(rst),
        .en(cmd_delay),
        .data_out(K)
    );

    logic tick2;
    delay Delay(
        .clk(clk),
        .rst(rst),
        .trigger(cmd_delay),
        .n({3'b000, K}),
        .time_out(tick2)
    );



    f1_fsm F1_fsm(
        .rst(rst),
        .en(cmd_seq ? tick1 : tick2),
        .clk(clk),
        .trigger(trigger),
        .cmd_delay(cmd_delay),
        .cmd_seq(cmd_seq),
        .data_out(data_out)
    );
    
endmodule
