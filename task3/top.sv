module top #(
    parameter WIDTH = 16
) (
    input logic [WIDTH-1:0] N,
    input logic en,
    input logic rst,
    input logic clk,
    output logic [7:0] data_out
);
    logic tick;
    clktick Clktick(
        .clk(clk),
        .rst(rst),
        .en(en),
        .N(N),
        .tick(tick)
    );

    f1_fsm F1_fsm(
        .rst(rst),
        .en(tick),
        .clk(clk),
        .data_out(data_out)
    );
    
endmodule
