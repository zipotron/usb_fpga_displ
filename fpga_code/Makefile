PROJ := top
PIN_DEF := wires.pcf
DEVICE := hx8k

SIMCOMPILER := iverilog
SIMULATOR := vvp
VIEWER := gtkwave

TOPMODULE := top

SYNTHFLAGS := -p synth_ice40 -top $(TOPMODULE)
PNRFLAGS := --$(DEVICE) --package tq144:4k --json $(TOPMODULE).json --pcf $(PIN_DEF)
SIMCOMPFLAGS :=
SIMFLAGS := -v

SRCS = $(wildcard *.v)
TBSRCS = $(filter %_tb.v, $(SRCS))
MODSRCS = $(filter-out %_tb.v %_incl.v, $(SRCS))
VVPS = $(patsubst %.v,%.vvp,$(TBSRCS))
VCDS = $(patsubst %_tb.v,%_wave.vcd,$(TBSRCS))

BINS := $(PROJ).bin
RPTS := $(patsubst %.bin,%.rpt,$(BINS))
JSONS := $(patsubst %.bin,%.json,$(BINS))
ASCS := $(patsubst %.bin,%.asc,$(BINS))

all: timing bitstream

timing: $(RPTS)

bitstream: $(BINS)

simulate: $(VCDS)

$(JSONS): %.json: %.v $(MODSRCS)
	yosys -Q -q '$(SYNTHFLAGS) -json $@' $^

$(ASCS): %.asc: $(PIN_DEF) %.json
	nextpnr-ice40 $(PNRFLAGS) --asc  $@

$(BINS): %.bin: %.asc
	icepack $< $@

$(RPTS): %.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

$(VVPS): %.vvp: %.v $(MODSRCS)
	$(SIMCOMPILER) $(SIMCOMPFLAGS) $^ -o $@

$(VCDS): %_wave.vcd: %_tb.vvp
	$(SIMULATOR) $(SIMFLAGS) $<

prog: $(PROJ).bin
	iceprog $<

sudo-prog: $(PROJ).bin
	@echo 'Executing prog as root!!!'
	sudo iceprog $<

clean:
	-rm $(wildcard *.vvp) $(wildcard *.vcd) $(JSONS) $(BINS) $(RPTS) $(ASCS)

.SECONDARY:
.PHONY: all timing bitstream simulate prog clean
