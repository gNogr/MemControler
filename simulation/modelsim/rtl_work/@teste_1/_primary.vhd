library verilog;
use verilog.vl_types.all;
entity Teste_1 is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        memory_accepts_input: in     vl_logic;
        memory_results_ready: in     vl_logic;
        mem_out         : in     vl_logic_vector(15 downto 0);
        start           : in     vl_logic;
        addr_reg        : out    vl_logic_vector(21 downto 0);
        data_reg        : out    vl_logic_vector(15 downto 0);
        error           : out    vl_logic_vector(7 downto 0);
        we              : out    vl_logic;
        finish          : out    vl_logic
    );
end Teste_1;
