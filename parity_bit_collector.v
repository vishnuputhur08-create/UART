module parity_bit_collector(
    input clk_i,
    input rst_ni,
    input sample_tick_i,
    input rx_sync_i,
    input parity_en_i,
    output reg parity_done_o,
    output reg parity_bit_o
);

always @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
        parity_bit_o <= 0;
        parity_done_o <= 0;
    end
    else begin
        parity_done_o <= 0;
        if(sample_tick_i && parity_en_i) begin
            parity_bit_o <= rx_sync_i;
            parity_done_o <= 1;
        end
    end
end

endmodule