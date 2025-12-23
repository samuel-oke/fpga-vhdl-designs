library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Board wrapper (cleaned)
entity lab11_top is
  port(
    clk_50MHz : in  std_logic;
    rst_n     : in  std_logic;
    step_n    : in  std_logic;
    leds      : out std_logic_vector(9 downto 0);
    switches  : in  std_logic_vector(9 downto 0);
    segments  : out std_logic_vector(47 downto 0)
  );
end entity;

architecture rtl of lab11_top is
  signal a_reg_value : integer := 0;
  signal a_wen, d_wen : std_logic;

  signal rst, step : std_logic;
  signal step_clk : std_logic := '0';
  signal last_step : std_logic := '0';
  signal debounce_count : integer := 0;
  constant debounce_time : time := 20 ms;
  constant clock_period  : time := 20 ns;

  signal ram_out_s : std_logic_vector(15 downto 0);
  signal instr_addr_s : integer;
  signal p_s, z_s, n_s : std_logic;
begin
  rst  <= not rst_n;
  step <= not step_n;

  process(clk_50MHz, rst)
  begin
    if rst = '1' then
      step_clk <= '0';
      debounce_count <= 0;
      last_step <= '0';
    elsif rising_edge(clk_50MHz) then
      if step_clk = '1' then
        step_clk <= '0';
      else
        if step = '1' and last_step = '0' and debounce_count = 0 then
          step_clk <= '1';
          debounce_count <= integer(debounce_time / clock_period);
        elsif debounce_count > 0 then
          debounce_count <= debounce_count - 1;
        end if;
      end if;
      last_step <= step;
    end if;
  end process;

  a_wen <= switches(0) when switches(9) = '1' else '1';
  d_wen <= switches(0) when switches(9) = '1' else '0';

  dp_inst : entity work.ece3140_dp
    port map(
      clk        => step_clk,
      rst        => rst,
      alu_ctrl   => switches(7 downto 2),
      alu_sel    => '0',
      data_in    => "000000" & switches,
      a_sel      => switches(9),
      a_wen      => a_wen,
      d_wen      => d_wen,
      jump_ctrl  => "000",
      ram_in     => x"0000",
      ram_out    => ram_out_s,
      ram_addr   => a_reg_value,
      instr_addr => instr_addr_s,
      p          => p_s,
      z          => z_s,
      n          => n_s
    );

  leds <= switches;

  process(a_reg_value)
    variable var_div, var_mod : integer;
    variable seg : std_logic_vector(7 downto 0);
  begin
    var_div := a_reg_value;

    for i in 0 to 5 loop
      var_mod := var_div mod 10;
      var_div := var_div / 10;

      if var_mod = 0 and var_div = 0 and i /= 0 then
        seg := not "00000000";
      else
        case var_mod is
          when 0 => seg := not "00111111";
          when 1 => seg := not "00000110";
          when 2 => seg := not "01011011";
          when 3 => seg := not "01001111";
          when 4 => seg := not "01100110";
          when 5 => seg := not "01101101";
          when 6 => seg := not "01111101";
          when 7 => seg := not "00000111";
          when 8 => seg := not "01111111";
          when 9 => seg := not "01101111";
          when others => seg := "11111111";
        end case;
      end if;

      segments((i*8)+7 downto i*8) <= seg;
    end loop;
  end process;
end architecture;
