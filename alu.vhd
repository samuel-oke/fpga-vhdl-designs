library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- ALU (cleaned)
entity alu is
  port(
    a      : in  std_logic_vector(15 downto 0);
    b      : in  std_logic_vector(15 downto 0);
    ctrl   : in  std_logic_vector(5 downto 0);
    result : out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of alu is
  signal a_pre : std_logic_vector(15 downto 0);
  signal b_pre : std_logic_vector(15 downto 0);
begin
  -- A pre-processing: ctrl(5 downto 4)
  proc_a : process(a, ctrl(5 downto 4))
  begin
    case ctrl(5 downto 4) is
      when "00" => a_pre <= a;
      when "01" => a_pre <= not a;
      when "10" => a_pre <= (others => '0');
      when "11" => a_pre <= (others => '1');
      when others => a_pre <= (others => '0');
    end case;
  end process;

  -- B pre-processing: ctrl(3 downto 2)
  proc_b : process(b, ctrl(3 downto 2))
  begin
    case ctrl(3 downto 2) is
      when "00" => b_pre <= b;
      when "01" => b_pre <= not b;
      when "10" => b_pre <= (others => '0');
      when "11" => b_pre <= (others => '1');
      when others => b_pre <= (others => '0');
    end case;
  end process;

  -- Final op select: ctrl(1 downto 0)
  proc_result : process(a_pre, b_pre, ctrl(1 downto 0))
    variable sum_v : std_logic_vector(15 downto 0);
  begin
    case ctrl(1 downto 0) is
      when "00" =>  -- AND
        result <= a_pre and b_pre;
      when "01" =>  -- NAND
        result <= not (a_pre and b_pre);
      when "10" =>  -- ADD
        sum_v := std_logic_vector(unsigned(a_pre) + unsigned(b_pre));
        result <= sum_v;
      when "11" =>  -- NOT(ADD)
        sum_v := std_logic_vector(unsigned(a_pre) + unsigned(b_pre));
        result <= not sum_v;
      when others =>
        result <= (others => '0');
    end case;
  end process;
end architecture;
