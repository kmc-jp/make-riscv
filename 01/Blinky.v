`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2019 04:45:28 PM
// Design Name: 
// Module Name: Blinky
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


// module definition
module Blinky(
    RST, CLK, LED
    );

    // define input and output
    input RST, CLK;
    output LED;

    // registers definition
    reg [31:0] cnt_led;    // 32bit counter for blinking the LED
    reg led_buf;           // stores the current state of the LED

    // connect led_buf to LED
    assign LED = led_buf;

    initial begin
        cnt_led <= 32'd0;  // cnt_led = 0
        led_buf <= 0;      // set led_buf to 0
    end

    always @(posedge CLK) begin
        // reset the counter and LED buffer
        if(RST == 1) begin
            cnt_led <= 32'd0;
            led_buf <= 0;
        end
        else begin
            if(cnt_led >= 32'd62500000) begin
                cnt_led <= 32'd0;
                led_buf <= ~led_buf;  // negate the state
            end
            else begin
                cnt_led <= cnt_led + 32'd1;
            end
        end
    end

endmodule
