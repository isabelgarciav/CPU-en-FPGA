library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_tiny_CPU is
end tb_tiny_CPU;

architecture tb of tb_tiny_CPU is

    -- COMPONENTS
    component tiny_CPU is
        port (
            clock: in std_logic;
            reset: in std_logic;
            instr: in std_logic_vector(15 downto 0);

            -- Outputs for TinyCPU
            output0: out std_logic_vector(15 downto 0);
            output1: out std_logic_vector(15 downto 0);
            output2: out std_logic_vector(15 downto 0);
            output3: out std_logic_vector(15 downto 0);
            output4: out std_logic_vector(15 downto 0);
            output5: out std_logic_vector(15 downto 0);
            output6: out std_logic_vector(15 downto 0);
            output7: out std_logic_vector(15 downto 0);
            output8: out std_logic_vector(15 downto 0);
            output9: out std_logic_vector(15 downto 0);
            output10: out std_logic_vector(15 downto 0);
            output11: out std_logic_vector(15 downto 0);
            output12: out std_logic_vector(15 downto 0);
            output13: out std_logic_vector(15 downto 0);
            output14: out std_logic_vector(15 downto 0);
            output15: out std_logic_vector(15 downto 0)
        );
    end component;

    component dma_controller is
        port (
            mm2s_data: out std_logic_vector(15 downto 0); -- Simulated data from DMA
            clock: in std_logic;
            reset: in std_logic
        );
    end component;

    -- SIGNALS
    signal ps_clk: std_logic := '0';
    signal ps_reset: std_logic := '1';

    signal tb_clk: std_logic := '0';
    signal tb_reset: std_logic := '1';
    signal tb_instr: std_logic_vector(15 downto 0);

    signal dma_mm2s_data: std_logic_vector(15 downto 0);

    signal tb_output0: std_logic_vector(15 downto 0);
    signal tb_output1: std_logic_vector(15 downto 0);
    signal tb_output2: std_logic_vector(15 downto 0);
    signal tb_output3: std_logic_vector(15 downto 0);
    signal tb_output4: std_logic_vector(15 downto 0);
    signal tb_output5: std_logic_vector(15 downto 0);
    signal tb_output6: std_logic_vector(15 downto 0);
    signal tb_output7: std_logic_vector(15 downto 0);
    signal tb_output8: std_logic_vector(15 downto 0);
    signal tb_output9: std_logic_vector(15 downto 0);
    signal tb_output10: std_logic_vector(15 downto 0);
    signal tb_output11: std_logic_vector(15 downto 0);
    signal tb_output12: std_logic_vector(15 downto 0);
    signal tb_output13: std_logic_vector(15 downto 0);
    signal tb_output14: std_logic_vector(15 downto 0);
    signal tb_output15: std_logic_vector(15 downto 0);

begin

    -- Synchronize clocks
    ps_clk_process: process
    begin
        ps_clk <= '0';
        wait for 5 ns;
        ps_clk <= '1';
        wait for 5 ns;
    end process;

    tb_clk <= ps_clk; -- Synchronize tb_clk with ps_clk

    -- Synchronize resets
    ps_reset_process: process
    begin
        ps_reset <= '1';
        wait for 20 ns;
        ps_reset <= '0';
        wait;
    end process;

    tb_reset <= ps_reset; -- Synchronize tb_reset with ps_reset

    -- Instantiate TinyCPU
    tiny_cpu_inst: tiny_CPU
        port map (
            clock => tb_clk,
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

    -- Instantiate DMA controller (simulated)
    dma_controller_inst: dma_controller
        port map (
            mm2s_data => dma_mm2s_data,
            clock => ps_clk,
            reset => ps_reset
        );

    -- Connect DMA to tb_instr
    tb_instr <= dma_mm2s_data;

    -- Simulate DMA data generation
    dma_process: process
    begin
        wait until ps_reset = '0'; -- Wait until reset is released
        dma_mm2s_data <= "0100000000000011"; -- LD reg0, #3
        wait for 40 ns;
        dma_mm2s_data <= "0100000100001010"; -- LD reg1, #10
        wait for 40 ns;
        dma_mm2s_data <= "1111001000000001"; -- ADD reg2, reg0, reg1
        wait for 40 ns;
        dma_mm2s_data <= "1101001100010000"; -- SUB reg3, reg1, reg0
        wait for 40 ns;
        dma_mm2s_data <= "1011010000000001"; -- AND reg4 reg0 reg1
        wait for 40 ns;
        dma_mm2s_data <= "1001010100000001"; -- OR reg5 reg0 reg1
        wait;
    end process;

end tb;
