module RAM(din,rx_valid,clk,rst_n,dout,tx_valid);
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;
input [9:0] din;
input rx_valid,clk,rst_n;
output reg [7:0] dout;
output reg tx_valid;
reg [ADDR_SIZE-1:0] ram [MEM_DEPTH-1:0];
reg [7:0] write_addr,read_addr;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		dout <= 0;
		tx_valid <= 0;
	end
	else if (din[9:8] == 2'b00 && rx_valid == 1) begin
		write_addr <= din[7:0];
		tx_valid <= 0;
	end
	else if (din[9:8] == 2'b01 && rx_valid == 1) begin
		ram[write_addr] <= din[7:0];
		tx_valid <= 0;
	end
	else if (din[9:8] == 2'b10 && rx_valid == 1) begin
		read_addr <= din[7:0];
		tx_valid <= 0;
	end
	else if (din[9:8] == 2'b11 && rx_valid == 1) begin
		dout <= ram[read_addr];
		tx_valid <= 1;
	end
end
endmodule