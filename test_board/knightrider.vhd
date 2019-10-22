--============================================================================= 
--
-- KnightRider
--
--	mode = "100"
--
--============================================================================= 

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.std_logic_unsigned.all;

entity knightrider is
	port (		
		mode   	: in 	std_logic_vector(2 downto 0);
		enable 	: in 	std_logic;
		clk 		: in 	std_logic;
		resetn  	: in 	std_logic;
		pwm1     : in 	std_logic;
		pwm2     : in 	std_logic;
		led_out	: out std_logic_vector(7 downto 0)
	);
end entity;

architecture behavioural of knightrider is

	type state_types is (start, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10);
	signal cs 	: 		state_types; 
	signal ns 	: 		state_types;
	signal dir 	: 		std_logic := '0';

begin

	-- next / current state
	process(clk, resetn)
	begin
		if resetn = '0' or mode /= "100" then	
			cs <= state_types'left;
					
		elsif rising_edge(clk) then	
			if enable = '1' then
				cs <= ns;
			end if;
		end if;
	end process;

	-- direction toggled when led_out(0) or led_out(7) reached
	dir <= '0' when cs = f1  else '1' when cs = f10;

	-- FSM
	-- led_out output based on state and direction
	-- three leds, each with different brightness
	process(cs, dir, pwm1, pwm2)
	begin
		if mode = "100" then
			case cs is
				when start =>		
					ns 		<= f1;
					led_out	<= "00000000";
							
				when f1    =>		
					led_out 	<= "0000000" & '1';
					if dir = '0' then
						ns 		<= f2;
					end if;
							
				when f2    =>		
					if dir = '0' then
						led_out 	<= "000000" & '1' & pwm1;
						ns 		<= f3;
							
					else
						led_out 	<= "000000" & pwm1 & '1';
						ns 		<= f1;
					end if;
							
				when f3    =>		
					if dir = '0' then
						led_out 	<= "00000" & '1' & pwm1 & pwm2;
						ns 		<= f4;
							
					else
						led_out 	<= "00000" & pwm2 & pwm1 & '1';
						ns 		<= f2;
					end if;

				when f4    =>		
					if dir = '0' then
						led_out 	<= "0000" & '1' & pwm1 & pwm2 & '0';
						ns 		<= f5;
					else
						led_out 	<= "0000" & pwm2 & pwm1 & '1' & '0';
						ns 		<= f3;
					end if;
	
				when f5    =>		
					if dir = '0' then
						led_out 	<= "000" & '1' & pwm1 & pwm2 & "00";
						ns 		<= f6;
					else
						led_out 	<= "000" & pwm2 & pwm1 & '1' & "00";
						ns 		<= f4;
					end if;
								
				when f6    =>		
					if dir = '0' then
						led_out 	<= "00" & '1' & pwm1 & pwm2 & "000";
						ns 		<= f7;
					else
						led_out 	<= "00" & pwm2 & pwm1 & '1' & "000";
						ns 		<= f5;
					end if;
					
			
				when f7    =>		
					if dir = '0' then
						led_out 	<= '0' & '1' & pwm1 & pwm2 & "0000";
						ns 		<= f8;
					else
						led_out 	<= '0' & pwm2 & pwm1 & '1' & "0000";
						ns 		<= f6;
					end if;
					
				when f8    =>		
					if dir = '0' then
						led_out 	<=  '1' & pwm1 & pwm2 & "00000";
						ns 		<= f9;
					else
						led_out 	<=  pwm2 & pwm1 & '1' & "00000";
						ns 		<= f7;
					end if;
						
				when f9    =>		
					if dir = '0' then
						led_out 	<=  '1' & pwm1 & "000000";
						ns 		<= f10;
					else
						led_out 	<=  pwm1 & '1' & "000000";
						ns 		<= f8;
					end if;

				when f10    =>		
						led_out 	<=  '1' &  "0000000";
						ns 		<= f9;
	
				when others =>    
						led_out 	<= "00000000";
						ns 		<= start;
			end case;
		end if;
	end process;
	
end architecture;