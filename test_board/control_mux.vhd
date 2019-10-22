--============================================================================= 
--
-- Mode Controller
--
-- Toggles through choosing 1 out of 5 possible LED sequence modes
--
--============================================================================= 

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;

entity control_mux is

	port (		
		clk     		: in 	std_logic;
		resetn   	: in 	std_logic;
		user_btn 	: in	std_logic;
		mode   		: out std_logic_vector(2 downto 0);
		led_in		: in	std_logic_vector(39 downto 0);
		led_out		: out std_logic_vector(7 downto 0)
		
	);
	
end entity;

architecture behavioural of control_mux is

	signal cnt 		: 		std_logic_vector(2 downto 0) := "001";
	signal delay1 	: 		std_logic;
	signal delay2	: 		std_logic;
	signal delay3 	: 		std_logic;
	signal db_btn 	: 		std_logic;
	signal reset	:		std_logic :='1';
	
begin

	-- debounce key
	process(clk, resetn)
	begin
		if resetn = '0' then
			delay1 <= '0';
			delay2 <= '0';
			delay3 <= '0';
				
		elsif rising_edge(clk) then
			delay1 <= USER_BTN;
			delay2 <= delay1;
			delay3 <= delay2;		
		end if;			
	end process;

	db_btn <= delay3;

	-- toggle through states
	process(db_btn, resetn)
	begin
		if resetn = '0' or reset = '0' or cnt = "110" then
			cnt <= "001";
				
		elsif falling_edge(db_btn) then
			cnt <= cnt + 1;
		end if;
	end process;

	

	process(cnt)												-- Pass LED sequence to LEDs depending on mode
	begin		
			case cnt is	
				when "001"  => led_out <= led_in (39 downto 32);
				when "010" 	=> led_out <= led_in (31 downto 24);
				when "011" 	=> led_out <= led_in (23 downto 16);
				when "100" 	=> led_out <= led_in (15 downto 8);
				when "101" 	=> led_out <= led_in (7 downto 0);
				when others => led_out <="00000000";
			end case;
	end process;
	
	reset <= '0' when led_in (39 downto 32) = "11111111" else
				'1';
	mode <= cnt;

end architecture;