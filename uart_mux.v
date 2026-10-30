module uart_mux(
    input [1:0] mux_sel_i,
    input ser_data_i,
    input parity_bit_i,
    output tx_out_o
);
assign tx_out_o = (mux_sel_i == 2'b00) ? 0 :
                  (mux_sel_i == 2'b01) ? ser_data_i :
                  (mux_sel_i == 2'b10) ? parity_bit_i : 1;

endmodule