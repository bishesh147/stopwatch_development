module counter #(parameter MAX_COUNT = 100000000)(
    input clk, rst,
    output [9:0] seconds_counter
);
    reg [$clog2(MAX_COUNT)-1:0] counter_reg, counter_next;
    wire seconds_indicator;
    // Make another counter called seconds counter:
    // It counts up by one every second. Use the seconds_indicator signal to count the seconds counter up by 1.
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

    assign seconds_indicator = (counter_reg == 799);
endmodule
