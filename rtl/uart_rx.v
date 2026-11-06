
module uart_rx (

    input wire clk,
    input wire rst_n,

    input wire rx_serial,
    input wire [31:0] clks_per_bit,

    output reg [7:0] rx_data,
    output reg rx_valid,
    output reg framing_error,
    output wire rx_busy

);

    // FSM states

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;

    // Synchronizer registers

    reg rx_sync1;
    reg rx_sync2;

    // Internal registers

    reg [31:0] counter;
    reg [2:0] bit_index;
    reg [7:0] shift_reg;

    // Busy indicator

    assign rx_busy = (state != IDLE);


    // Two-stage synchronizer

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            rx_sync1 <= 1'b1;
            rx_sync2 <= 1'b1;

        end

        else begin

            rx_sync1 <= rx_serial;
            rx_sync2 <= rx_sync1;

        end

    end


    // Receiver FSM

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            state         <= IDLE;
            counter       <= 32'd0;
            bit_index     <= 3'd0;
            shift_reg     <= 8'd0;

            rx_data       <= 8'd0;
            rx_valid      <= 1'b0;
            framing_error <= 1'b0;

        end

        else begin

            // Default pulse outputs

            rx_valid      <= 1'b0;
            framing_error <= 1'b0;

            case (state)

                // IDLE

                IDLE: begin

                    counter <= 32'd0;

                    if (!rx_sync2 && clks_per_bit >= 2) begin

                        state <= START;

                    end

                end


                // START BIT VALIDATION

                START: begin

                    if (counter >= (clks_per_bit >> 1) - 1'b1) begin

                        counter <= 32'd0;

                        if (!rx_sync2) begin

                            bit_index <= 3'd0;
                            state <= DATA;

                        end

                        else begin

                            state <= IDLE;

                        end

                    end

                    else begin

                        counter <= counter + 1'b1;

                    end

                end


                // DATA RECEPTION

                DATA: begin

                    if (counter >= clks_per_bit - 1'b1) begin

                        counter <= 32'd0;

                        shift_reg[bit_index] <= rx_sync2;

                        if (bit_index == 3'd7) begin

                            state <= STOP;

                        end

                        else begin

                            bit_index <= bit_index + 1'b1;

                        end

                    end

                    else begin

                        counter <= counter + 1'b1;

                    end

                end


                // STOP BIT VALIDATION

                STOP: begin

                    if (counter >= clks_per_bit - 1'b1) begin

                        counter <= 32'd0;

                        if (rx_sync2) begin

                            rx_data  <= shift_reg;
                            rx_valid <= 1'b1;

                        end

                        else begin

                            framing_error <= 1'b1;

                        end

                        state <= IDLE;

                    end

                    else begin

                        counter <= counter + 1'b1;

                    end

                end


                default: begin

                    state <= IDLE;
                    counter <= 32'd0;

                end

            endcase

        end

    end

endmodule
