library IEEE;
use IEEE.std_logic_1164.all;

entity program_counter_tb is
end entity;

architecture tb of program_counter_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal jump_ctrl : std_logic_vector(2 downto 0) := "000";
    signal pzn_flags : std_logic_vector(2 downto 0) := "010";
    signal jump_address : integer := 0;
    signal pc_out : integer := 0;

    constant CLOCK_PERIOD : time := 20 ns;
begin

    clk <= not clk after CLOCK_PERIOD/2;

    uut : entity work.program_counter
        port map (
            clk => clk,
            rst => rst,
            jump_ctrl => jump_ctrl,
            pzn_flags => pzn_flags,
            jump_address => jump_address,
            pc_out => pc_out
        );

    process
    begin
        rst <= '1';
        wait for CLOCK_PERIOD;
        rst <= '0';

        for i in 0 to 10 loop
            wait for CLOCK_PERIOD;
        end loop;

        jump_ctrl <= "100";
        pzn_flags <= "100";
        jump_address <= 5;
        wait for CLOCK_PERIOD;

        wait;
    end process;

end architecture;
