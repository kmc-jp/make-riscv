`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2019 03:27:08 PM
// Design Name: 
// Module Name: led_module
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


module led_module(CLK, RST, LEDS);
    input CLK, RST;
    output [2:0] LEDS;
    
    reg [31:0] cnt_clock;
    wire is_clk_max;
    
    reg [7:0] lb_r;
    reg [7:0] lb_g;
    reg [7:0] lb_b;

    pwm_modulator mb(CLK, RST, lb_b, LEDS[0]);
    pwm_modulator mg(CLK, RST, lb_g, LEDS[1]);
    pwm_modulator mr(CLK, RST, lb_r, LEDS[2]);
    
    always @(posedge CLK) begin
        if(RST == 1) cnt_clock <= 0;
        else begin
            if(cnt_clock >= CLK_FREQ / 100 - 1) cnt_clock <= 0;
            else cnt_clock <= cnt_clock + 1;
        end
    end
    assign is_clk_max = (cnt_clock == CLK_FREQ / 100 - 1);
    
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
