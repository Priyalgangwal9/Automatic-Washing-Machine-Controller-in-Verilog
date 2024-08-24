`timescale 10ns / 1ps

//////////////////////
module AutoWashing_machine(
    clk, reset, door_closed, start_button, water_filled, detergent_added, cycle_complete, water_drained, spin_complete,
    door_locked, motor_active, fill_valve_open, drain_valve_open, operation_done, detergent_cycle, rinse_cycle
);

    input clk, reset, door_closed, start_button, water_filled, detergent_added, cycle_complete, water_drained, spin_complete;
    output reg door_locked, motor_active, fill_valve_open, drain_valve_open, operation_done, detergent_cycle, rinse_cycle; 
    
    // Defining the states
    parameter CHECK_DOOR = 3'b000;
    parameter FILL_WATER = 3'b001;
    parameter ADD_DETERGENT = 3'b010;
    parameter WASH_CYCLE = 3'b011;
    parameter DRAIN_WATER = 3'b100;
    parameter SPIN_CYCLE = 3'b101;
    
    reg [2:0] current_state, next_state;
    
    always @(current_state or start_button or door_closed or water_filled or detergent_added or water_drained or cycle_complete or spin_complete) begin
        case (current_state)
            CHECK_DOOR: begin
                if (start_button == 1 && door_closed == 1) begin
                    next_state = FILL_WATER;
                    motor_active = 0;
                    fill_valve_open = 0;
                    drain_valve_open = 0;
                    door_locked = 1;
                    detergent_cycle = 0;
                    rinse_cycle = 0;
                    operation_done = 0;
                end else begin
                    next_state = current_state;
                    motor_active = 0;
                    fill_valve_open = 0;
                    drain_valve_open = 0;
                    door_locked = 0;
                    detergent_cycle = 0;
                    rinse_cycle = 0;
                    operation_done = 0;
                end
            end

            FILL_WATER: begin
                if (water_filled == 1) begin
                    if (detergent_cycle == 0) begin
                        next_state = ADD_DETERGENT;
                        motor_active = 0;
                        fill_valve_open = 0;
                        drain_valve_open = 0;
                        door_locked = 1;
                        detergent_cycle = 1;
                        rinse_cycle = 0;
                        operation_done = 0;
                    end else begin
                        next_state = WASH_CYCLE;
                        motor_active = 0;
                        fill_valve_open = 0;
                        drain_valve_open = 0;
                        door_locked = 1;
                        detergent_cycle = 1;
                        rinse_cycle = 1;
                        operation_done = 0;
                    end
                end else begin
                    next_state = current_state;
                    motor_active = 0;
                    fill_valve_open = 1;
                    drain_valve_open = 0;
                    door_locked = 1;
                    operation_done = 0;
                end
            end

            ADD_DETERGENT: begin
                if (detergent_added == 1) begin
                    next_state = WASH_CYCLE;
                    motor_active = 0;
                    fill_valve_open = 0;
                    drain_valve_open = 0;
                    door_locked = 1;
                    detergent_cycle = 1;
                    operation_done = 0;
                end else begin
                    next_state = current_state;
                    motor_active = 0;
                    fill_valve_open = 0;
                    drain_valve_open = 0;
                    door_locked = 1;
                    detergent_cycle = 1;
                    rinse_cycle = 0;
                    operation_done = 0;
                end
            end

            WASH_CYCLE: begin
                if (cycle_complete == 1) begin
                    next_state = DRAIN_WATER;
                    motor_active = 0;
                    fill_valve_open = 0;
                    drain_valve_open = 0;
                    door_locked = 1;
                    operation_done = 0;
                end else begin
                    next_state = current_state;
                    motor_active = 1;
                    fill_valve_open = 0;
                    drain_valve_open = 0;
                    door_locked = 1;
                    operation_done = 0;
                end
            end

            DRAIN_WATER: begin
                if (water_drained == 1) begin
                    if (rinse_cycle == 0) begin
                        next_state = FILL_WATER;
                        motor_active = 0;
                        fill_valve_open = 0;
                        drain_valve_open = 0;
                        door_locked = 1;
                        detergent_cycle = 1;
                        operation_done = 0;
                    end else begin
                        next_state = SPIN_CYCLE;
                        motor_active = 0;
                        fill_valve_open = 0;
                        drain_valve_open = 0;
                        door_locked = 1;
                        detergent_cycle = 1;
                        rinse_cycle = 1;
                        operation_done = 0;
                    end
                end else begin
                    next_state = current_state;
                    motor_active = 0;
                    fill_valve_open = 0;
                    drain_valve_open = 1;
                    door_locked = 1;
                    detergent_cycle = 1;
                    operation_done = 0;
                end
            end

            SPIN_CYCLE: begin
                if (spin_complete == 1) begin
                    next_state = CHECK_DOOR;
                    motor_active = 0;
                    fill_valve_open = 0;
                    drain_valve_open = 0;
                    door_locked = 1;
                    detergent_cycle = 1;
                    rinse_cycle = 1;
                    operation_done = 1;
                end else begin
                    next_state = current_state;
                    motor_active = 0;
                    fill_valve_open = 0;
                    drain_valve_open = 1;
                    door_locked = 1;
                    detergent_cycle = 1;
                    rinse_cycle = 1;
                    operation_done = 0;
                end
            end

            default: begin
                next_state = CHECK_DOOR;
            end
        endcase
    end
    
    always @(posedge clk or negedge reset) begin
        if (reset) begin
            current_state <= CHECK_DOOR;
        end else begin
            current_state <= next_state;
        end
    end
    
endmodule
