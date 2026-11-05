module start_bit_detector(
    input clk_i,
    input rst_ni,
    input rx_in_i,
    output start_bit_o,
    output rx_sync_o
);
reg rx_meta;
reg rx_sync;
reg rx_prev;

assign rx_sync_o = rx_sync;

always @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
        rx_meta <= 1'b1;
        rx_sync <= 1'b1;
        rx_prev <= 1'b1;
    end
    else begin
        rx_meta <= rx_in_i;
        rx_sync <= rx_meta;
        rx_prev <= rx_sync;
    end
end

assign start_bit_o = rx_prev && !rx_sync;

endmodule