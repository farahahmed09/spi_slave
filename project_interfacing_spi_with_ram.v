module project_2(MOSI,MISO,SS_n,clk,rst_n);
input MOSI,SS_n,clk,rst_n;
output MISO;
wire [9:0] rx_data;
wire [7:0] tx_data;
wire rx_valid,tx_valid;
RAM RAM1(.din(rx_data),.rx_valid(rx_valid),.clk(clk),.rst_n(rst_n),.dout(tx_data),.tx_valid(tx_valid));
SPI_SLAVE SPI1(.MOSI(MOSI),.MISO(MISO),.SS_n(SS_n),.clk(clk),.rst_n(rst_n),.rx_data(rx_data),.rx_valid(rx_valid),.tx_data(tx_data),.tx_valid(tx_valid));
endmodule