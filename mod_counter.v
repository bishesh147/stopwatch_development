module mod_counter #(parameter MAX_COUNT = 800)(
    input clk, rst,
    output [$clog2(MAX_COUNT)-1:0] counter
);
    reg [$clog2(MAX_COUNT)-1:0] counter_reg, counter_next;
    always @(posedge clk) begin
        if (rst) begin
            counter_reg <= 0;
        end else begin
            counter_reg <= counter_next;
        end
    end

    always @(*) begin
        if (counter_reg == MAX_COUNT-1) begin
            counter_next = 0;
        end else begin
            counter_next = counter_reg + 1;
        end
    end

    assign counter = counter_reg;
endmodule
