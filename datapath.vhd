library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Datapath (cleaned)
entity ece3140_dp is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;

        alu_ctrl   : in  std_logic_vector(5 downto 0);
        alu_sel    : in  std_logic;

        data_in    : in  std_logic_vector(15 downto 0);
        a_sel      : in  std_logic;
        a_wen      : in  std_logic;
        d_wen      : in  std_logic;

        jump_ctrl  : in  std_logic_vector(2 downto 0);

        ram_in     : in  std_logic_vector(15 downto 0);
        ram_addr   : out integer;
        ram_out    : out std_logic_vector(15 downto 0);

        instr_addr : out integer;

        p          : out std_logic;
        z          : out std_logic;
        n          : out std_logic
    );
end entity ece3140_dp;

architecture rtl of ece3140_dp is
    signal a_reg  : std_logic_vector(15 downto 0);
    signal d_reg  : std_logic_vector(15 downto 0);
    signal a_next : std_logic_vector(15 downto 0);

    signal alu_b_in   : std_logic_vector(15 downto 0);
    signal alu_result : std_logic_vector(15 downto 0);

    signal pc_value   : integer := 0;
    signal pzn_flags  : std_logic_vector(2 downto 0);

    signal p_int, z_int, n_int : std_logic;
begin
    mux_logic : process(a_reg, ram_in, data_in, alu_result, a_sel, alu_sel)
    begin
        a_next   <= alu_result;
        alu_b_in <= ram_in;

        if a_sel = '0' then
            a_next <= data_in;
        end if;

        if alu_sel = '0' then
            alu_b_in <= a_reg;
        end if;
    end process;

    reg_A : entity work.reg_generic
        generic map ( BIT_WIDTH => 16 )
        port map (
            clk => clk,
            rst => rst,
            wen => a_wen,
            d   => a_next,
            q   => a_reg
        );

    reg_D : entity work.reg_generic
        generic map ( BIT_WIDTH => 16 )
        port map (
            clk => clk,
            rst => rst,
            wen => d_wen,
            d   => alu_result,
            q   => d_reg
        );

    alu_block : entity work.alu
        port map (
            a      => d_reg,
            b      => alu_b_in,
            ctrl   => alu_ctrl,
            result => alu_result
        );

    pc_block : entity work.program_counter
        port map (
            clk          => clk,
            rst          => rst,
            jump_ctrl    => jump_ctrl,
            pzn_flags    => pzn_flags,
            jump_address => to_integer(unsigned(a_reg)),
            pc_out       => pc_value
        );

    ram_addr   <= to_integer(unsigned(a_reg));
    ram_out    <= alu_result;
    instr_addr <= pc_value;

    flag_proc : process(alu_result)
    begin
        if alu_result = x"0000" then
            z_int <= '1';
        else
            z_int <= '0';
        end if;

        n_int <= alu_result(15);

        if (alu_result(15) = '0') and (alu_result /= x"0000") then
            p_int <= '1';
        else
            p_int <= '0';
        end if;
    end process;

    p <= p_int;
    z <= z_int;
    n <= n_int;

    pzn_flags <= p_int & z_int & n_int;
end architecture;
