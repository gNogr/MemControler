library verilog;
use verilog.vl_types.all;
entity core is
    generic(
        CLK_FREQUENCY   : integer := 27;
        REF_TIME        : integer := 64;
        REF_COUNT       : integer := 4096;
        PWR_TIME        : integer := 100;
        ROW_SIZE        : integer := 4096;
        COL_SIZE        : integer := 512;
        NUM_BANK        : integer := 4
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        we_n            : in     vl_logic;
        re_n            : in     vl_logic;
        command         : out    vl_logic_vector(3 downto 0);
        cur_state       : out    vl_logic_vector(3 downto 0);
        counter         : out    vl_logic_vector(13 downto 0);
        w_ready         : out    vl_logic;
        waiting         : out    vl_logic;
        valid           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLK_FREQUENCY : constant is 1;
    attribute mti_svvh_generic_type of REF_TIME : constant is 1;
    attribute mti_svvh_generic_type of REF_COUNT : constant is 1;
    attribute mti_svvh_generic_type of PWR_TIME : constant is 1;
    attribute mti_svvh_generic_type of ROW_SIZE : constant is 1;
    attribute mti_svvh_generic_type of COL_SIZE : constant is 1;
    attribute mti_svvh_generic_type of NUM_BANK : constant is 1;
end core;
