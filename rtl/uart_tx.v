module uart_tx (

    input wire clk,
    input wire rst_n,
    input wire baud_tick,

    input wire tx_start,
    input wire [7:0] tx_data,

    output reg txd,
    output wire tx_busy,
    output reg tx_done

);

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;

    reg [7:0] shift_reg;
    reg [2:0] bit_index;

    assign tx_busy = (state != IDLE);

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            state     <= IDLE;
            shift_reg <= 8'd0;
            bit_index <= 3'd0;

            txd       <= 1'b1;
            tx_done   <= 1'b0;

        end

        else begin

            tx_done <= 1'b0;

            case (state)

                IDLE: begin

                    txd <= 1'b1;

                    if (tx_start) begin

                        shift_reg <= tx_data;
                        bit_index <= 3'd0;

                        txd <= 1'b0;
                        state <= START;

                    end

                end

                START: begin

                    if (baud_tick) begin

                        txd <= shift_reg[0];

                        shift_reg <=
                            {1'b0, shift_reg[7:1]};

                        bit_index <= 3'd1;

                        state <= DATA;

                    end

                end

                DATA: begin

                    if (baud_tick) begin

                        txd <= shift_reg[0];

                        shift_reg <=
                            {1'b0, shift_reg[7:1]};

                        if (bit_index == 3'd7) begin

                            state <= STOP;

                        end

                        else begin

                            bit_index <= bit_index + 1'b1;

                        end

                    end

                end

                STOP: begin

                    txd <= 1'b1;

                    if (baud_tick) begin

                        tx_done <= 1'b1;
                        state <= IDLE;

                    end

                end

                default: begin

                    state <= IDLE;
                    txd <= 1'b1;

                end

            endcase

        end

    end

endmodule
