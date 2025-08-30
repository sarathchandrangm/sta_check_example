
module my_ckt (
    input wire clk,
    input wire rst_n,
    input wire d,
    input wire b,
    input wire f,
    input wire g,
    output reg q1
);
    wire a, e, c, f;
    reg q;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else
            q <= d;
    end

    assign a = q & b;
    assign c = q | g;
    assign e = f ^ c;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q1 <= 1'b0;
        else
            q1 <= e;
    end

endmodule