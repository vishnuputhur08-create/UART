module rx_controller(
    input clk_i,
    input rst_ni,
    input sample_tick_i,
    input rx_sync_i,
    input data_done_i,
    input check_done_i,
    input parity_en_i,
    input parity_done_i,
    input start_bit_i,
    output shift_en_o,
    output check_en_o,
    output parity_en_o,
    output abort_o
);

localparam IDLE         = 3'b000,
           START_CHECK  = 3'b001,
           DATA_RECEIVE = 3'b010,
           STOP_CHECK   = 3'b011,
           PARITY_CHECK = 3'b100;

reg [2:0] current_state;
reg [2:0] next_state;

assign shift_en_o = (current_state == DATA_RECEIVE);
assign check_en_o = (current_state == STOP_CHECK);
assign parity_en_o = (current_state == PARITY_CHECK);
assign abort_o = (current_state == START_CHECK) && sample_tick_i && rx_sync_i;
always @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = current_state;
    case (current_state)
        IDLE : begin
            if (start_bit_i) next_state = START_CHECK;
        end
        START_CHECK : begin
            if(sample_tick_i) begin
                if(!rx_sync_i) next_state = DATA_RECEIVE;
                else next_state = IDLE;
            end
        end
        DATA_RECEIVE : begin
            if(data_done_i) begin
                if(parity_en_i) next_state = PARITY_CHECK;
                else next_state = STOP_CHECK;
            end
        end
        PARITY_CHECK : begin
            if(parity_done_i) next_state = STOP_CHECK;
        end
        STOP_CHECK : begin
            if (check_done_i) next_state = IDLE;
        end
        default : next_state = IDLE;
    endcase

end


endmodule