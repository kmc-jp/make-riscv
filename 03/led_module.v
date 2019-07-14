`timescale 1ns / 1ps

// トップレベルモジュール
// TODO: CLK, RST, LEDS(2 から 0)にピンを紐づける
module led_module(CLK, RST, LEDS);
    input CLK, RST;
    // LED信号。ここではフルカラーLEDの各色チャネルにつなげることを想定しているが、PWM信号を渡して何かが起こるものなら何でも良い
    output [2:0] LEDS;

    // クロックから10ms周期のパルスを得るためのカウンタ
    reg [31:0] cnt_clock;
    wire is_clk_max;
    
    // 各チャネルのデューティー比
    reg [7:0] lb_r;
    reg [7:0] lb_g;
    reg [7:0] lb_b;
    
    // クロック周波数
    parameter CLK_FREQ = 12000000;

    pwm_modulator mb(CLK, RST, lb_b, LEDS[0], CLK_FREQ);
    pwm_modulator mg(CLK, RST, lb_g, LEDS[1], CLK_FREQ);
    pwm_modulator mr(CLK, RST, lb_r, LEDS[2], CLK_FREQ);
    
    always @(posedge CLK) begin
        if(RST == 1) cnt_clock <= 0;
        else begin
            if(cnt_clock >= CLK_FREQ / 100 - 1) cnt_clock <= 0;
            else cnt_clock <= cnt_clock + 1;
        end
    end
    assign is_clk_max = (cnt_clock == CLK_FREQ / 100 - 1);

    // いろいろな周期、位相で変調波を出す
    always @(posedge CLK) begin
        if(RST == 1) begin
            lb_r <= 8'd0;
            lb_g <= 8'd85;
            lb_b <= 8'd171;
        end
        else begin
            if(is_clk_max) begin
                lb_r <= lb_r + 1;
                lb_g <= lb_g + 2;
                lb_b <= lb_b + 4;
            end
        end
    end
endmodule
