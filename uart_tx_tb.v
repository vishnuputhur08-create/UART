module uart_tx_tb();
reg clk_i;
reg rst_ni;
reg data_valid_i;
reg [7:0] data_i;
reg par_en_i;
reg par_typ_i;
wire tx_out_o;
wire busy_o;

uart_tx_top dut(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .data_valid_i(data_valid_i),
    .data_i(data_i),
    .par_en_i(par_en_i),
    .par_typ_i(par_typ_i),
    .tx_out_o(tx_out_o),
    .busy_o(busy_o)
);

always #5 clk_i = ~clk_i;
initial begin

    $dumpfile("uart_tx_tb.vcd");
    $dumpvars(0, uart_tx_tb);
    
    clk_i = 0;
    rst_ni = 0;
    data_valid_i = 0;
    data_i = 8'b0;
    par_en_i = 0;
    par_typ_i = 0;
    #20;
    rst_ni = 1;
    data_valid_i = 1;
    data_i = 8'hB5;
    // par_en_i = 1;
    #60;
    data_valid_i = 0;
    #200;
    $finish;
end
endmodule