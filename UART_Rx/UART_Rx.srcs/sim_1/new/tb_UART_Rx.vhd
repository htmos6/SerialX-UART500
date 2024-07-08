library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_UART_Rx is
	generic 
	(
		c_clk_frequency : integer := 100_000_000;
		c_baud_rate : integer := 100_000
	);
end entity;


architecture Behavioral of tb_UART_Rx is

	component UART_Rx is
		generic 
		(
			c_clk_frequency : integer := 100_000_000;
			c_baud_rate : integer := 115_200
		);
		port 
		(
			clk_i : in std_logic;
			rx_line_i : in std_logic;
			rx_line_o : out std_logic_vector(7 downto 0);
			rx_completed_o : out std_logic
		);
	end component;
	
	constant c_clk_period : time := 1 sec / real(c_clk_frequency); -- 10 ns
	constant c_baud_rate_period : time := 10 us;
	
	signal clk_i : std_logic := '1';
	signal rx_line_i : std_logic := '1'; -- At value 1, it is idle
	signal rx_line_o : std_logic_vector(7 downto 0) := (others => '0');
	signal rx_completed_o : std_logic := '0';
	
	constant c_hex43 : std_logic_vector(10 downto 0) := "11" & X"43" & '0'; -- LSB = 0 (Start bit), MSB = 00 (Stop bits)
	constant c_hexA2 : std_logic_vector(10 downto 0) := "11" & X"A2" & '0'; -- LSB = 0 (Start bit), MSB = 00 (Stop bits)


begin


	uut : UART_Rx
	generic map
	(
		c_clk_frequency => c_clk_frequency,
		c_baud_rate => c_baud_rate
	)
	port map
	(
		clk_i => clk_i,
		rx_line_i => rx_line_i,
		rx_line_o => rx_line_o,
		rx_completed_o => rx_completed_o
	);
	
	
	P_CLK : process begin
		wait for c_clk_period / 2;
		clk_i <= '0';
		wait for c_clk_period / 2;
		clk_i <= '1';
	end process;
	
	
	P_STIMULUS : process begin
			
		wait for c_clk_period * 10;
		wait until falling_edge(clk_i);
		
		---------------------------
		for i in 0 to 10 loop
			rx_line_i <= c_hex43(i);
			wait for c_baud_rate_period;	
		end loop;
		
		wait for 10 us;
		---------------------------
		---------------------------
		
		
		wait for c_clk_period * 10;
		
		
		---------------------------
		---------------------------
		for i in 0 to 10 loop
			rx_line_i <= c_hexA2(i);
			wait for c_baud_rate_period;	
		end loop;
		
		wait for 10 us;
		---------------------------
		
		
		assert false report "Simulation Completed!" severity failure;

		
	end process;
	
	
end architecture;
