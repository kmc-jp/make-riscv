parameter CLK_FREQ = 12000000;

module pwm_modulator(CLK, RST, VAL, MOUT);
    input CLK, RST;
    input [7:0] VAL;
    output MOUT;

    reg out_buf;
    reg [7:0] cnt_time;
    reg [31:0] cnt_clock;
    wire is_clk_max;

    assign MOUT = out_buf;

    always @(posedge CLK) begin
        if(RST == 1) cnt_clock <= 0;
        else begin
            if(cnt_clock >= CLK_FREQ / 100000 - 1) cnt_clock <= 0;
            else cnt_clock <= cnt_clock + 1;
        end
    end
    assign is_clk_max = (cnt_clock == CLK_FREQ / 100000 - 1);

    always @(posedge CLK) begin
        if(RST == 1) begin
            out_buf <= 0;
            cnt_time <= 8'b0;
        end
        else begin
            if(is_clk_max) cnt_time <= cnt_time + 1;
            if(cnt_time >= VAL) out_buf <= 0;
            else out_buf <= 1;
        end
    end
endmodule
