# Timer-8-bit-with-Compare-and-Pwm-
# Timer 8 bit with Compare and Pwm on FPGA kit de 2
# Please download Timer 8 bit with Compare and Pwm.pdf to see verification plan
Project Title: 8-bit Timer IP Design
Author: Thái Trung Kiên 
Language: Verilog
Platform: FPGA Kit DE2

# Main Functions:
The timer supports 3 modes controlled via i_mode_timer[1:0]:
00: None (disabled)
01: cnt_cp (counts to a preset value and triggers interrupt)
10: pwm (Pulse Width Modulation)
11: normal (Clear Timer on Compare) 

# Clock Control:
Input clock (i_clk) is processed by a Prescaler, adjusted by i_clk_control[2:0]:
000: Direct clock
001: Clock ÷ 2
010: Clock ÷ 3
011: Clock ÷ 4
100: Clock ÷ 5
101: Clock ÷ 6
110: Clock ÷ 7
111: Event-based counting (rising edge of i_timer_event)

# Key Components:
Prescaler: Generates different clock rates 
MUX: Chooses the correct clock based on i_clk_control
Edge Detector: Detects rising edge on i_timer_event
Control Unit: Enables mode functions
8-bit Counter: Counts from 0 to 255 or to preset value
Compare Unit: Compares counter with preset and triggers o_compare_interrupt
PWM Compare: Outputs PWM signal from 0 to preset value

# Key Signals:
i_rst_n: Reset
i_clk: Clock input
i_timer_event: External event input
data_in: Input to preset register
r_timer_count: Current counter value
r_present_value: Preset value
o_pwn: PWM output
o_compare_interrupt: Interrupt signal on match
o_overflow: High when counter reaches 255
