

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity tb_tiny_CPU is

end tb_tiny_CPU;

architecture tb of tb_tiny_CPU is

	component tiny_CPU is
	  port (
		clock: in std_logic;
		reset: in std_logic;
		instr: in std_logic_vector(15 downto 0);

	--### OUTPUTS FOR TINY CPU ###--
		output0: out std_logic_vector(15 downto 0) ;
		output1: out std_logic_vector(15 downto 0) ;
		output2: out std_logic_vector(15 downto 0) ;
		output3: out std_logic_vector(15 downto 0) ;
		output4: out std_logic_vector(15 downto 0) ;
		output5: out std_logic_vector(15 downto 0) ;
		output6: out std_logic_vector(15 downto 0) ;
		output7: out std_logic_vector(15 downto 0) ;
		output8: out std_logic_vector(15 downto 0) ;
		output9: out std_logic_vector(15 downto 0) ;
		output10: out std_logic_vector(15 downto 0) ;
		output11: out std_logic_vector(15 downto 0) ;
		output12: out std_logic_vector(15 downto 0) ;
		output13: out std_logic_vector(15 downto 0) ;
		output14: out std_logic_vector(15 downto 0) ;
		output15: out std_logic_vector(15 downto 0)
	--------------------------------
	  ) ;
	end component ; -- tiny_CPU


	signal tb_clock: std_logic;
	signal tb_reset: std_logic;
	signal tb_instr: std_logic_vector(15 downto 0) ;

	signal tb_output0: std_logic_vector(15 downto 0) ;
	signal tb_output1: std_logic_vector(15 downto 0) ;
	signal tb_output2: std_logic_vector(15 downto 0) ;
	signal tb_output3: std_logic_vector(15 downto 0) ;
	signal tb_output4: std_logic_vector(15 downto 0) ;
	signal tb_output5: std_logic_vector(15 downto 0) ;
	signal tb_output6: std_logic_vector(15 downto 0) ;
	signal tb_output7: std_logic_vector(15 downto 0) ;
	signal tb_output8: std_logic_vector(15 downto 0) ;
	signal tb_output9: std_logic_vector(15 downto 0) ;
	signal tb_output10: std_logic_vector(15 downto 0) ;
	signal tb_output11: std_logic_vector(15 downto 0) ;
	signal tb_output12: std_logic_vector(15 downto 0) ;
	signal tb_output13: std_logic_vector(15 downto 0) ;
	signal tb_output14: std_logic_vector(15 downto 0) ;
	signal tb_output15: std_logic_vector(15 downto 0) ;

begin

--dut
	dut: tiny_CPU port map (
			clock => tb_clock,
			reset => tb_reset,
			instr => tb_instr,

			output0 => tb_output0,
			output1 => tb_output1,
			output2 => tb_output2,
			output3 => tb_output3,
			output4 => tb_output4,
			output5 => tb_output5,
			output6 => tb_output6,
			output7 => tb_output7,
			output8 => tb_output8,
			output9 => tb_output9,
			output10 => tb_output10,
			output11 => tb_output11,
			output12 => tb_output12,
			output13 => tb_output13,
			output14 => tb_output14,
			output15 => tb_output15
		);

--clock
	process
	begin
		tb_clock <= '0';
		while (true) loop
			wait for 5ns;
			tb_clock <= not tb_clock;
		end loop;
	end process;

--initial reset
	process
	begin
		tb_reset <= '1';
		wait for 10ns;
		tb_reset <= '0';
		while (true) loop
			wait for 1000ns;
		end loop ;
	end process;
			
--MAIN
	process 
	begin
---------------------------------
--GIVE YOUR TESTBENCH HERE:

	--initial state
		tb_instr <= "0000000000000000";
		wait for 20ns;

		while (true) loop
			wait for 40ns;
			tb_instr <= "0100000000000011";	--LD reg0 <00000011>
			wait for 40ns;
			tb_instr <= "0100000100001010";	--LD reg1 <00001010>
			wait for 40ns;
			tb_instr <= "1111001000000001";	--ADD reg2 reg0 reg1
			wait for 40ns;
			tb_instr <= "1101001100010000";	--SUB reg3 reg1 reg0
			wait for 40ns;
			tb_instr <= "1011010000000001";	--AND reg4 reg0 reg1
			wait for 40ns;
			tb_instr <= "1001010100000001";	--OR reg5 reg0 reg1
		end loop;

---------------------------------
	end process;

end tb;













