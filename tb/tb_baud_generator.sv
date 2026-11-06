`timescale 1ns/1ps

module tb_baud_generator;

    reg clk;
    reg rst_n;
    reg enable;
    reg [31:0] divisor;

    wire baud_tick;

    integer tick_count;

    // DUT instantiation
    baud_generator DUT (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .divisor(divisor),
        .baud_tick(baud_tick)
    );

    // Clock generation: 50 MHz
    always #10 clk = ~clk;

    // Test procedure
    initial begin

        clk = 0;
        rst_n = 0;
        enable = 0;
        divisor = 4;
        tick_count = 0;

        $dumpfile("sim/baud_generator.vcd");
        $dumpvars(0, tb_baud_generator);

        // Apply reset
        #30;
        rst_n = 1;

        // Enable baud generator
        #20;
        enable = 1;

        // Observe baud ticks
        repeat (5) begin
            @(posedge baud_tick);
            tick_count = tick_count + 1;

            $display("Baud tick detected at time %0t",
                     $time);
        end

        $display("Total baud ticks = %0d", tick_count);

        #50;
        $finish;

    end

endmodule
