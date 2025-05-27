module timer(
	input	  wire	rst_n,//SW[0] 
	input   wire   i_clk,
   input   wire   i_timer_event,//KEY[0] 
   input   wire 	[3:0] i_clk_control,//SW 14 - 17
   input   wire   [7:0] i_data_in,//SW 1-8
	input   wire   [1:0] i_mode_timer,//sw 9-10
	
	output  wire   overflow,//LEDG[0]
	output  wire   [7:0] r_timer_count,//LEDG[1] - 8
	output  wire   o_pwm,//LEDR[0]
	output  wire   o_compare_interrupt//LEDR[1]
);

counter counter_dut (.rst_n(rst_n),
				 .i_clk(i_clk),
				 .i_timer_event(i_timer_event),
				 .i_clk_control(i_clk_control),
				 .data_in(i_data_in),
				 .i_mode_timer(i_mode_timer),
				 .overflow(overflow),
				 .r_timer_count(r_timer_count),
				 .o_pwm(o_pwm),
				 .o_compare_interrupt(o_compare_interrupt)
);

endmodule 

module counter(
//counter
  input   wire   rst_n,
  output  wire   overflow,
  output  reg    [7:0] r_timer_count,
  output  wire   o_compare_interrupt,
  input   wire   [7:0] data_in,
  output  wire   o_pwm,
//ctrl_mode 
  input   wire   [1:0] i_mode_timer,
  output  wire   none,
  output  wire   cnt,
  output  wire   pwm,
  output  wire   normal,
// prescaler
  input   wire  i_clk,
  //edge_detector
  input   wire i_timer_event,
  //mux
  input   wire [3:0] i_clk_control,
  output  wire   o_mux 

);

ctrl_mode dut (.rst_n(rst_n),
						.i_mode_timer(i_mode_timer),
						.none(none),
						.cnt(cnt),
						.pwm(pwm),
						.normal(normal)
);

prescaler u_dut (.i_clk(i_clk),
					  .rst_n(rst_n),
					  .i_timer_event(i_timer_event),
					  .i_clk_control(i_clk_control),
					  .o_mux(o_mux)
);
  reg  [7:0]  data_past;
  reg  [7:0]  r_present_value ;
  wire clk;
  reg  [7:0]  count;
  
  assign clk = o_mux && (~none);

// counter
always @(posedge clk or negedge rst_n) begin 
  if(rst_n == 0) 
    count <= 0;
  else begin if(count == 256)
	   count <= 0;
	 else begin if(r_present_value == 0)
	     count <= count;
		else begin if(normal == 1 && data_in != data_past)
				count <= data_in;
			else 
				count <= count + 1;
		  end
		end
  end  
end 

  assign overflow = (count == 255) ? 1 : 0;
   
always @(posedge clk or negedge rst_n) begin 
	if(!rst_n)
		data_past <= 0;
	else begin if (data_in != data_past)
			data_past <= data_in;
		end 
end 
 
// thanh ghi gia tri vao 
always @(posedge clk or negedge rst_n) begin 
  if(rst_n == 0) 
    r_present_value <= 0;
  else 
    r_present_value <= data_in;
end 

// thanh ghi trang thai count
always @(*) begin 
  if(rst_n == 0) 
    r_timer_count = 0;
  else 
    r_timer_count = count;
end 

//compare 
  assign o_compare_interrupt = (cnt == 0) ? 0 : 
										 (r_timer_count == r_present_value) ? ((r_present_value == 0) ? 0 : 1): 0;
// compare pwm
  assign o_pwm = (pwm == 0) ? 0 : 
					  (r_present_value >= count) ? 1 : 0;

endmodule 

 module ctrl_mode(
  input wire rst_n, 
  // control_unit signals
  input wire [1:0] i_mode_timer,
  output reg none,
  output reg cnt,
  output reg pwm,
  output reg normal
 );
 
 // control_unit
 always @(*) begin
   if(rst_n == 0) begin
     none = 0;
	  cnt = 0;
	  pwm = 0;
	  normal = 0;
	  end 
	  
   else begin 
	  case(i_mode_timer)	
		 2'b00: begin 
					none = 1;
					cnt = 0;
					pwm = 0;
					normal = 0;
					end 
		 2'b01: begin 
		         none = 0;
					cnt = 1;
					pwm = 0;
					normal = 0;
					end 
	  	 2'b10: begin 
					none = 0;
					cnt = 0;
				   pwm = 1;
					normal = 0;
					end 
		 2'b11: begin 
				   none = 0;
				   cnt = 0;
					pwm = 0;
					normal = 1;
					end 
	  endcase
 	  end
  end 
 
 endmodule 
 
 module prescaler(
  input   wire  i_clk,
  input   wire  rst_n,
  //edge_detector
  input wire i_timer_event,
  output wire event_timer,
  //mux
  input   wire [3:0] i_clk_control,
  output  reg   o_mux 
 );

 edge_detector edge_dut (.rst_n(rst_n),
								 .i_timer_event(i_timer_event),
								 .event_timer(event_timer)
								 );
 
  reg [2:0] count = 0;
  reg [2:0] count1 = 0;
  reg [2:0] count3 = 0;
  reg [2:0] count4 = 0;
  reg [2:0] count5 = 0;
  reg [2:0] count6 = 0;
  reg [2:0] count7 = 0;
  reg [2:0] count8 = 0;

  reg   Ndiv2;
  wire  Ndiv3;
  reg   Ndiv4;
  wire  Ndiv5;
  wire  Ndiv6;
  wire  Ndiv7;
  reg   Ndiv8;
  
