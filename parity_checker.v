module parity_checker(
    input [7:0] data_i,
    input parity_type_i,
    input parity_bit_i,
    output parity_error_o
);
wire calculated_parity;
assign calculated_parity = ^data_i;
assign parity_error_o = (calculated_parity ^ parity_bit_i) ^ parity_type_i;
endmodule