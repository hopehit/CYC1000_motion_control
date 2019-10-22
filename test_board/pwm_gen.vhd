--============================================================================= 
--
-- PWM Generator
-- Generates a PWM signal with adjustable duty cycle
--
--============================================================================= 

library ieee;
	use ieee.std_logic_1164.all;

entity pwm_gen is
	generic ( 
		duty_cycle 	: 		integer:= 70_000;
		cnt_max  	: 		integer:= 100_000
	);
	port (	
		clk			: in 	std_logic;
		resetn  		: in 	std_logic;
		pwm_out		: out std_logic
	);
end entity;

architecture behaviour of pwm_gen is
	
begin

	process (clk, resetn)
		variable cnt : integer range 0 to cnt_max;
	begin
		if resetn = '0' then
			cnt := 0;
			pwm_out <= '0';

		elsif	rising_edge(clk) then
			cnt := cnt + 1;					-- increase cnt
			if cnt = duty_cycle then		-- if cnt reaches duty cycle value pwm = 1
				pwm_out <= '1';
			end if;
		
			if cnt = cnt_max then			-- if cnt reaches max cnt value pwm = 0
				pwm_out <= '0';
				cnt := 0;
			end if;		
		end if;	
	end process;

end architecture;