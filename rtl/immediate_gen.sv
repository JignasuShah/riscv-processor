module immediate_gen (
    input  logic [31:0] instruction, 
    input  logic [2:0]  format, 
    output logic [31:0] imm
); 

/*
000 - R Type
001 - I Type 
010 - S Type 
011 - B Type
100 - U Type 
101 - J Type 
*/

localparam logic [2:0] R = 3'b000; 
localparam logic [2:0] I = 3'b001; 
localparam logic [2:0] S = 3'b010; 
localparam logic [2:0] B = 3'b011; 
localparam logic [2:0] U = 3'b100;
localparam logic [2:0] J = 3'b101;  

always_comb begin
    case(format)
        I: imm = {{20{instruction[31]}}, instruction[31:20]}; 
        S: imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; 
        B: imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; 
        U: imm = {instruction[31:12], 12'b0}; 
        J: imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; 
        default: imm = 32'b0; 
    endcase
end

endmodule