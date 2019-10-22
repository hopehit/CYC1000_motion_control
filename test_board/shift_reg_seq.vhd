--============================================================================= 
--
-- Shift Register Sequence
--
--	mode = "011"
--
--============================================================================= 

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;

entity shift_reg_seq is
	port (		
		mode   			: in 	std_logic_vector(2 downto 0);
		enable 			: in 	std_logic;
		clk 				: in 	std_logic;
		resetn  			: in 	std_logic;
		led_out			: out std_logic_vector(7 downto 0)
	);
end entity;

architecture behavioural of shift_reg_seq is

	signal shift_reg 	: 		std_logic_vector(7 downto 0) := X"00";
	signal dummy 		: 		std_logic := '1';
	
begin

	-- shift register
	process (enable)
	begin
		if (resetn = '0' or mode /= "011") then
			shift_reg <= "00000000";
					
		elsif rising_edge(clk) then
			if enable = '1' then
				shift_reg(7 downto 0) <= dummy & shift_reg(7 downto 1);
			end if;
		end if;
	end process;

	dummy <= '0' when shift_reg = "11111111" else 
				'1' when shift_reg = "00000000";
				
	led_out <= shift_reg;

end architecture;