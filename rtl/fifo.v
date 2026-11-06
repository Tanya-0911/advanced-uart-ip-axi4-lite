
module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input wire clk,
    input wire rst_n,

    input wire wr_en,
    input wire rd_en,

    input wire [DATA_WIDTH-1:0] din,

    output reg [DATA_WIDTH-1:0] dout,

    output wire full,
    output wire empty,

    output reg [$clog2(DEPTH+1)-1:0] count
);

    // Memory storage

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Read and write pointers

    reg [$clog2(DEPTH)-1:0] wr_ptr;
    reg [$clog2(DEPTH)-1:0] rd_ptr;

    // FIFO status

    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    // FIFO operation

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
            dout   <= 0;

        end

        else begin

            case ({wr_en && !full, rd_en && !empty})

                // Write only

                2'b10: begin

                    mem[wr_ptr] <= din;

                    if (wr_ptr == DEPTH-1)
                        wr_ptr <= 0;
                    else
                        wr_ptr <= wr_ptr + 1'b1;

                    count <= count + 1'b1;

                end

                // Read only

                2'b01: begin

                    dout <= mem[rd_ptr];

                    if (rd_ptr == DEPTH-1)
                        rd_ptr <= 0;
                    else
                        rd_ptr <= rd_ptr + 1'b1;

                    count <= count - 1'b1;

                end

                // Simultaneous read and write

                2'b11: begin

                    mem[wr_ptr] <= din;
                    dout <= mem[rd_ptr];

                    if (wr_ptr == DEPTH-1)
                        wr_ptr <= 0;
                    else
                        wr_ptr <= wr_ptr + 1'b1;

                    if (rd_ptr == DEPTH-1)
                        rd_ptr <= 0;
                    else
                        rd_ptr <= rd_ptr + 1'b1;

                end

                // No operation

                default: begin
                    count <= count;
                end

            endcase

        end

    end

endmodule
