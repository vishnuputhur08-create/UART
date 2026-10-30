module serializer(
    input clk_i,
    input rst_ni,
    input ser_en_i,
    input [7:0] data_i,
    output reg data_o,
    output wire ser_done_o
);

reg [7:0] data_reg;
reg active;
reg [3:0] bit_count;
assign ser_done_o = active && (bit_count == 4'd8);

always @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
        data_o <= 1;
        bit_count <= 0;
        active <= 0;
    end
    else if(ser_en_i && !active) begin
        data_reg <= data_i;
        active <= 1;
        bit_count <= 0;
    end
    else if(active && bit_count != 4'd8) begin
        data_o <= data_reg[0];
        data_reg <= data_reg >> 1;
        bit_count <= bit_count + 1;
    end
    else if(bit_count == 4'd8) begin
        active <= 0;
    end
end
endmodule