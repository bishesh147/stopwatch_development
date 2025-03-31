module stopwatch_top(
    input clk, rst,
    input start, stop,
    output [7:0] one_hot_out, display_pattern
);
    wire [3:0] seconds_ones_counter;
    wire [3:0] seconds_tens_counter;
    wire [3:0] minutes_ones_counter;
    wire [3:0] minutes_tens_counter;

    stopwatch_base stb1(.clk(clk), .rst(rst),
                        .start(start), .stop(stop),
                        .seconds_ones_counter(seconds_ones_counter),
                        .seconds_tens_counter(seconds_tens_counter),
                        .minutes_ones_counter(minutes_ones_counter),
                        .minutes_tens_counter(minutes_tens_counter));
    
    seven_segment_display ssd1(.clk(clk), .rst(rst),
                                .seconds_ones_counter(seconds_ones_counter),
                                .seconds_tens_counter(seconds_tens_counter),
                                .minutes_ones_counter(minutes_ones_counter),
                                .minutes_tens_counter(minutes_tens_counter),
                                .one_hot_out(one_hot_out),
                                .display_pattern(display_pattern));

endmodule
