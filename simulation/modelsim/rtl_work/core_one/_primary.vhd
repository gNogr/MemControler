library verilog;
use verilog.vl_types.all;
entity core_one is
    generic(
        CLK_FREQUENCY   : integer := 27;
        REF_TIME        : integer := 64;
        REF_COUNT       : integer := 4096;
        PWR_TIME        : integer := 200;
        ROW_SIZE        : integer := 4096;
        COL_SIZE        : integer := 512;
        NUM_BANK        : integer := 4;
        W_B_Length      : vl_logic := Hi0;
        Test_mode       : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        CAS_Latency     : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        Wrap_type       : vl_logic := Hi0;
        Burst_length    : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        az_wr_n         : in     vl_logic;
        az_be_n         : in     vl_logic;
        az_data         : in     vl_logic_vector(15 downto 0);
        az_addr         : in     vl_logic_vector(21 downto 0);
        za_valid        : out    vl_logic;
        za_data         : out    vl_logic_vector(15 downto 0);
        za_wait         : out    vl_logic;
        zs_ba           : out    vl_logic_vector(1 downto 0);
        zs_addr         : out    vl_logic_vector(11 downto 0);
        zs_dqm          : out    vl_logic_vector(1 downto 0);
        zs_ras_n        : out    vl_logic;
        zs_cas_n        : out    vl_logic;
        zs_we_n         : out    vl_logic;
        zs_dq           : inout  vl_logic_vector(15 downto 0);
        counter         : out    vl_logic_vector(32 downto 0);
        error           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLK_FREQUENCY : constant is 1;
    attribute mti_svvh_generic_type of REF_TIME : constant is 1;
    attribute mti_svvh_generic_type of REF_COUNT : constant is 1;
    attribute mti_svvh_generic_type of PWR_TIME : constant is 1;
    attribute mti_svvh_generic_type of ROW_SIZE : constant is 1;
    attribute mti_svvh_generic_type of COL_SIZE : constant is 1;
    attribute mti_svvh_generic_type of NUM_BANK : constant is 1;
    attribute mti_svvh_generic_type of W_B_Length : constant is 1;
    attribute mti_svvh_generic_type of Test_mode : constant is 1;
    attribute mti_svvh_generic_type of CAS_Latency : constant is 1;
    attribute mti_svvh_generic_type of Wrap_type : constant is 1;
    attribute mti_svvh_generic_type of Burst_length : constant is 1;
end core_one;