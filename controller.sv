module controller(
    input logic clk_i,
    input logic reset_i,
    input logic byte_ready_i, //A signal indicating that new data is ready to be loaded into the shift register.
    input logic counter_baud_of_i, //Indicates when the baud counter reaches a certain count
    input logic counter_of_i, // Indicates when the bit counter reaches a certain count
    input logic t_byte_i  // Indicates when a byte is ready to be transmitted.
    output logic load_xmt_shftreg_o, // for loading data into the shift register
    output logic start_o,  // for starting data transmission
    output logic clear_o,  // Clearing the bit counter to prepare for a new byte
    output logic clear_baud_o, // Clearing the baud rate counter
    output logic shift_o // controls the shifting operation in the shift register to send out data bits sequentially
    );

    logic [1:0] state,next_State;
    //define the three possible states of the FSM.
    localparam S0=2'b00; //idle state
    localparam S1=2'b01; // load state
    localparam S2=2'b10; // transmission  state

    always_ff @( negedge clk_i ) 
    begin
        if (reset_i)begin
            state <= S0;
        end
        else begin
            state <= next_State;
        end
    end
    
    always_ff @( posedge clk_i ) 
    begin
        case (state)
            S0:if(!byte_ready_i)begin // no new data ready, it stays in S0.
                clear_baud_o <= 1'b1;
                clear_o <= 1'b1;
                load_xmt_shftreg_o <= 1'b1;
                next_State <= S0;
            end
            else if(byte_ready_i) begin // new data ready
                clear_baud_o <= 1'b1;
                clear_o <= 1'b1;
                load_xmt_shftreg_o <= 1'b0;
                next_State <= S1;
            end
            S1:if(!t_byte_i)begin
                clear_o <= 1'b1;
                clear_baud_o <= 1'b1;
                load_xmt_shftreg_o <= 1'b1;
                next_State <= S1;
            end
            else if(t_byte_i)begin
                clear_o <= 1'b1;
                clear_baud_o <= 1'b1;
                load_xmt_shftreg_o <= 0;
                next_State <= S2;
            end
            S2: if(!counter_of_i && !counter_baud_of_i)begin //If both counters are not asserted, it asserts start_o and clears shift_o to start transmission and data shifting
                start_o <= 1'b1;
                shift_o <= 1'b0;
                next_State <= S2;
            end
            else if(!counter_of_i && counter_baud_of_i)begin // end of baud period
                start_o <= 1'b1;
                shift_o <= 1'b1;
                next_State <= S2;
            end
            else if(counter_of_i && !counter_baud_of_i)begin //If only counter_of_i is asserted, it enables start_o to continue transmission without shifting.
                start_o <= 1'b1;
                shift_o <= 1'b0;
                next_State <= S2;
            end
            else if(counter_of_i && counter_baud_of_i)begin //If both counters are asserted, it clears start_o and shift_o, returning to state S0 to prepare for the next transmission.
                start_o <= 1'b0;
                shift_o <= 1'b0;
                next_State <= S0;
            end
        endcase
    end
endmodule