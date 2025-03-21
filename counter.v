module counter(
    input clk, rst,
    output [31:0] ctr
);
    reg [3:0] counter_reg, counter_next;
    always @(posedge clk) begin
        if (rst) begin
            counter_reg <= 0;
        end else begin
            counter_reg <= counter_next;
        end
    end

    always @(*) begin
        counter_next = counter_reg + 1;
    end
    
    assign ctr = counter_reg;
endmodule
