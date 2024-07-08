library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_UART_Tx is
	generic 
	(
		c_clk_frequency : integer := 100_000; -- 10 ns for 1 period
		c_baud_rate : integer := 10_000; -- 100 us time for the sent 1 bit
		c_num_of_stop_bit : integer := 2
	);
end entity;


architecture Behavioral of tb_UART_Tx is
	
	component UART_Tx is
		generic 
		(
			c_clk_frequency : integer := 100_000_000; -- 10 ns for 1 period
			c_baud_rate : integer := 115_800; -- 8.63 us
			c_num_of_stop_bit : integer := 2
		);
		port 
		(
			clk_i : in std_logic;
			data_i : in std_logic_vector(7 downto 0);
			start_i : in std_logic;
			tx_line_o : out std_logic;
			tx_completed_o : out std_logic	
		);
	end component;
	
	constant c_clk_period : time := 1 sec / real(c_clk_frequency);
	
	signal clk_i : std_logic := '0';
	signal data_i : std_logic_vector(7 downto 0) := (others => '0');
	signal start_i : std_logic := '0';
	signal tx_line_o : std_logic := '0';
	signal tx_completed_o : std_logic := '0';	

begin
	
	uut : UART_Tx
	generic map
	(
		c_clk_frequency => c_clk_frequency,
		c_baud_rate => c_baud_rate,
		c_num_of_stop_bit => c_num_of_stop_bit
	)
	port map
	(
		clk_i => clk_i,
		data_i => data_i,
		start_i => start_i,
		tx_line_o => tx_line_o,
		tx_completed_o => tx_completed_o
	);


	P_CLK : process begin
		wait for c_clk_period / 2;
		clk_i <= '0';
		wait for c_clk_period / 2; 
		clk_i <= '1';
	end process;
	
	
	P_SITIMULUS : process begin
	
		data_i <= x"00";
		start_i <= '0';

		wait for c_clk_period * 10;
		
		-- Update signals @ the falling_edge to proove design compansates requirements.
		wait until falling_edge(clk_i);
		data_i <= x"51";
		start_i <= '1';
		wait for c_clk_period;
		start_i <= '0';
		wait for 1.2 ms;
		
		
		-- Update signals @ the falling_edge to proove design compansates requirements.
		wait until falling_edge(clk_i);
		data_i <= x"A3";
		start_i <= '1';
		wait for c_clk_period;
		start_i <= '0';
		wait for 1.2 ms;

	
	end process;




end architecture;
