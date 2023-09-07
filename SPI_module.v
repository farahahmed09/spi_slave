module SPI_SLAVE(MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
parameter IDLE=3'b000;
parameter CHK_CMD=3'b001;
parameter WRITE=3'b010;
parameter READ_ADD=3'b011;
parameter READ_DATA=3'b100;
input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0] tx_data;
output reg [9:0] rx_data;
output reg MISO,rx_valid;
reg check_addr=0;
reg [3:0] count;
reg [2:0] count2;
(* fsm_encoding = "one_hot" *)
reg [2:0] cs,ns;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		cs <= IDLE;
	end
	else begin
		cs <= ns;
	end
end

always @(cs,MOSI,SS_n,tx_valid) begin
	case(cs)
	IDLE: begin
		if(SS_n == 1) begin
			ns = IDLE;
		end
		else begin
			ns = CHK_CMD;
		end
	end
	CHK_CMD: begin
		if (SS_n == 1) begin
			ns = IDLE;
		end
		else if (SS_n == 0 && MOSI == 0) begin
			ns = WRITE;
		end
		else if (SS_n == 0 && MOSI == 1) begin
			if (check_addr == 0) begin
				ns = READ_ADD;
			end
			else begin
				ns = READ_DATA;
			end
		end
	end
	WRITE: begin
		if (SS_n == 1) begin
			ns = IDLE;
		end
		else begin
			ns = WRITE;
		end
	end
	READ_ADD: begin
		if (SS_n == 1) begin
			ns = IDLE;
		end
		else begin
			ns = READ_ADD;
		end
	end
	READ_DATA: begin
		if (SS_n == 1) begin
			ns = IDLE;
		end
		else begin
			ns = READ_DATA;
		end
	end
	endcase
end

always @(posedge clk) begin
	case(cs)
	IDLE: begin
		rx_valid <= 0;
		rx_data <= 0;
		count <=  0;
		count2 <= 0;
	end
	CHK_CMD: begin
		rx_valid <= 0;
		rx_data <= 0;
		count <= 0;
		count2 <= 0;
	end
	WRITE: begin
		if(count == 10) begin
			rx_valid <= 1;
		end
		else begin
			count <= count+1;
			rx_data[9-count] <= MOSI;
		end
	end
	READ_ADD: begin
		if(count == 10) begin
			rx_valid <= 1;
			check_addr <=1;
		end
		else begin
			count <= count+1;
			rx_data[9-count] <= MOSI;
		end
	end
	READ_DATA: begin
		if(count == 10) begin
			rx_valid <= 1;
			check_addr <= 0;
			if(tx_valid == 1) begin
				MISO <= tx_data[7-count2];
				count2 <= count2 + 1;
			end
		end
		else begin
			count <= count+1;
			rx_data[9-count] <= MOSI;
		end
	end
	endcase
end

endmodule