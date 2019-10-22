--============================================================================= 
--
-- Clock Divisor
-- Frequency output : 12MHz / cnt_max
-- Configurable through generics
--
--============================================================================= 

library ieee;
	use ieee.std_logic_1164.all; 

entity clk_divisor is
	generic ( 
		cnt_max  : 		integer := 1_000_000
	);
	
	port (	   
		clk_in  	: in 	std_logic;
		reset    : in 	std_logic;
		clk_out 	: out std_logic
   );
end entity;

architecture behavioural of clk_divisor  is

	signal cnt 	: 		integer range 0 to cnt_max;
	
begin
	
	process(reset,clk_in)
	begin
		if reset = '0' then
			cnt <= 0;
					
		elsif rising_edge(clk_in) then
			if cnt = (cnt_max - 1) then  
				cnt <= 0;
						
			else
				cnt <= cnt + 1;					
			end if; 
		end if;
	end process;
    
   clk_out <= '0' when cnt < (cnt_max / 2) else '1'; 
    
end architecture;
