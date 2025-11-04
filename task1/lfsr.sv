module lfsr(
    input   logic       clk,
    input   logic       rst,
    input   logic       en,
    output  logic [3:0] data_out
);
    logic [3:0] sreg;
    always_ff @(posedge clk, posedge rst) begin
        if (rst)
            sreg <= 4'b1; // 需要设置en吗
            // 其实不需要，rst一般优先级更高
        else begin
           if (en)
                sreg <= {sreg[2:0], sreg[3]^sreg[2]}; 
        end
    end
    assign data_out = sreg;

endmodule
