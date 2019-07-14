// PWM変調器
module pwm_modulator(CLK, RST, VAL, MOUT, C_FREQ);
    input CLK, RST;
   // デューティー比を0〜256で指定（256が100%）
    input [7:0] VAL;
   // クロック周波数
   input [64:0] C_FREQ;
   // 出力
    output MOUT;

   // 出力用バッファ
    reg out_buf;
   // 搬送波周期 / 256で1増えるカウンタ
    reg [7:0] cnt_time;
   // 分周用クロックカウンタ（day2のと同じ感じ）
    reg [31:0] cnt_clock;
    wire is_clk_max;

    assign MOUT = out_buf;

    always @(posedge CLK) begin
        if(RST == 1) cnt_clock <= 0;
        else begin
            // 10usでcnt_timeを1増やす
            if(cnt_clock >= C_FREQ / 100000 - 1) cnt_clock <= 0;
            else cnt_clock <= cnt_clock + 1;
        end
    end
    assign is_clk_max = (cnt_clock == C_FREQ / 100000 - 1);

    always @(posedge CLK) begin
        if(RST == 1) begin
            out_buf <= 0;
            cnt_time <= 8'b0;
        end
        else begin
            if(is_clk_max) cnt_time <= cnt_time + 1;
            // 波形生成部。cnt_timeがVAL以上ならLOWにする
            if(cnt_time >= VAL) out_buf <= 0;
            else out_buf <= 1;
        end
    end
endmodule
