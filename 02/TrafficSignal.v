`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2019 02:02:30 PM
// Design Name: 
// Module Name: TrafficSignal
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// 定数はparameterとして組み込むこともできる
parameter S_RED = 0;
parameter S_GREEN = 1;
parameter S_YELLOW = 2;

parameter CLK_FREQ = 12000000;
parameter G_PERIOD_MS = 5000;
parameter Y_PERIOD_MS = 1000;
parameter R_PERIOD_MS = 8000;

module TrafficSignal(CLK, RST, CLED);
    // 入出力ポート
    input CLK, RST;
    output [2:0] CLED;
    
    // LEDの表示バッファ
    reg [2:0] led_buf;
    // 信号機の状態
    reg [1:0] sig_state;
    // タイマーカウンタ（これが1msごとに増える）
    reg [31:0] cnt_time;
    // 分周用カウンタ（クロック信号ごとに増える）
    reg [31:0] cnt_clock;
    // 分周用カウンタ満了信号
    wire is_clk_max;
    
    // 配線
    assign CLED = led_buf;
    
    // alwaysブロックは原則全部並行処理される
    // 両方のブロックで同じ変数を操作したり信号をドライブしたりするとエラーになる
    
    // 分周部分
    always @(posedge CLK) begin
        if(RST == 1) cnt_clock <= 0;
        else begin
            if(cnt_clock >= CLK_FREQ / 1000) cnt_clock <= 0;
            else cnt_clock <= cnt_clock + 1;
        end
    end
    assign is_clk_max = (cnt_clock == CLK_FREQ / 1000);
    
    // 状態変更部
    always @(posedge CLK) begin
        if(RST == 1) begin
            cnt_time <= 0;
            sig_state <= S_RED;
        end
        else begin
            case(sig_state)
            S_RED: begin
                if(cnt_time >= R_PERIOD_MS) begin
                    cnt_time <= 0;
                    sig_state <= S_GREEN;
                end
                else if(is_clk_max) cnt_time <= cnt_time + 1;
            end
            S_GREEN: begin
                if(cnt_time >= G_PERIOD_MS) begin
                    cnt_time <= 0;
                    sig_state <= S_YELLOW;
                end
                else if(is_clk_max) cnt_time <= cnt_time + 1;
            end
            S_YELLOW: begin
                if(cnt_time >= Y_PERIOD_MS) begin
                    cnt_time <= 0;
                    sig_state <= S_RED;
                end
                else if(is_clk_max) cnt_time <= cnt_time + 1;
            end
            default:
                // ここにはこない
                ;
            endcase
        end
    end
    
    // 表示部
    always @(sig_state) begin
        case(sig_state)
        S_RED: led_buf = 3'b011;
        S_GREEN: led_buf = 3'b101;
        S_YELLOW:led_buf = 3'b001;
        default: led_buf = 3'b000;
        endcase
    end
    
endmodule
