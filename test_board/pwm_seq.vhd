--============================================================================= 
--
-- Simple PWM sequence
--
-- mode = "101"
--
--============================================================================= 

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;

entity pwm_seq is
	generic( 
		n  					: 		integer := 11
	);
	port(		
		mode   				: in 	std_logic_vector(2 downto 0);
		clk 					: in 	std_logic;
		enable				: in 	std_logic;
		resetn  				: in 	std_logic;
		led_out				: out std_logic_vector(7 downto 0)
	);
end entity;

architecture behaviour of pwm_seq is
	signal pwm_out 		: 		std_logic;
	signal pulse_pass		: 		std_logic; 
	signal flag				:		std_logic;
	signal pol				: 		std_logic;
	signal duty_cycle		: 		std_logic_vector(n-1 downto 0);
	signal cnt				: 		std_logic_vector(n-1 downto 0);

	begin

		-- Duty Cycle
		process(clk) 
		begin
			if rising_edge(clk) then
				if (enable = '1') then 							-- 1ms Pulse
					if (pol = '0') then 							-- Polarity
						if (duty_cycle < 1249) then
							duty_cycle <= duty_cycle + 1;
							pol <= '0';
							
						else
							pol <= '1';
						end if;
						
					else
						if (duty_cycle > 1) then
							duty_cycle <= duty_cycle - 1;
							pol <= '1';
						
						else
							pol <= '0';
						end if;
					end if;
				end if;
			end if;
		end process;

		-- Counting
		process(clk) 
		begin
			if rising_edge(clk) then
				if (cnt < 1249) then
					cnt <= cnt + 1;
		
				else
					cnt <= (others => '0');
				end if;
			end if;
		end process;

		-- Pulsing
		process(clk) 
		begin
			if rising_edge(clk) then
				if (duty_cycle > cnt) then
					pwm_out <= '1';
				
				else
					pwm_out <= '0';
				end if;
			end if;
		end process;

	led_out(7 downto 4) <= (others => pwm_out)		when mode = "101" else (others => '0');
	led_out(3 downto 0) <= (others => not pwm_out) 	when mode = "101" else (others => '0');

end architecture;
