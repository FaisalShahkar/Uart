module mux(
    input logic clk_i,
    input logic serial_out_o, // The serial output data coming from the module shift register
    input logic start_o, // Input control signal indicating when to start transmitting data
    output logic Tx // the transmitted data
    );

    always_ff @( clk_i ) begin
        if(start_o)begin
            Tx <= serial_out_o;
        end
        else begin
            Tx <= 1'b1;
        end
    end
endmodule

module shift_reg(
    input logic clk_i,
    input logic reset_i,
    input logic shift_o, // for shifting the data out.When it is high the first bit in the register (shift[0]) is sent out on serial_out_o, and all other bits are shifted one position to the right.
    input logic load_xmt_shftreg_o, // for loading the data.When it is high the 8-bit data is loaded into the shift register (shift).  
    input logic [7:0] data_in, // The 8-bit data to be loaded into the shift register
    output logic serial_out_o // shifted data (he output pin that serially transmits the data bits one by one)
    );

    logic [7:0] shift; //  Internal register to store shifted data

    always_ff @(posedge clk_i ) begin
        if(reset_i)begin
            serial_out_o <= 0;
            end
        else begin
            if(load_xmt_shftreg_o)begin
                shift <= data_in;
            end
        if (shift_o)begin
            serial_out_o <= shift[0]; // In a shift register, data is shifted from one bit position to another,
            shift <= {1'b0,shift[7:1]}; //This effectively shifts the entire data in the register to the right, preparing for the next shift operation.
            end
        end
    end
endmodule

module Baud_Counter(
    input logic clk_i,
    input logic clear_baud_o, // clearing the counter
    output logic counter_baud_of_i // indicating completion of a baud cycle
);

    logic [2:0] baud_counter = 3'b0;

    always_ff @(posedge clk_i ) begin
        if(clear_baud_o)begin
            baud_counter <= baud_counter + 1'b1;
        if (baud_counter == 3'b100)begin
            counter_baud_of_i <= 1'b1;
            baud_counter <= 3'b0;
            end
        else begin
            counter_baud_of_i <= 1'b0;
            end
        end
    end
endmodule

module Bit_Counter(
    input logic clk_i,
    input logic clear_o,  // clearing the counter
    output logic counter_of_i // indicating completion of counting bits
);

    logic [3:0] bit_counter = 4'b0;

    always_ff @(posedge clk_i ) begin
        if(clear_o)begin
            bit_counter <= bit_counter + 1'b1;
            if(bit_counter == 4'b1000)begin
                counter_of_i <= 1'b1;
                bit_counter <= 4'b0;
            end
            else begin
                counter_of_i <= 1'b0;
            end
        end
    end
endmodule