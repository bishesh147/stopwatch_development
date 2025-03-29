module counter(
    input clk, rst,
    output [5:0] seconds_ones_counter;
    output [3:0] seconds_tens_counter;
    output [3:0] minutes_ones_counter;
    output [3:0] minutes_tens_counter;
);
    reg [31:0] counter_reg, counter_next;
    wire seconds_indicator;
    wire minutes_indicator;
    reg [5:0] seconds_reg, seconds_next;
    reg [5:0] minutes_reg, minutes_next;
    always @(posedge clk) begin
        if (rst) begin
            counter_reg <= 0;
            seconds_reg <= 0;
            minutes_reg <= 0;
        end else begin
            counter_reg <= counter_next;
            seconds_reg <= seconds_next;
            minutes_reg <= minutes_next;
        end
    end

    assign seconds_indicator = (counter_reg == 99999999);
    assign minutes_indicator = (counter_reg == 60*99999999);
    always @(*) begin
        if (seconds_indicator) begin
            counter_next = 0;
            seconds_next = (minutes_indicator) ? 0 : seconds_reg + 1;
        end else begin
            counter_next = counter_reg + 1;
            seconds_next = seconds_reg;
        end
        if (minutes_indicator) begin
            minutes_next = minutes_reg + 1;
        end else begin
            minutes_next = minutes_reg;
        end
        // counter_next = (seconds_indicator) ? 0 : counter_reg + 1;
        // seconds_next = (seconds_indicator) ? ((minutes_indicator) ? 0 : seconds_reg + 1) : seconds_reg;
        // minutes_next = (minutes_indicator) ? minutes_reg + 1 : minutes_reg;
    end    
    assign seconds_counter = seconds_reg;
    assign minutes_counter = minutes_reg;
endmodule
