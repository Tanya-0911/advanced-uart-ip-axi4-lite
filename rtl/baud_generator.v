module baud_generator (
    input wire clk,
    input wire rst_n,
    input wire enable,

    input wire [31:0] divisor,

    output reg baud_tick
);

    reg [31:0] counter;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            counter   <= 32'd0;
            baud_tick <= 1'b0;
        end

        else begin

            baud_tick <= 1'b0;

            if (!enable || divisor == 0) begin
                counter <= 32'd0;
            end

            else if (counter >= divisor - 1'b1) begin
                counter   <= 32'd0;
                baud_tick <= 1'b1;
            end

            else begin
                counter <= counter + 1'b1;
            end

        end

    end

endmodule
