module pulser (
    input  wire     clk,
    input  wire     rst,

    input  wire     trg,
    output wire     out
);

    // Pulse length parameter
    parameter PULSE_LENGTH = (1 << 22);
    // Counter bit count
    localparam BITS = $clog2(PULSE_LENGTH) + 1;

    // Trigger synchronizer (just to be sure)
    reg trg_x;
    reg trg_y;
    reg trg_z;

    always @(posedge clk) trg_x <= (rst) ? 1'b0 : trg;
    always @(posedge clk) trg_y <= (rst) ? 1'b0 : trg_x;
    always @(posedge clk) trg_z <= (rst) ? 1'b0 : trg_y;

    // Pulse lenghtener
    reg [BITS-1:0] cnt;
    always @(posedge clk)
        if (rst)            cnt <= 0;
        else if (trg_z)     cnt <= PULSE_LENGTH;
        else if (cnt != 0)  cnt <= cnt - 1;

    assign out = (cnt != 0);

endmodule
