`default_nettype none

module top #(
    parameter CLK_FREQ = 12_000_000
)(
    input wire clk,

    // PmodOLEDrgb wires
    output wire oled_cs,
    output wire oled_sdin,
    output wire oled_sclk,
    output wire oled_d_cn,
    output wire oled_resn,
    output wire oled_vccen,
    output wire oled_pmoden,

    // FTDI MPSSE wires
    input wire FTDI_GPIOL0,
    input wire FTDI_CS,
    input wire FTDI_DO,
    input wire FTDI_SK,

    // LED wires
    output wire LED1,
    output wire LED2,
    output wire LED3,
    output wire LED4,
    output wire LED5
);

// Simple reset generator (pulls reset high for the first n cycles)
// 2^11 cycles (~170 us @ 12MHz) seems to be enough for display's Vdd/Vddio to stabilize
reg [11:0] rststate = 0;
wire reset = !(&rststate);
always @(posedge clk) rststate <= rststate + reset;

//assign LED1 = 0;
//assign LED2 = 0;
//assign LED3 = 0;
assign LED5 = !reset; // just to see if we're on

// oled init wiring
wire pwr_sdata, pwr_sclk, pwr_cs, pwr_d_cn, pwr_on_done;
// once oled init is done we let FTDI drive the display
assign oled_sclk = pwr_on_done ? FTDI_SK : pwr_sclk;
assign oled_sdin = pwr_on_done ? FTDI_DO : pwr_sdata;
assign oled_cs   = pwr_on_done ? FTDI_CS : pwr_cs;
assign oled_d_cn = pwr_on_done ? FTDI_GPIOL0 : pwr_d_cn;

reg [6:0] bit_transfered = 0;
always @(negedge FTDI_SK) bit_transfered <= bit_transfered + 1;

assign LED4 = ~FTDI_CS ? bit_transfered[6] : pwr_on_done;
assign LED2 = ~FTDI_CS;
assign LED1 = ~FTDI_CS & oled_d_cn;
assign LED3 = ~FTDI_CS & ~oled_d_cn;

pwr_on_ctl_mem #(
    .CLK_FREQ(CLK_FREQ),
    .DISPLAY_MODE(8'hA4)
) pwr_on (
    .clk(clk),
    .reset(reset),
    .sdata(pwr_sdata),
    .sclk(pwr_sclk),
    .cs(pwr_cs),
    .d_cn(pwr_d_cn),
    .pmoden(oled_pmoden),
    .vccen(oled_vccen),
    .resn(oled_resn),
    .done(pwr_on_done)
);

endmodule
