module uart_top(
    input tx_clk_i,
    input rx_clk_i,
    input rst_ni,

    input par_typ_i,
    input par_en_i,
    input [5:0] prescale_i,

    input [7:0] tx_data_p_i,
    input tx_data_valid_i,
    output wire tx_data_s_o,
    output wire tx_busy_o,
    
    input rx_data_s_i,
    output wire [7:0] rx_data_p_o,
    output wire rx_data_valid_o
);

wire rx_stop_error;
wire rx_parity_error;

uart_tx_top uart_tx_top_inst(
    .clk_i(tx_clk_i),
    .rst_ni(rst_ni),
    .data_valid_i(tx_data_valid_i),
    .data_i(tx_data_p_i),
    .par_en_i(par_en_i),
    .par_typ_i(par_typ_i),
    .tx_out_o(tx_data_s_o),
    .busy_o(tx_busy_o)
);

uart_rx_top uart_rx_top_inst(
    .clk_i(rx_clk_i),
    .rst_ni(rst_ni),
    .rx_in_i(rx_data_s_i),
    .prescale_i(prescale_i),
    .parity_en_i(par_en_i),
    .parity_type_i(par_typ_i),
    .data_o(rx_data_p_o),
    .parity_error_o(rx_parity_error),
    .data_valid_o(rx_data_valid_o),
    .stop_error_o(rx_stop_error)
);

endmodule