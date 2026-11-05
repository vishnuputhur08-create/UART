module uart_rx_tb;
    reg clk_i;
    reg rst_ni;
    reg rx_in_i;
    reg [5:0] prescale_i;
    reg parity_en_i;
    reg parity_type_i;
    wire [7:0] data_o;
    wire parity_error_o;
    wire data_valid_o;
    wire stop_error_o;

uart_rx_top dut(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .rx_in_i(rx_in_i),
    .prescale_i(prescale_i),
    .parity_en_i(parity_en_i),
    .parity_type_i(parity_type_i),
    .data_o(data_o),
    .parity_error_o(parity_error_o),
    .data_valid_o(data_valid_o),
    .stop_error_o(stop_error_o)
);

reg valid_seen;

always #5 clk_i = ~clk_i;

always @(posedge clk_i) begin
    if(!rst_ni) valid_seen <= 0;
    else if(data_valid_o) valid_seen <= 1;
end

task uart_send_byte;
    input [7:0] tx_data;
    integer i;

    begin
        @(negedge clk_i);
        rx_in_i = 0;
        repeat(prescale_i) @(negedge clk_i);

        for(i=0; i<8; i=i+1) begin
            rx_in_i = tx_data[i];
            repeat(prescale_i) @(negedge clk_i);
        end

        rx_in_i = 1;
        repeat(prescale_i) @(negedge clk_i);
    end
endtask

initial begin

    $dumpfile("uart_rx.vcd");
    $dumpvars(0, uart_rx_tb);

    clk_i = 0;
    rst_ni = 0;
    rx_in_i = 1'b1;
    prescale_i = 6'd32;
    parity_en_i = 1'b0;
    parity_type_i = 1'b0;

    rst_ni = 1'b0;
    repeat(5) @(posedge clk_i);
    rst_ni = 1'b1;

    repeat(10) @(posedge clk_i);

    uart_send_byte(8'h55);

    repeat(20) @(posedge clk_i);

    if(data_o == 8'h55 &&
       valid_seen == 1'b1 &&
       parity_error_o == 1'b0 &&
       stop_error_o == 1'b0)
        $display("ODD PARITY TEST PASSED");
    else
        $display("ODD PARITY TEST FAILED");

    $finish;

end

endmodule