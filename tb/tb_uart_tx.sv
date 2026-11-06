`timescale 1ns/1ps

module tb_uart_tx;

    reg clk;
    reg rst_n;
    reg baud_tick;

    reg tx_start;
    reg [7:0] tx_data;

    wire txd;
    wire tx_busy;
    wire tx_done;

    integer i;

    // Instantiate UART transmitter

    uart_tx DUT (
        .clk(clk),
        .rst_n(rst_n),
        .baud_tick(baud_tick),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .txd(txd),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );

    // Generate 50 MHz clock

    always #10 clk = ~clk;

    // Generate one baud timing pulse
    // Four clock cycles between baud ticks

    task send_baud_tick;
        begin
            repeat(4) @(negedge clk);

            baud_tick = 1'b1;

            @(posedge clk);
            #1;

            baud_tick = 1'b0;
        end
    endtask

    // Main test

    initial begin

        clk = 0;
        rst_n = 0;
        baud_tick = 0;
        tx_start = 0;
        tx_data = 8'hA5;

        $dumpfile("sim/uart_tx.vcd");
        $dumpvars(0, tb_uart_tx);

        // Reset

        #30;
        rst_n = 1;

        // Start transmission

        @(negedge clk);
        tx_start = 1;

        @(posedge clk);
        #1;
        tx_start = 0;

        // Check start bit

        if (txd !== 1'b0)
            $fatal(1, "ERROR: Start bit incorrect");

        $display("PASS: Start bit detected");

        // Check all 8 data bits

        for (i = 0; i < 8; i = i + 1) begin

            send_baud_tick;

            if (txd !== tx_data[i])
                $fatal(1, "ERROR: Data bit %0d incorrect", i);

            $display("PASS: Data bit %0d = %b", i, txd);

        end

        // Check stop bit

        send_baud_tick;

        if (txd !== 1'b1)
            $fatal(1, "ERROR: Stop bit incorrect");

        $display("PASS: Stop bit detected");

        // Complete transmission

        if (tx_done !== 1'b1)
    $fatal(1, "ERROR: tx_done not asserted");

if (tx_busy !== 1'b0)
    $fatal(1, "ERROR: Transmitter still busy");

$display("PASS: Transmission completed");

$display("--------------------------------");
$display("ALL UART TX TESTS PASSED");
$display("--------------------------------");
        #30;
        $finish;

    end

endmodule
