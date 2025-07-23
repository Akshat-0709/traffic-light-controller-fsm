// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module traffic_light_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg sensor;
    wire [1:0] highway;
    wire [1:0] side;

    // Instantiate the DUT (Device Under Test)
    traffic_light_controller uut (
        .clk(clk),
        .reset(reset),
        .sensor(sensor),
        .highway(highway),
        .side(side)
    );

    // Clock generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    // Stimulus block
    initial begin
        // VCD waveform setup
        $dumpfile("dump.vcd");     // Create VCD file for waveform
        $dumpvars(0, traffic_light_tb); // Dump all variables recursively

        // Display for command line (optional)
        $display("Time\tReset\tSensor\tHighway\tSide");
        $monitor("%0t\t%b\t%b\t%b\t%b", $time, reset, sensor, highway, side);

        // Initialize
        clk = 0;
        reset = 1;
        sensor = 0;

        // Reset pulse
        #10 reset = 0;

        // Let system run with no car (sensor = 0)
        #100;

        // Car appears on side road
        sensor = 1;
        #20;

        // Car disappears
        sensor = 0;
        #300;

        // Another car comes later
        #50 sensor = 1;
        #20 sensor = 0;

        #300;

        $finish;
    end

endmodule
