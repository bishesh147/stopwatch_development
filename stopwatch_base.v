module stopwatch_base(
    input clk, rst,
    input start, stop,
    output [3:0] seconds_ones_counter,
    output [3:0] seconds_tens_counter,
    output [3:0] minutes_ones_counter,
    output [3:0] minutes_tens_counter
);
    reg state_reg, state_next;
    reg [31:0] counter_reg, counter_next;
    reg [3:0] seconds_ones_ctr_reg, seconds_ones_ctr_next;
    reg [3:0] seconds_tens_ctr_reg, seconds_tens_ctr_next;
    reg [3:0] minutes_ones_ctr_reg, minutes_ones_ctr_next;
    reg [3:0] minutes_tens_ctr_reg, minutes_tens_ctr_next;

    always @(posedge clk) begin
        if (rst) begin
            state_reg <= 0; // Stop
            counter_reg <= 0;
            seconds_ones_ctr_reg <= 0;
            seconds_tens_ctr_reg <= 0;
            minutes_ones_ctr_reg <= 0;
            minutes_tens_ctr_reg <= 0;
        end else begin
            state_reg <= state_next; // Start
            counter_reg <= counter_next;
            seconds_ones_ctr_reg <= seconds_ones_ctr_next;
            seconds_tens_ctr_reg <= seconds_tens_ctr_next;
            minutes_ones_ctr_reg <= minutes_ones_ctr_next;
            minutes_tens_ctr_reg <= minutes_tens_ctr_next;
        end
    end

    wire seconds_ones_ind;
    assign seconds_ones_ind = (counter_reg == 99999999);
    wire seconds_tens_ind;
    assign seconds_tens_ind = (seconds_ones_ind & (seconds_ones_ctr_reg == 9));
    wire minutes_ones_ind;
    assign minutes_ones_ind = (seconds_tens_ind & (seconds_tens_ctr_reg == 5));
    wire minutes_tens_ind;
    assign minutes_tens_ind = (minutes_ones_ind & (minutes_ones_ctr_reg == 9));

    always @(*) begin
        state_next = state_reg;
        counter_next = counter_reg;
        seconds_ones_ctr_next = seconds_ones_ctr_reg;
        seconds_tens_ctr_next = seconds_tens_ctr_reg;
        minutes_ones_ctr_next = minutes_ones_ctr_reg;
        minutes_tens_ctr_next = minutes_tens_ctr_reg;

        case (state_reg)
            1'b0 : state_next = (start) ? ~state_reg : state_reg; // Stop
            1'b1 : state_next = (stop) ? ~state_reg : state_reg; // Start
        endcase
        
        if (state_reg) begin
            counter_next = (seconds_ones_ind) ? 0 : counter_reg + 1;

            if (seconds_ones_ind) seconds_ones_ctr_next = (seconds_tens_ind) ? 0 : seconds_ones_ctr_reg+1;
            else seconds_ones_ctr_next = seconds_ones_ctr_reg;

            if (seconds_tens_ind) seconds_tens_ctr_next = (minutes_ones_ind) ? 0 : seconds_tens_ctr_reg+1;
            else seconds_tens_ctr_next = seconds_tens_ctr_reg;

            if (minutes_ones_ind) minutes_ones_ctr_next = (minutes_tens_ind) ? 0 : minutes_ones_ctr_reg+1;
            else minutes_ones_ctr_next = minutes_ones_ctr_reg;
            
            if (minutes_tens_ind) minutes_tens_ctr_next = (minutes_tens_ctr_reg == 5) ? 0 : minutes_tens_ctr_reg+1;
            else minutes_tens_ctr_next = minutes_tens_ctr_reg;
        end
    end

    assign seconds_ones_counter = seconds_ones_ctr_reg;
    assign seconds_tens_counter = seconds_tens_ctr_reg;
    assign minutes_ones_counter = minutes_ones_ctr_reg;
    assign minutes_tens_counter = minutes_tens_ctr_reg;
endmodule
