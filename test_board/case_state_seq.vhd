--=============================================================================
--
-- Case statement sequence
--
--	mode = "010"
--
--=============================================================================

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;

entity case_state_seq is
	port (		
		mode   	: in 	std_logic_vector(2 downto 0);
		enable 	: in 	std_logic;
		clk 		: in 	std_logic;
		resetn  	: in 	std_logic;
		led_out	: out std_logic_vector(7 downto 0)
	);
end entity;

architecture behavioural of case_state_seq is
	
	signal cnt : 		std_logic_vector(3 downto 0);
	
begin
	
	-- counter
	process (clk, resetn)
	begin
		if resetn = '0' or mode /= "010"then	
			cnt <= (others => '0');
					
		elsif rising_edge(clk) then
			if enable = '1' then
				if mode = "010" then
					cnt <= cnt + '1';
				end if;
			end if;
		end if;				
	end process;

	process (cnt, mode)
	begin
		if mode = "010" then
			case cnt is
				when "0000" => led_out <=  "00000000";
				when "0001" => led_out <=  "10000001";
				when "0010" => led_out <=  "01000010";
				when "0011" => led_out <=  "00100100";
				when "0100" => led_out <=  "00011000";
				when "0101" => led_out <=  "00100100";
				when "0110" => led_out <=  "01000010";
				when "0111" => led_out <=  "10000001";
				when "1000" => led_out <=  "10000001";
				when "1001" => led_out <=  "11000011";
				when "1010" => led_out <=  "11100111";
				when "1011" => led_out <=  "11111111";
				when "1100" => led_out <=  "11100111";
				when "1101" => led_out <=  "11000011";
				when "1110" => led_out <=  "10000001";
				when "1111" => led_out <=  "00000000";
				when others => led_out <=  "00000000";
			end case;
				
		else 
			led_out <=  "00000000";
				
		end if;
	end process;

end architecture;