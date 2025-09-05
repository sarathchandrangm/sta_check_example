
module my_ckt (
    input  clk,
    input clk_g,
    input  rst_n,
    input  d,
    output q1
);
    
    reg buf_out;
    reg q;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else
            q <= d;
    end

    buf(buf_out, q);

    always @(posedge clk_g or negedge rst_n) begin
        if (!rst_n)
            q1 <= 1'b0;
        else
            q1 <= buf_out;
    end

endmodule