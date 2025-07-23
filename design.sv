// Code your design here
`timescale 1ns / 1ps

module traffic_light_controller(
    input clk,
    input reset,
    input sensor,
    output reg [1:0] highway,
    output reg [1:0] side
);

    // Light encoding
    parameter RED = 2'b00;
    parameter YELLOW = 2'b01;
    parameter GREEN = 2'b10;

    // FSM States
    parameter S0 = 2'b00,  // Highway Green, Side Red
              S1 = 2'b01,  // Highway Yellow, Side Red
              S2 = 2'b10,  // Highway Red, Side Green
              S3 = 2'b11;  // Highway Red, Side Yellow

    reg [1:0] state, next_state;
    reg [2:0] timer;

    // Sequential Block: State transition and timer update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            timer <= 0;
        end else begin
            state <= next_state;
            if (state != next_state)
                timer <= 0;
            else
                timer <= timer + 1;
        end
    end

    // Combinational Block: Next state logic
    always @(*) begin
        case (state)
            S0: next_state = (sensor) ? S1 : S0;
            S1: next_state = (timer == 3) ? S2 : S1;
            S2: next_state = (timer == 5) ? S3 : S2;
            S3: next_state = (timer == 3) ? S0 : S3;
            default: next_state = S0;
        endcase
    end

    // Combinational Block: Output logic
    always @(*) begin
        case (state)
            S0: begin
                highway = GREEN;
                side = RED;
            end
            S1: begin
                highway = YELLOW;
                side = RED;
            end
            S2: begin
                highway = RED;
                side = GREEN;
            end
            S3: begin
                highway = RED;
                side = YELLOW;
            end
            default: begin
                highway = RED;
                side = RED;
            end
        endcase
    end

endmodule

