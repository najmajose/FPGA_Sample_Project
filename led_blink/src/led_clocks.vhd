----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:44:49 06/12/2017 
-- Design Name: 
-- Module Name:    led_clocks - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
---use UNISIM.VComponents.all;

entity led_clocks is
Port ( pix_clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           colour_mode : in STD_LOGIC; -- 0 is Grey, 1 is RGB
           resolution : in STD_LOGIC_VECTOR(1 downto 0);  ---- 0 -- 300 DPI, 1 - 600 DPI, 2 - 200 DPI
			  led_enable : out STD_LOGIC;
           red_led : out  STD_LOGIC;
           blue_led : out  STD_LOGIC;
           green_led : out  STD_LOGIC;
           line_clk : out  STD_LOGIC;
	        count_val : out integer range 0 to 4095;
           mode : out  STD_LOGIC);
end led_clocks;

architecture Behavioral of led_clocks is

signal line_clk_sig   : STD_LOGIC;
signal led_enable_sig : STD_LOGIC;
signal red_led_sig    : STD_LOGIC;
signal blue_led_sig   : STD_LOGIC;
signal green_led_sig  : STD_LOGIC;
signal mode_sig       : STD_LOGIC;
signal red_scan       : STD_LOGIC;
signal green_scan     : STD_LOGIC;
signal blue_scan      : STD_LOGIC;
signal cntr_val       : integer range 0 to 4095 := 0;

constant end_count    : integer := 750;
constant r_count      : integer := 500;
constant b_count      : integer := 400;
constant g_count      : integer := 600;
	 
     begin
         LINE_CLOCK: process (pix_clk) begin
             if (rising_edge(pix_clk) )then
                if (rst = '0') then
                   cntr_val <= 0;
                   line_clk_sig <= '0';
						 led_enable_sig <= '0';
                   red_led_sig <= '0' ;
                   blue_led_sig <= '0' ;
                   green_led_sig <= '0';
                   red_scan <= '1';
						
                   if (colour_mode = '0') then
                      green_scan <= '1';
                      blue_scan <= '1';
                   else
                      green_scan <= '0';
                      blue_scan <= '0';
                   end if;
                   if (resolution = "00") then
                      mode_sig <= '0';
                   else
                      mode_sig <= '1';
                   end if;
                else
                   if (cntr_val = 1) then
                      line_clk_sig <= '1';
							 if ( colour_mode = '1') then
                         if (red_scan = '1') then
                            red_scan <= '0';
                            green_scan <= '1';
                         elsif (green_scan = '1') then
                            green_scan <= '0';
                            blue_scan <= '1';
                         else
                            blue_scan <= '0';
                            red_scan <= '1';
                         end if;
                      end if;
                   end if;
						 if (cntr_val = 2) then
                      line_clk_sig <= '0';
							 -- add here
							 led_enable_sig <= '1';
							 red_led_sig <= '1' ;
					       blue_led_sig <='1';
                   end if;
--					
                  if (cntr_val = 6) then 
	                  green_led_sig <= '1' ;
					   end if;
					 
				 
--					  
--					  -- pulse end
						 
                   if  ( (cntr_val = 5) and (resolution = "10")) then
                      mode_sig <= not mode_sig;
                   end if;
                   if ((cntr_val = 82) and (red_scan = '1')) then 
                      red_led_sig <= '1';
                   end if;
                   if ((cntr_val = 82) and (blue_scan = '1')) then
                      blue_led_sig <= '1';
                   end if;
                   if ((cntr_val = 82) and (green_scan = '1')) then
	              green_led_sig <= '1';
                   end if;
                  
					if ((cntr_val = r_count) or (cntr_val = 8))then 
	              red_led_sig <= '0' ;
					  end if;
				
				  if ((cntr_val = b_count) or (cntr_val = 8))then 
	              blue_led_sig <= '0' ;
					  end if;
				  if ((cntr_val = g_count) or (cntr_val = 8))then 
	              green_led_sig <= '0';
					  end if;
              if (cntr_val = end_count) then 
                 cntr_val <= 0;
					 -- -- add here
					  led_enable_sig <= '0';
				  else 
                   cntr_val <= cntr_val + 1;
					end if;	 
                   
                end if;
             end if;
        end process;
    
    line_clk  <= line_clk_sig;
	 led_enable <= led_enable_sig;
    red_led   <= red_led_sig;
    blue_led  <= blue_led_sig;
    green_led <= green_led_sig;
    mode      <= mode_sig;
    count_val <= cntr_val;

end Behavioral;

