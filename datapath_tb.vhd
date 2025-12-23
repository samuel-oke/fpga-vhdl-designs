library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity datapath_tb is
end entity;

architecture tb of datapath_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal alu_ctrl : std_logic_vector(5 downto 0) := (others => '0');
    signal alu_sel : std_logic := '0';
    signal data_in : std_logic_vector(15 downto 0) := (others => '0');
    signal a_sel : std_logic := '0';
    signal a_wen : std_logic := '0';
    signal d_wen : std_logic := '0';
    signal jump_ctrl : std_logic_vector(2 downto 0) := (others => '0');
    signal ram_in : std_logic_vector(15 downto 0) := (others => '0');
    signal ram_out : std_logic_vector(15 downto 0);
    signal ram_addr : integer;
    signal instr_addr : integer;
    signal p, z, n : std_logic;

    constant CLOCK_PERIOD : time := 20 ns;
    signal last_pc : integer := 0;
    signal test_done : std_logic := '0';
begin
    uut : entity work.ece3140_dp
        port map (
            clk => clk,
            rst => rst,
            alu_ctrl => alu_ctrl,
            alu_sel => alu_sel,
            data_in => data_in,
            a_sel => a_sel,
            a_wen => a_wen,
            d_wen => d_wen,
            jump_ctrl => jump_ctrl,
            ram_in => ram_in,
            ram_out => ram_out,
            ram_addr => ram_addr,
            instr_addr => instr_addr,
            p => p,
            z => z,
            n => n
        );

    clk <= not clk after CLOCK_PERIOD/2;

    process
    begin
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- Load A with F00D
        wait until falling_edge(clk);
        a_wen <= '1';
        a_sel <= '0';
        data_in <= x"F00D";

        wait until falling_edge(clk);
        a_wen <= '0';
        alu_ctrl <= "110000"; -- per your control scheme: pass A
        wait until rising_edge(clk);
        wait for 1 ns;
        assert ram_out = x"F00D" report "FAIL: Register A did not load correctly" severity error;

        -- PC increments
        wait until falling_edge(clk);
        last_pc <= instr_addr;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert instr_addr = last_pc + 1 report "FAIL: PC did not increment correctly" severity error;

        test_done <= '1';
        wait;
    end process;
end architecture;
