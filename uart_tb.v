module uart_tb;
reg tx_clk_i;
reg rx_clk_i;
reg rst_ni;

reg par_typ_i;
reg par_en_i;
reg [5:0] prescale_i;

reg [7:0] tx_data_a;
reg tx_valid_a;

reg [7:0] tx_data_b;
reg tx_valid_b;

wire tx_a;
wire tx_b;

wire [7:0] rx_data_a;
wire rx_valid_a;

wire [7:0] rx_data_b;
wire rx_valid_b;

always #(1000/2) tx_clk_i = ~tx_clk_i;
always #((1000/prescale_i)/2) rx_clk_i = ~rx_clk_i;

uart_top uart_a(
    .tx_clk_i(tx_clk_i),
    .rx_clk_i(rx_clk_i),
    .rst_ni(rst_ni),

    .par_typ_i(par_typ_i),
    .par_en_i(par_en_i),
    .prescale_i(prescale_i),

    .tx_data_p_i(tx_data_a),
    .tx_data_valid_i(tx_valid_a),
    .tx_data_s_o(tx_a),
    .tx_busy_o(),
    
    .rx_data_s_i(tx_b),
    .rx_data_p_o(rx_data_a),
    .rx_data_valid_o(rx_valid_a)
);

uart_top uart_b(
    .tx_clk_i(tx_clk_i),
    .rx_clk_i(rx_clk_i),
    .rst_ni(rst_ni),

    .par_typ_i(par_typ_i),
    .par_en_i(par_en_i),
    .prescale_i(prescale_i),

    .tx_data_p_i(tx_data_b),
    .tx_data_valid_i(tx_valid_b),
    .tx_data_s_o(tx_b),
    .tx_busy_o(),
    
    .rx_data_s_i(tx_a),
    .rx_data_p_o(rx_data_b),
    .rx_data_valid_o(rx_valid_b)
);

initial begin

    $dumpfile("uart_top.vcd");
    $dumpvars(0, uart_tb);

    tx_clk_i = 0;
    rx_clk_i = 0;

    rst_ni = 0;

    par_typ_i = 0;
    par_en_i = 0;
    prescale_i = 8;

    tx_data_a = 0;
    tx_valid_a = 0;

    tx_data_b = 0;
    tx_valid_b = 0;

    #5000;
    rst_ni = 1;

    @(negedge tx_clk_i)
    tx_data_a = 8'hA5;
    tx_data_b = 8'hB6;

    tx_valid_a = 1;
    tx_valid_b = 1;

    @(negedge tx_clk_i)
    tx_valid_a = 0;
    tx_valid_b = 0;

    #15000;
    $finish;
end

endmodule