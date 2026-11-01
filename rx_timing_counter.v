module rx_timing_counter(
    input clk_i,
    input rst_ni,
    input start_bit_i,
    input [5:0] prescale_i,
    input data_done_i,
    output reg sample_tick_o
);

reg [5:0] count;
reg counting;
reg first_sample;

always @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
        sample_tick_o <= 0;
        count <= 0;
        counting <= 0;
        first_sample <= 0;
    end
    else begin
        sample_tick_o <= 0;
        if(data_done_i) begin
            count <= 0;
            counting <= 0;
            first_sample <= 0;
        end
        else if(start_bit_i && !counting) begin
            count <= 0;
            counting <= 1;
            first_sample <= 1;
        end
        else if(counting && first_sample) begin
            if(count == (prescale_i/2)-1'b1) begin
                sample_tick_o <= 1;
                count <= 0;
                first_sample <= 0;
            end
            else count <= count + 1;
        end
        else if(counting && !first_sample) begin
            if(count == prescale_i-1) begin
                sample_tick_o <= 1;
                count <= 0;
                first_sample <= 0;
            end
            else count <= count + 1;
        end
    end
end
endmodule