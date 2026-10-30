module uart_tx_top(
    input clk_i,
    input rst_ni,
    input data_valid_i,
    input [7:0] data_i,
    input par_en_i,
    input par_typ_i,
    output tx_out_o,
    output busy_o
);

wire ser_en;
wire ser_data;
wire ser_done;
wire [1:0] mux_sel;
wire parity_bit;
reg [7:0] data_reg;

always @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
        data_reg <= 8'b0;
    end
    else if(data_valid_i && !busy_o) begin
        data_reg <= data_i;
    end
end

fsm_controller fsm_controller_inst(
    .clk_i(clk_i),
    .ser_done_i(ser_done),
    .rst_ni(rst_ni),
    .data_valid(data_valid_i),
    .par_en_i(par_en_i),
    .ser_en_o(ser_en),
    .mux_sel_o(mux_sel),
    .busy_o(busy_o)
);

serializer serializer_inst(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .ser_en_i(ser_en),
    .data_i(data_i),
    .data_o(ser_data),
    .ser_done_o(ser_done)
);

parity_calc parity_calc_inst(
    .data_i(data_reg),
    .parity_type(par_typ_i),
    .parity_o(parity_bit)
);

uart_mux uart_mux_inst(
    .mux_sel_i(mux_sel),
    .ser_data_i(ser_data),
    .parity_bit_i(parity_bit),
    .tx_out_o(tx_out_o)
);

endmodule