//div 3
  wire  Q1;
  wire  Q2;
//div 5
  wire  Q3;
  wire  Q4;
//div 6
  wire  Q5;
  wire  Q6;
//div 7
  wire  Q7;
  wire  Q8;
  
  // N div 2
always @(posedge i_clk or negedge rst_n) begin
  if(rst_n == 0) begin
	 Ndiv2 <= 0;
	 end
  else 
		 Ndiv2 <= ~Ndiv2;
end 

  // N div 3
always @(posedge i_clk or negedge rst_n) begin
  if(rst_n == 0) begin
    count <= 0;
	 end
  else begin
    if(count == 2) begin 
	   count <= 0;
		end
	 else 
	   count <= count + 1;
  end	 
end 

  assign Q1 = (count == 2) ? 1 : 0;

always @(negedge i_clk or negedge rst_n) begin
  if(rst_n == 0) begin
    count1 <= 0;
	 end
  else begin
    if(count1 == 2) begin 
	   count1 <= 0;
		end
	 else 
	   count1 <= count1 + 1;
  end	 
end 

  assign Q2 = (count1 == 2) ? 1 : 0;
  assign Ndiv3 = Q1 || Q2;

  // N div 4
always @(posedge Ndiv2 or negedge rst_n) begin
  if(rst_n == 0) begin
	 Ndiv4 <= 0;
	 end
  else 
	 Ndiv4 <= ~Ndiv4;
end 

  // Ndiv5 
always @(posedge i_clk or negedge rst_n) begin
  if(rst_n == 0) 
    count3 <= 0;
  else begin  
    if(count3 == 4) 
	   count3 <= 0;
	 else begin
	   count3 <=  count3 + 1;
		end
	 end 
end 

  assign Q3 = (count3 < 3 && count3 > 0) ? 1 : 0;

always @(negedge i_clk or negedge rst_n) begin
  if(rst_n == 0) 
    count4 <= 0;
  else begin  
    if(count4 == 4) 
	   count4 <= 0;
	 else begin
	   count4 <=  count4 + 1;
		end
	 end 
end 

  assign Q4 = (count4 < 3 && count4 > 0) ? 1 : 0;
  assign Ndiv5 = Q3 || Q4;

  // Ndiv6 
always @(posedge i_clk or negedge rst_n) begin
  if(rst_n == 0) 
    count5 <= 0;
  else begin  
    if(count5 == 5) 
	   count5 <= 0;
	 else begin
	   count5 <=  count5 + 1;
		end
	 end 
end 

  assign Q5 = (count5 < 3 && count5 > 0) ? 1 : 0;

always @(posedge i_clk or negedge rst_n) begin
  if(rst_n == 0) 
    count6 <= 0;
  else begin  
    if(count6 == 5) 
	   count6 <= 0;
	 else begin
	   count6 <=  count6 + 1;
		end
	 end 
end 

  assign Q6 = (count6 < 4 && count6 > 1) ? 1 : 0;
  assign Ndiv6 = Q5 || Q6;
  
  // Ndiv7
always @(posedge i_clk or negedge rst_n) begin
  if(rst_n == 0) 
    count7 <= 0;
  else begin  
    if(count7 == 6) 
	   count7 <= 0;
	 else begin
	   count7 <=  count7 + 1;
		end
	 end 
end 

  assign Q7 = (count7 < 4 && count7 > 0) ? 1 : 0;

always @(negedge i_clk or negedge rst_n) begin
  if(rst_n == 0) 
    count8 <= 0;
  else begin  
    if(count8 == 6) 
	   count8 <= 0;
	 else begin
	   count8 <=  count8 + 1;
		end
	 end 
end 

  assign Q8 = (count8 < 4 && count8 > 0) ? 1 : 0;
  assign Ndiv7 = Q7 || Q8;

// Ndiv5400000 làm T = 0.02s => 50hz 
 
always @(posedge Ndiv4 or negedge rst_n) begin
  if(rst_n == 0) begin
	 Ndiv8 <= 0;
	 end
  else 
	 Ndiv8 <= ~Ndiv8;
end 

	reg [19:0] Count_div;
	reg Ndiv540k;

always @(posedge i_clk or negedge rst_n) begin
  if(!rst_n) begin
	 Count_div <=0;
	 Ndiv540k <= 0;
	 end
  else begin 
    if(Count_div == 540000) begin
		Count_div <= 0;
		Ndiv540k <= ~Ndiv540k;
		end 
	 else 
      Count_div <= Count_div + 1;
    end 
end 


  //mux 
always @(*) begin
  case(i_clk_control)
    4'b0000: o_mux = i_clk;
	 4'b0001: o_mux = Ndiv2;
	 4'b0010: o_mux = Ndiv3;
	 4'b0011: o_mux = Ndiv4;
	 4'b0100: o_mux = Ndiv5;
	 4'b0101: o_mux = Ndiv6;
	 4'b0110: o_mux = Ndiv7;
	 4'b0111: o_mux = Ndiv540k;
	 4'b1000: o_mux = event_timer;
	 default: o_mux = i_clk;
	 endcase
end 
 
 endmodule
 
 module edge_detector(
  input wire rst_n,
  input wire i_timer_event,
  output reg event_timer
);
 
always @(i_timer_event or rst_n) begin 
  if(rst_n == 0)
    event_timer = 0;
  else 
    event_timer = i_timer_event;  
end 

endmodule
 