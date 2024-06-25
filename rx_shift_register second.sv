module shift_register (
    input logic clk, rst, Reg_Start, Ready, Din,
    input logic [7:0]sync_read;
    output logic [7:0]data_receive
); 
    logic [7:0] next_data;
    logic [7:0] internal_shift_register, sync_read; //synckey is an internal logic to store the byte from the xbee, which allows the register to read the byte and see if its the synckey or not

    always_ff @(posedge clk, posedge rst) begin
	    if (rst) begin
		    data_receive <= 8'b0; //resets register
	    end 
	    else begin
        data_receive <= next_data; //this is the endless shifting, it will always keep shifitng even if its not receiving the syncdata
        //this allows us to keep shifting so we can ready the entire byte to look for synckey
	      end
      end

    always_comb begin
      sync_read = internal_shift_register; //we store the shifter byte into sync_read to read the byte
        if (sync_read == {8'b00000000}) begin //this is just an example of the possible synckey we could make
          if (Ready == 1) begin
            next_data = {Din, internal_shift_register[7:1]};
          end
          else 
            next_data = 8'b0;
        end
        else begin
          next_data = 8'b0;
        end
    end
endmodule

module rx_shift_register (
    input logic clk, rst, Reg_Start, Ready, Din,
    input logic [7:0] sync_read,
    output logic [7:0] data_receive
);
    logic [7:0] internal_shift_register;

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            internal_shift_register <= 8'b0; // Reset internal shift register
        end else begin
            internal_shift_register <= {Din, internal_shift_register[7:1]}; // Shift data
        end
    end

    always_comb begin
        // Detect sync key (example: sync key is {8'b11001101})
        if (sync_read == {8'b11001101}) begin
            if (Ready == 1) begin
                data_receive = internal_shift_register; // Set data_receive when sync key detected
            end else begin
                data_receive = 8'b0; // Clear data_receive if not ready
            end
        end else begin
            data_receive = 8'b0; // No sync key detected
        end
    end
endmodule
