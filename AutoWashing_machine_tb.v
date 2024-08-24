module AutoWashing_machine_tb();
    reg clk, reset, door_closed, start_button, water_filled, detergent_added, cycle_complete, water_drained, spin_complete;
    wire door_locked, motor_active, fill_valve_open, drain_valve_open, operation_done, detergent_cycle, rinse_cycle;

    // Instantiate your automatic washing machine module
    AutoWashing_machine machine1(
        clk, reset, door_closed, start_button, water_filled, detergent_added, cycle_complete, water_drained, spin_complete,
        door_locked, motor_active, fill_valve_open, drain_valve_open, operation_done, detergent_cycle, rinse_cycle
    );

    initial begin
        $dumpfile("AutoWashing_machine_tb.vcd");
        $dumpvars(0, AutoWashing_machine_tb);

        clk = 0;
        reset = 1;
        start_button = 0;
        door_closed = 0;
        water_filled = 0;
        water_drained = 0;
        detergent_added = 0;
        cycle_complete = 0;
        spin_complete = 0;

        #5 reset = 0;
        #5 start_button = 1; door_closed = 1;
        #10 water_filled = 1;
        #10 detergent_added = 1;
        #10 cycle_complete = 1;
        #10 water_drained = 1;
        #10 spin_complete = 1;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Monitoring
    initial begin
        $monitor("Time=%d, Clock=%b, Reset=%b, start_button=%b, door_closed=%b, water_filled=%b, detergent_added=%b, cycle_complete=%b, water_drained=%b, spin_complete=%b, door_locked=%b, motor_active=%b, fill_valve_open=%b, drain_valve_open=%b, detergent_cycle=%b, rinse_cycle=%b, operation_done=%b",
        $time, clk, reset, start_button, door_closed, water_filled, detergent_added, cycle_complete, water_drained, spin_complete, door_locked, motor_active, fill_valve_open, drain_valve_open, detergent_cycle, rinse_cycle, operation_done);
    end

    // Ensure simulation ends properly
    initial begin
        #1000; // Adjust time as needed
        $finish;
    end

endmodule
