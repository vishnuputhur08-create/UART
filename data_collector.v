module data_collector(
    input clk_i,
    input rst_ni,
    input sample_tick_i,
    input rx_sync_i,
    input shift_en_i,
    output reg data_done_o,
    output reg [7:0] data_o
);

reg [2:0] count;

always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
        data_o <= 8'b0;
        count <= 0;
        data_done_o <= 0;
    end
    else if(sample_tick_i && shift_en_i) begin
        data_done_o <= 0;
        if(count != 3'b7) begin
            data_o <= {rx_sync_i,data_o[7:1]};
            count <= count + 1;
        end
        else if(count == 3'b7) begin
            data_o <= {rx_sync_i,data_o[7:1]};
            count <= 0;
            data_done_o <= 1;
        end
    end
end
endmodule