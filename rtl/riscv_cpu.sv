module riscv_cpu (
    input clk
); 

logic [31:0] pc; 
logic [31:0] instruction; 

logic [4:0] rd, rs1, rs2;
assign rd = instruction[11:7]; 
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];

logic [3:0]  alu_control; 
logic [2:0]  imm_format;
logic [2:0]  branch_logic;
logic [1:0]  wb_select;
logic        reg_write_en; 
logic        alu_src;
logic        mem_read; 
logic        mem_write; 
logic        branch; 
logic        jump;
logic        alu_operand_one_pc; 

logic [31:0] writeback_data; 
logic [31:0] read_data_one; 
logic [31:0] read_data_two; 

logic [31:0] generated_imm; 

logic [31:0] alu_result; 


initial begin
    pc = 32'b0; 
end


always_ff @(posedge clk) begin
    pc <= pc + 32'd4; 
end

instruction_memory inst_mem(
    .pc(pc), 
    .instruction(instruction)
); 

control_unit cont_unit(
    .instruction(instruction), 
    .alu_control(alu_control),
    .imm_format(imm_format), 
    .branch_logic(branch_logic), 
    .wb_select(wb_select), 
    .reg_write_en(reg_write_en), 
    .alu_src(alu_src), 
    .mem_read(mem_read), 
    .mem_write(mem_write), 
    .branch(branch), 
    .jump(jump), 
    .alu_operand_one_pc(alu_operand_one_pc)
); 

register_file reg_file(
    .clk(clk), 
    .write_en(reg_write_en), 
    .write_addr(rd), 
    .write_data(writeback_data), 
    .read_addr_one(rs1), 
    .read_addr_two(rs2), 
    .read_data_one(read_data_one), 
    .read_data_two(read_data_two)
); 

immediate_gen imm_gen(
    .instruction(instruction), 
    .format(imm_format), 
    .imm(generated_imm)
); 

logic [31:0] operand_one; 
logic [31:0] operand_two; 

always_comb begin
    operand_two = (alu_src) ? generated_imm : read_data_two; 
    operand_one = (alu_operand_one_pc) ? pc : read_data_one; 
end

alu alu_main(
    .operand_one(operand_one), 
    .operand_two(operand_two), 
    .alu_control(alu_control), 
    .result(alu_result)
); 



endmodule