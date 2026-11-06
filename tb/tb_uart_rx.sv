
`timescale 1ns/1ps

module tb_uart_rx;

    reg clk;
    reg rst_n;
    reg rx_serial;

    reg [31:0] clks_per_bit;

    wire [7:0] rx_data;
    wire rx_valid;
    wire framing_error;
    wire rx_busy;

    reg got_valid;
    reg got_error;
    reg [7:0] received_data;

    integer i;

    // Instantiate UART receiver

    uart_rx DUT (
        .clk(clk),
        .rst_n(rst_n),
        .rx_serial(rx_serial),
        .clks_per_bit(clks_per_bit),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .framing_error(framing_error),
        .rx_busy(rx_busy)
    );

    // 50 MHz clock

    always #10 clk = ~clk;

    // Monitor receiver outputs

    always @(posedge clk) begin

        if (rx_valid) begin
            got_valid = 1'b1;
            received_data = rx_data;
        end

        if (framing_error)
            got_error = 1'b1;

    end

    // Send one UART bit

    task send_bit(input reg bit_value);
        begin
            rx_serial = bit_value;
            repeat(16) @(negedge clk);
        end
    endtask

    // Main test

    initial begin

        clk = 0;
        rst_n = 0;
        rx_serial = 1'b1;

        clks_per_bit = 16;

        got_valid = 0;
        got_error = 0;
        received_data = 8'd0;

        $dumpfile("sim/uart_rx.vcd");
        $dumpvars(0, tb_uart_rx);

        // Reset

        #50;
        rst_n = 1;

        repeat(5) @(negedge clk);

        $display("Starting UART RX test");

        // Send start bit

        send_bit(1'b0);

        $display("Start bit sent");

        // Send 8 data bits (LSB first)

        for (i = 0; i < 8; i = i + 1) begin

            send_bit((8'hA5>>i)& 1'b1);
            $display ("Sent bit %0d = %b",
             i, ((8'hA5 >> i) & 1'b1));

          end

        // Send stop bit

        send_bit(1'b1);

        $display("Stop bit sent");

        // Allow receiver to complete

        repeat(10) @(negedge clk);

        #1;

        // Check results

        if (!got_valid)
            $fatal(1, "ERROR: rx_valid not asserted");

        if (got_error)
            $fatal(1, "ERROR: Unexpected framing error");

        if (received_data !== 8'hA5)
            $fatal(1, "ERROR: Received data incorrect: %h",
                   received_data);

        $display("--------------------------------");
        $display("PASS: RX valid asserted");
        $display("PASS: No framing error");
        $display("PASS: Received data = %h", received_data);
        $display("--------------------------------");
        $display("ALL UART RX TESTS PASSED");

        #50;
        $finish;

    end

endmodule
