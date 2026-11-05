module stop_bit_checker(
    input clk_i,
    input rst_ni,
    input sample_tick_i,
    input check_en_i,
    input rx_sync_i,
    output reg stop_bit_error_o,
    output reg check_done_o
);

always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
        stop_bit_error_o <= 0;
        check_done_o <= 0;
    end
    else begin
        check_done_o <= 0;
        if(sample_tick_i && check_en_i) begin
            stop_bit_error_o <= !rx_sync_i;
            check_done_o <= 1;
        end
    end    
end
endmodule
