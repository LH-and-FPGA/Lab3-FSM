module f1_fsm (
    input   logic       rst,
    input   logic       en,
    input   logic       clk,
    input   logic       trigger,
    output  logic       cmd_seq,
    output  logic       cmd_delay,
    output  logic [7:0] data_out
);
    typedef enum logic [7:0] {
        S0=8'b0, 
        S1=8'b1, 
        S2=8'b11,
        S3=8'b111,
        S4=8'b1111,
        S5=8'b11111,
        S6=8'b111111,
        S7=8'b1111111,
        S8=8'b11111111} light;
    light current, next;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) current <= S0;
        else if (en && trigger) begin
            current <= next;
        end
    end

    always_comb begin
        if (en && trigger) begin
            case (current)
                S0: next = S1;
                S1: next = S2;
                S2: next = S3;
                S3: next = S4;
                S4: next = S5;
                S5: next = S6;
                S6: next = S7;
                S7: next = S8;
                S8: next = S0;
                default: next = S0;
            endcase
        end

        if (current == S8) begin
            assign cmd_seq = 0;
            assign cmd_delay = 1;
        end else begin
            assign cmd_delay = 0;
            assign cmd_seq = 1;
        end
    end

    assign data_out = current;

endmodule
