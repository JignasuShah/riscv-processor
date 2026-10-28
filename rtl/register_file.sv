module register_file(
    input  logic        clk, 
    input  logic        write_en, 
    input  logic [4:0]  write_addr, 
    input  logic [31:0] write_data, 
    input  logic [4:0]  read_addr_one, 
    input  logic [4:0]  read_addr_two, 
    output logic [31:0] read_data_one, 
    output logic [31:0] read_data_two
);

//Memory block 
logic [31:0] memory[31:0]; 

always_ff @(posedge clk) begin
    if (write_en && write_addr != 5'b0) begin
        memory[write_addr] <= write_data; 
    end
end

assign read_data_one = (read_addr_one == 5'b0) ? 32'b0 : memory[read_addr_one];
assign read_data_two = (read_addr_two == 5'b0) ? 32'b0 : memory[read_addr_two]; 


endmodule