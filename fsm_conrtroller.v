module fsm_controller(
    input clk_i,
    input ser_done_i,
    input rst_ni,
    input data_valid,
    input par_en_i,
    output reg ser_en_o,
    output reg [1:0] mux_sel_o,
    output reg busy_o
);

localparam IDLE = 3'b000,
           START = 3'b001,
           DATA = 3'b010,
           PARITY = 3'b011,
           STOP = 3'b100;

localparam MUX_START = 2'b00,
           MUX_DATA = 2'b01,
           MUX_PARITY = 2'b10,
           MUX_STOP = 2'b11;

reg [2:0] state_reg;
reg [2:0] next_state;

always @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
        state_reg <= IDLE;
    end
    else begin
        state_reg <= next_state;
    end
end

always @(*) begin
    next_state = IDLE;
    ser_en_o = 0;
    mux_sel_o = MUX_START;
    busy_o = 0;
    case (state_reg)
        IDLE : begin
            busy_o = 0;
            mux_sel_o = MUX_STOP;
            if (data_valid) begin
                next_state = START;
                ser_en_o = 1;
            end
            else begin
                next_state = IDLE;
                ser_en_o = 0;
            end
        end
        START : begin
            busy_o = 1;
            next_state = DATA;
            ser_en_o = 0;
            mux_sel_o = MUX_START;
        end
        DATA : begin
            busy_o = 1;
            ser_en_o = 0;
            mux_sel_o = MUX_DATA;
            if (ser_done_i && par_en_i) next_state = PARITY;
            else if(ser_done_i && !par_en_i) next_state = STOP;
            else next_state = DATA;
        end
        PARITY : begin
            busy_o = 1;
            ser_en_o = 0;
            mux_sel_o = MUX_PARITY;
            next_state = STOP;
        end
        STOP : begin
            busy_o = 1;
            ser_en_o = 0;
            mux_sel_o = MUX_STOP;
            next_state = IDLE;
        end
        default : next_state = IDLE;
    endcase
end
endmodule