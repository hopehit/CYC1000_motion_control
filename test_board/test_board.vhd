-- Copyright (C) 2019  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.1.1 Build 646 04/11/2019 SJ Lite Edition"
-- CREATED		"Tue Oct 22 19:06:49 2019"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY test_board IS 
	PORT
	(
		user_btn :  IN  STD_LOGIC;
		clk_12mhz :  IN  STD_LOGIC;
		uart_txd :  IN  STD_LOGIC;
		spi_g_sen_miso :  IN  STD_LOGIC;
		sdram_dq :  INOUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		sdram_cke :  OUT  STD_LOGIC;
		sdram_casn :  OUT  STD_LOGIC;
		sdram_csn :  OUT  STD_LOGIC;
		sdram_rasn :  OUT  STD_LOGIC;
		sdram_wen :  OUT  STD_LOGIC;
		uart_rxd :  OUT  STD_LOGIC;
		sdram_clk :  OUT  STD_LOGIC;
		spi_g_sen_mosi :  OUT  STD_LOGIC;
		spi_g_sen_clk :  OUT  STD_LOGIC;
		spi_g_sen_csn :  OUT  STD_LOGIC;
		led_out :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		sdram_addr :  OUT  STD_LOGIC_VECTOR(11 DOWNTO 0);
		sdram_ba :  OUT  STD_LOGIC_VECTOR(1 DOWNTO 0);
		sdram_dqm :  OUT  STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END test_board;

ARCHITECTURE bdf_type OF test_board IS 

COMPONENT nios_test_board
	PORT(clk_in_clk : IN STD_LOGIC;
		 reset_reset_n : IN STD_LOGIC;
		 spi_g_sen_MISO : IN STD_LOGIC;
		 uart_rxd : IN STD_LOGIC;
		 pio_mode_export : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 sdram_dq : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 sdram_cas_n : OUT STD_LOGIC;
		 sdram_cke : OUT STD_LOGIC;
		 sdram_cs_n : OUT STD_LOGIC;
		 sdram_ras_n : OUT STD_LOGIC;
		 sdram_we_n : OUT STD_LOGIC;
		 sdram_clk_clk : OUT STD_LOGIC;
		 spi_g_sen_MOSI : OUT STD_LOGIC;
		 spi_g_sen_SCLK : OUT STD_LOGIC;
		 spi_g_sen_SS_n : OUT STD_LOGIC;
		 uart_txd : OUT STD_LOGIC;
		 pio_led_export : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 sdram_addr : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		 sdram_ba : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 sdram_dqm : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pwm_gen
GENERIC (cnt_max : INTEGER;
			duty_cycle : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 resetn : IN STD_LOGIC;
		 pwm_out : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT differentiator
	PORT(clk : IN STD_LOGIC;
		 resetn : IN STD_LOGIC;
		 data : IN STD_LOGIC;
		 enable : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT clk_divisor
GENERIC (cnt_max : INTEGER
			);
	PORT(clk_in : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 clk_out : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT control_mux
	PORT(clk : IN STD_LOGIC;
		 resetn : IN STD_LOGIC;
		 user_btn : IN STD_LOGIC;
		 led_in : IN STD_LOGIC_VECTOR(39 DOWNTO 0);
		 led_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 mode : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END COMPONENT;

COMPONENT knightrider
	PORT(enable : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 resetn : IN STD_LOGIC;
		 pwm1 : IN STD_LOGIC;
		 pwm2 : IN STD_LOGIC;
		 mode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 led_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pwm_seq
GENERIC (n : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 resetn : IN STD_LOGIC;
		 mode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 led_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT shift_reg_seq
	PORT(enable : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 resetn : IN STD_LOGIC;
		 mode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 led_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT case_state_seq
	PORT(enable : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 resetn : IN STD_LOGIC;
		 mode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 led_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	led :  STD_LOGIC_VECTOR(39 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_25 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_26 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_27 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC;


BEGIN 
SYNTHESIZED_WIRE_25 <= '1';



b2v_inst : nios_test_board
PORT MAP(clk_in_clk => clk_12mhz,
		 reset_reset_n => SYNTHESIZED_WIRE_25,
		 spi_g_sen_MISO => spi_g_sen_miso,
		 uart_rxd => uart_txd,
		 pio_mode_export => SYNTHESIZED_WIRE_26,
		 sdram_dq => sdram_dq,
		 sdram_cas_n => sdram_casn,
		 sdram_cke => sdram_cke,
		 sdram_cs_n => sdram_csn,
		 sdram_ras_n => sdram_rasn,
		 sdram_we_n => sdram_wen,
		 sdram_clk_clk => sdram_clk,
		 spi_g_sen_MOSI => spi_g_sen_mosi,
		 spi_g_sen_SCLK => spi_g_sen_clk,
		 spi_g_sen_SS_n => spi_g_sen_csn,
		 uart_txd => uart_rxd,
		 pio_led_export => led(39 DOWNTO 32),
		 sdram_addr => sdram_addr,
		 sdram_ba => sdram_ba,
		 sdram_dqm => sdram_dqm);



b2v_inst10 : pwm_gen
GENERIC MAP(cnt_max => 100000,
			duty_cycle => 95000
			)
PORT MAP(clk => clk_12mhz,
		 resetn => SYNTHESIZED_WIRE_25,
		 pwm_out => SYNTHESIZED_WIRE_13);


b2v_inst11 : differentiator
PORT MAP(clk => clk_12mhz,
		 resetn => SYNTHESIZED_WIRE_25,
		 data => SYNTHESIZED_WIRE_4,
		 enable => SYNTHESIZED_WIRE_16);


b2v_inst12 : clk_divisor
GENERIC MAP(cnt_max => 12000
			)
PORT MAP(clk_in => clk_12mhz,
		 reset => SYNTHESIZED_WIRE_25,
		 clk_out => SYNTHESIZED_WIRE_4);


b2v_inst2 : clk_divisor
GENERIC MAP(cnt_max => 1000000
			)
PORT MAP(clk_in => clk_12mhz,
		 reset => SYNTHESIZED_WIRE_25,
		 clk_out => SYNTHESIZED_WIRE_9);


b2v_inst3 : control_mux
PORT MAP(clk => clk_12mhz,
		 resetn => SYNTHESIZED_WIRE_25,
		 user_btn => user_btn,
		 led_in => led,
		 led_out => led_out,
		 mode => SYNTHESIZED_WIRE_26);


b2v_inst4 : differentiator
PORT MAP(clk => clk_12mhz,
		 resetn => SYNTHESIZED_WIRE_25,
		 data => SYNTHESIZED_WIRE_9,
		 enable => SYNTHESIZED_WIRE_27);


b2v_inst5 : knightrider
PORT MAP(enable => SYNTHESIZED_WIRE_27,
		 clk => clk_12mhz,
		 resetn => SYNTHESIZED_WIRE_25,
		 pwm1 => SYNTHESIZED_WIRE_12,
		 pwm2 => SYNTHESIZED_WIRE_13,
		 mode => SYNTHESIZED_WIRE_26,
		 led_out => led(15 DOWNTO 8));


b2v_inst6 : pwm_gen
GENERIC MAP(cnt_max => 100000,
			duty_cycle => 70000
			)
PORT MAP(clk => clk_12mhz,
		 resetn => SYNTHESIZED_WIRE_25,
		 pwm_out => SYNTHESIZED_WIRE_12);


b2v_inst7 : pwm_seq
GENERIC MAP(n => 11
			)
PORT MAP(clk => clk_12mhz,
		 enable => SYNTHESIZED_WIRE_16,
		 resetn => SYNTHESIZED_WIRE_25,
		 mode => SYNTHESIZED_WIRE_26,
		 led_out => led(7 DOWNTO 0));


b2v_inst8 : shift_reg_seq
PORT MAP(enable => SYNTHESIZED_WIRE_27,
		 clk => clk_12mhz,
		 resetn => SYNTHESIZED_WIRE_25,
		 mode => SYNTHESIZED_WIRE_26,
		 led_out => led(23 DOWNTO 16));


b2v_inst9 : case_state_seq
PORT MAP(enable => SYNTHESIZED_WIRE_27,
		 clk => clk_12mhz,
		 resetn => SYNTHESIZED_WIRE_25,
		 mode => SYNTHESIZED_WIRE_26,
		 led_out => led(31 DOWNTO 24));


END bdf_type;