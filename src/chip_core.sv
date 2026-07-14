/*
Copyright (c) 2026 Julia Desmazes 

This code was written by a human, authorization is explicitly not 
granted to use it to train any model. 
*/

`default_nettype none

module chip_core #(
`ifdef VERILATOR_LINT
    parameter NUM_INPUT_PADS = 1,
    parameter NUM_BIDIR_PADS = 1,
    parameter NUM_ANALOG_PADS = 30
`else
    parameter NUM_INPUT_PADS,
    parameter NUM_BIDIR_PADS,
    parameter NUM_ANALOG_PADS
`endif
    )(
    `ifdef USE_POWER_PINS
    inout  wire VDD,
    inout  wire VSS,
    `endif
    
    input  wire clk,       // clock
    input  wire rst_n,     // reset (active low)
    
    input  wire [NUM_INPUT_PADS-1:0] input_in,   // Input value
    output wire [NUM_INPUT_PADS-1:0] input_pu,   // Pull-up
    output wire [NUM_INPUT_PADS-1:0] input_pd,   // Pull-down

    input  wire [NUM_BIDIR_PADS-1:0] bidir_in,   // Input value
    output wire [NUM_BIDIR_PADS-1:0] bidir_out,  // Output value
    output wire [NUM_BIDIR_PADS-1:0] bidir_oe,   // Output enable
    output wire [NUM_BIDIR_PADS-1:0] bidir_cs,   // Input type (0=CMOS Buffer, 1=Schmitt Trigger)
    output wire [NUM_BIDIR_PADS-1:0] bidir_sl,   // Slew rate (0=fast, 1=slow)
    output wire [NUM_BIDIR_PADS-1:0] bidir_ie,   // Input enable
    output wire [NUM_BIDIR_PADS-1:0] bidir_pu,   // Pull-up
    output wire [NUM_BIDIR_PADS-1:0] bidir_pd,   // Pull-down

    inout  wire [NUM_ANALOG_PADS-1:0] analog  // Analog
);
wire [NUM_BIDIR_PADS-1:0] bidir_input_unused; 

// tie unused pins
localparam UNUSED_BIDIR_PADS_CNT = NUM_BIDIR_PADS; 

assign bidir_oe[NUM_BIDIR_PADS-1-:UNUSED_BIDIR_PADS_CNT]  = {UNUSED_BIDIR_PADS_CNT{1'b1}};
assign bidir_cs[NUM_BIDIR_PADS-1-:UNUSED_BIDIR_PADS_CNT]  = {UNUSED_BIDIR_PADS_CNT{1'b0}};
assign bidir_sl[NUM_BIDIR_PADS-1-:UNUSED_BIDIR_PADS_CNT]  = {UNUSED_BIDIR_PADS_CNT{1'b0}};
assign bidir_ie[NUM_BIDIR_PADS-1-:UNUSED_BIDIR_PADS_CNT]  = {UNUSED_BIDIR_PADS_CNT{1'b0}};
assign bidir_pu[NUM_BIDIR_PADS-1-:UNUSED_BIDIR_PADS_CNT]  = {UNUSED_BIDIR_PADS_CNT{1'b0}};
assign bidir_pd[NUM_BIDIR_PADS-1-:UNUSED_BIDIR_PADS_CNT]  = {UNUSED_BIDIR_PADS_CNT{1'b0}}; // floating pad

assign bidir_input_unused[NUM_BIDIR_PADS-1-:UNUSED_BIDIR_PADS_CNT] = bidir_in[NUM_BIDIR_PADS-1-:UNUSED_BIDIR_PADS_CNT];

localparam INPUT_UNUSED = NUM_INPUT_PADS; 
assign input_pu[NUM_INPUT_PADS-1-:INPUT_UNUSED] = {INPUT_UNUSED{1'b0}};
assign input_pd[NUM_INPUT_PADS-1-:INPUT_UNUSED] = {INPUT_UNUSED{1'b1}};

reg in0_q;
 
always @(posedge clk) begin
	if (~rst_n) 
		in0_q <= 1'b0;
	else 
		in0_q <= |input_in;
end

assign bidir_out = {NUM_BIDIR_PADS{in0_q}};

endmodule 

`default_nettype wire
