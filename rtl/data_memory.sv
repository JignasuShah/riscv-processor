module data_memory (
    input  logic        clk, 
    input  logic        mem_read, 
    input  logic        mem_write, 
    input  logic [31:0] address, 
    input  logic [31:0] write_data, 
    output logic [31:0] read_data
); 

//Memory block 
logic [31:0] memory [255:0]; 
logic [7:0] addr;


assign addr = address[9:2]; //8 bits to show address (0-255)

always_ff @(posedge clk) begin
    if (mem_write) begin
        memory[addr] <= write_data; 
    end
end

always_comb begin
    if (mem_read) begin
        read_data = memory[addr]; 
    end
    else begin
        read_data = 32'b0; 
    end
    
end



endmodule