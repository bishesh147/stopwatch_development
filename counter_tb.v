`timescale 1ns / 1ps

module counter_tb();
    reg clk, rst;
    wire [3:0]ctr;
    
    counter cnt1(.clk(clk), .rst(rst), .ctr(ctr));
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; rst = 1;
        #10;
        rst = 0;
    end
endmodule
