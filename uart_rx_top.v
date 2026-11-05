module uart_rx_top(
    input clk_i,
    input rst_ni,
    input rx_in_i,
    input [5:0] prescale_i,
    input parity_en_i,
    input parity_type_i,
    output reg [7:0] data_o,
    output wire parity_error_o,
    output reg data_valid_o,
    output wire stop_error_o
);

wire start_bit;
wire data_done;
wire sample_tick;
wire rx_sync;
wire shift_en;
wire [7:0] data;
wire parity_bit;
wire check_done;
wire check_en;
wire parity_en;
wire parity_done;
wire parity_error;
wire abort;

assign parity_error_o = parity_en_i ? parity_error : 1'b0;

always @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
        data_valid_o <= 0;
        data_o <= 0;
    end
    else begin
        data_valid_o <= 0;
        if(check_done) begin
            data_o <= data;
            if(!stop_error_o && (!parity_en_i || !parity_error)) begin
                data_valid_o <= 1;
            end
        end
    end
end

start_bit_detector start_bit_detector_inst(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .rx_in_i(rx_in_i),
    .start_bit_o(start_bit),
    .rx_sync_o(rx_sync)
);

rx_timing_counter rx_timing_counter_inst(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .start_bit_i(start_bit),
    .prescale_i(prescale_i),
    .frame_done_i(check_done),
    .sample_tick_o(sample_tick),
    .abort_i(abort)
);

data_collector data_collector_inst(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .sample_tick_i(sample_tick),
    .rx_sync_i(rx_sync),
    .shift_en_i(shift_en),
    .data_done_o(data_done),
    .data_o(data)
);

parity_bit_collector parity_bit_collector_inst(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .sample_tick_i(sample_tick),
    .rx_sync_i(rx_sync),
    .parity_en_i(parity_en),
    .parity_done_o(parity_done),
    .parity_bit_o(parity_bit)
);

parity_checker parity_checker_inst(
    .data_i(data),
    .parity_type_i(parity_type_i),
    .parity_bit_i(parity_bit),
    .parity_error_o(parity_error)
);

stop_bit_checker stop_bit_checker_inst(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .sample_tick_i(sample_tick),
    .check_en_i(check_en),
    .rx_sync_i(rx_sync),
    .stop_bit_error_o(stop_error_o),
    .check_done_o(check_done)
);

rx_controller rx_controller_inst(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .sample_tick_i(sample_tick),
    .rx_sync_i(rx_sync),
    .data_done_i(data_done),
    .check_done_i(check_done),
    .parity_en_i(parity_en_i),
    .parity_done_i(parity_done),
    .start_bit_i(start_bit),
    .shift_en_o(shift_en),
    .check_en_o(check_en),
    .parity_en_o(parity_en),
    .abort_o(abort)
);

endmodule