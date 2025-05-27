module test_bench;
  reg rst_n,i_clk,i_timer_event;
  wire [7:0] r_timer_count;
  wire overflow,o_compare_interrupt,o_pwm;
  reg  [7:0] i_data_in;
  reg [1:0] i_mode_timer;
  reg [3:0] i_clk_control;
  
 counter dut (.rst_n(rst_n),
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
  
initial begin 
  i_clk = 0;
  forever #20 i_clk = ~ i_clk; 
end 

initial begin 
// trường hợp 1 overflow = 0, o_pwm = 0, o_compare_interrupt = 0
  rst_n = 0;
  i_mode_timer = 1;
  i_timer_event = 3;
  i_clk_control = 15;
  i_data_in = 255;
#30; 
// data_in chưa có 
  rst_n = 1;
  i_mode_timer = 0;
  i_timer_event = 0;
  i_clk_control = 0;
  i_data_in = 0;
#30;// cho data_in = 120; ko chạy
  i_data_in = 120;
#30; // chinhr mode 1 cnt  chạy
  i_mode_timer = 1;
#500;
  i_mode_timer = 0;
#120;
#30; // chinhr mode pwn 
  i_mode_timer = 2;
#30;//test event_timer , mode cnt
  repeat (256) #40;
  i_mode_timer = 1;
  repeat (256) #40;
  i_clk_control = 8;
  repeat (256) #40 i_timer_event =  ~i_timer_event;
  i_mode_timer = 2;
  repeat (256) #40 i_timer_event =  ~i_timer_event;
  i_mode_timer = 3;
  i_data_in = 220;
  i_clk_control = 0;
  repeat (256) #40;
  i_clk_control = 8;
  i_timer_event = 0;
  #70;
  i_timer_event = 1; 
  #50
  i_timer_event = 0;
  #70;
  i_timer_event = 1; 
  #70;
  i_mode_timer = 2;
  i_data_in = 120;
  i_clk_control = 7;
  i_timer_event = 0;
  #120;
  i_data_in = 250;
  i_mode_timer = 3;
  i_clk_control = 8;
  i_timer_event = 0;
  #50;
  i_timer_event = 1;
  repeat (255) #50 i_timer_event =  ~ i_timer_event;
  rst_n = 0;
  #30;
  rst_n = 1;
  i_timer_event = 0;
  i_mode_timer = 1;
  i_data_in = 0;
  i_clk_control = 0;
  #300;
  rst_n = 1;
  i_timer_event = 0;
  i_mode_timer = 1;
  i_data_in = 1;
  i_clk_control = 0;


  

  
  
#300;
  $finish;

 
end 

endmodule 