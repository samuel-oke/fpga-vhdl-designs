library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller is
    port (
        clk : in std_logic;
        rst_n : in std_logic;
        step_n : in std_logic;
        switches : in std_logic_vector(9 downto 0);
        leds : out std_logic_vector(9 downto 0);
        segments : out std_logic_vector(47 downto 0)
    );
end entity;

architecture rtl of controller is

    function int_to_segments (input : in integer) return std_logic_vector is
        variable current_segment : std_logic_vector(7 downto 0) := (others => '1');
        variable current_digit : integer;
        constant NUM_SEGMENTS : integer := 6;
        variable segs : std_logic_vector((NUM_SEGMENTS * 8) - 1 downto 0) := (others => '1');
    begin
        for i in 0 to NUM_SEGMENTS - 1 loop
            current_digit := (input / (10 ** i)) mod 10;

            if input / (10 ** i) = 0 and i > 0 then
                current_segment := not "00000000";
            else
                case current_digit is
                    when 0 => current_segment := not "00111111";
                    when 1 => current_segment := not "00000110";
                    when 2 => current_segment := not "01011011";
                    when 3 => current_segment := not "01001111";
                    when 4 => current_segment := not "01100110";
                    when 5 => current_segment := not "01101101";
                    when 6 => current_segment := not "01111101";
                    when 7 => current_segment := not "00000111";
                    when 8 => current_segment := not "01111111";
                    when 9 => current_segment := not "01101111";
                    when others => current_segment := not "00000000";
                end case;
            end if;

            segs((i * 8) + 7 downto i * 8) := current_segment;
        end loop;

        return segs;
    end function;

    signal pc_clk : std_logic := '0';
    signal last_step_n : std_logic := '1';
    signal debounce_counter : integer := 0;
    constant CLOCK_PERIOD : time := 20 ns;
    constant DEBOUNCE_LENGTH : time := 10 ms;

    signal pc_value : integer range 0 to 15;
    signal rst : std_logic;

begin

    process (clk, rst)
    begin
        if rst = '1' then
            pc_clk <= '0';
            last_step_n <= '1';
            debounce_counter <= 0;
        elsif rising_edge(clk) then
            if pc_clk = '1' then
                pc_clk <= '0';
            elsif debounce_counter < integer(DEBOUNCE_LENGTH / CLOCK_PERIOD) then
                debounce_counter <= debounce_counter + 1;
            else
                if step_n = '0' and last_step_n = '1' then
                    pc_clk <= '1';
                    debounce_counter <= 0;
                end if;
            end if;
            last_step_n <= step_n;
        end if;
    end process;

    u_pc : entity work.program_counter
        port map (
            clk => pc_clk,
            rst => rst,
            jump_ctrl => switches(9 downto 7),
            pzn_flags => switches(6 downto 4),
            jump_address => to_integer(unsigned(switches(3 downto 0))),
            pc_out => pc_value
        );

    leds <= switches;
    segments <= int_to_segments(pc_value);
    rst <= not rst_n;

end architecture;
