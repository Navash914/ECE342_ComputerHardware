module tb();

// Create a 100MHz clock
logic clk;
initial clk = '0;
always #5 clk = ~clk;

// Create the reset signal and assert it for a few cycles
logic reset;
initial begin
	reset = '1;
	@(posedge clk);
	@(posedge clk);
	reset = '0;
end

// Processor signals
logic [15:0] p_mem_addr, p_mem_rddata, p_mem_wrdata;
logic p_mem_rd, p_mem_wr;

// Memory signals
logic [10:0] m_mem_addr;
logic [15:0] m_mem_rddata, m_mem_wrdata;
logic m_mem_wr;

// Switch signals and register
logic [7:0] sw_in;
logic [7:0] sw_out;
wire sw_en = 1'b1;
reg_n #(8) switches (clk, sw_en, sw_in, sw_out);

// LED signals and register
wire [7:0] led_in = p_mem_wrdata[7:0];
logic [7:0] led_out;
logic led_en;
reg_n #(8) leds (clk, led_en, led_in, led_out);


// Processor
cpu proc (
    .clk(clk),
    .reset(reset),

    .o_mem_addr(p_mem_addr),
    .o_mem_rd(p_mem_rd),
    .i_mem_rddata(p_mem_rddata),
    .o_mem_wr(p_mem_wr),
    .o_mem_wrdata(p_mem_wrdata)
);

// Memory
mem4k mem (
	.clk(clk),
	
	.addr(m_mem_addr),
	.wrdata(m_mem_wrdata),
	.wr(m_mem_wr),
	.rddata(m_mem_rddata)
);

// Decoding Logic

// Decode processor rddata
always_comb begin
	if (p_mem_addr <= 16'h0FFF)
		p_mem_rddata = m_mem_rddata;
	else if (p_mem_addr >= 16'h2000 && p_mem_addr <= 16'h2FFF)
		p_mem_rddata = {8'b0, sw_out};
	else
		p_mem_rddata = 32'bz;	// Should not happen
end

// Decode processor -> memory
always_comb begin
	m_mem_addr = p_mem_addr[10:0] >> 1;
	if (p_mem_addr <= 16'h0FFF)
		m_mem_wr = p_mem_wr;
	else
		m_mem_wr = 1'b0;
end

// Decode processor -> LED
always_comb begin
	if (p_mem_addr >= 16'h3000 && p_mem_addr <= 16'h3FFF)
		led_en = p_mem_wr;
	else
		led_en = 1'b0;
end

initial begin
	#200

	sw_in = 8'b0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	sw_in = 8'b00001000;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	sw_in = 8'b00100000;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	sw_in = 8'b0;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	$stop();
	
end

endmodule
