module seven_segment_display(
    input clk, rst,
    input [3:0] seconds_ones_counter,
    input [3:0] seconds_tens_counter,
    input [3:0] minutes_ones_counter,
    input [3:0] minutes_tens_counter,
    output [7:0] one_hot_out, display_pattern_out
);
    reg [31:0] ctr_reg, ctr_next;
    reg [7:0] one_hot_reg, one_hot_next;
    reg [7:0] display_pattern_reg;
    always @(posedge clk) begin
        if (rst) begin 
            one_hot_reg <= 8'b1111_1110;
            ctr_reg <= 0;
        end
        else begin 
            one_hot_reg <= one_hot_next;
            ctr_reg <= ctr_next;
        end
    end
    reg [3:0] display_val;
    always @(*) begin
        ctr_next = (ctr_reg == 99999) ? 0 : ctr_reg + 1;
        one_hot_next = one_hot_reg;
        if (ctr_reg == 99999) begin
            case (one_hot_reg)
                8'b1111_1110 : one_hot_next = 8'b1111_1101;
                8'b1111_1101 : one_hot_next = 8'b1111_1011;
                8'b1111_1011 : one_hot_next = 8'b1111_0111;    
                8'h1111_0111 : one_hot_next = 8'h1111_1110;
                default : one_hot_next = one_hot_reg;
            endcase
        end
        case (one_hot_reg)
            8'b1111_1110 : display_val = seconds_ones_counter;
            8'b1111_1101 : display_val = seconds_tens_counter;
            8'b1111_1011 : display_val = minutes_ones_counter;
            8'b1111_0111 : display_val = minutes_tens_counter;
            default : display_val = seconds_ones_counter;
        endcase
    end
    always @(*) begin
        case (display_val)
            4'b0000 : display_pattern_reg[6:0] = 7'b1000000;
            4'b0001 : display_pattern_reg[6:0] = 7'b1111001;
            4'b0010 : display_pattern_reg[6:0] = 7'b0100100;
            4'b0011 : display_pattern_reg[6:0] = 7'b0110000;
            4'b0100 : display_pattern_reg[6:0] = 7'b0011001;
            4'b0101 : display_pattern_reg[6:0] = 7'b0010010;
            4'b0110 : display_pattern_reg[6:0] = 7'b0000010;
            4'b0111 : display_pattern_reg[6:0] = 7'b1111000;
            4'b1000 : display_pattern_reg[6:0] = 7'b0000000;
            4'b1001 : display_pattern_reg[6:0] = 7'b0010000;
            default : display_pattern_reg[6:0] = 7'b1000000;
        endcase
        display_pattern_reg[7] = (one_hot_reg == 8'h08);
    end
    assign one_hot_out = one_hot_reg;
    assign display_pattern_out = display_pattern_reg;
endmodule

