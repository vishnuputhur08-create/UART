module parity_calc(
    input [7:0] data_i,
    input parity_type,
    output parity_o
);

assign parity_o = (parity_type) ? ~(^data_i) : (^data_i);
endmodule