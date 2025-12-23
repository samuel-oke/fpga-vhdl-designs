library IEEE;
use IEEE.std_logic_1164.all;

-- Program counter (cleaned)
entity program_counter is
  port (
    clk          : in  std_logic;
    rst          : in  std_logic;                    -- async, active-high
    jump_ctrl    : in  std_logic_vector(2 downto 0);
    pzn_flags    : in  std_logic_vector(2 downto 0);
    jump_address : in  integer;
    pc_out       : out integer
  );
end entity;

architecture rtl of program_counter is
  signal pc_reg : integer := 0;

  function do_jump(a, b : std_logic_vector(2 downto 0)) return boolean is
  begin
    return ((a and b) /= "000");
  end function;
begin
  pc_out <= pc_reg;

  process(clk, rst)
  begin
    if rst = '1' then
      pc_reg <= 0;
    elsif rising_edge(clk) then
      if do_jump(jump_ctrl, pzn_flags) then
        pc_reg <= jump_address;
      else
        pc_reg <= pc_reg + 1;
      end if;
    end if;
  end process;
end architecture;
