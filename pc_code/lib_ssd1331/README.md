# SSD1331 FTDI Driver

Helper library for driving SSD1331 display connected to interface B of FT2232H chip.

## Hardware
There's a few setups allowing to connect SSD1331 to FT2232H:
- FT2232H Breakout Board
- ICE40 ICEstick board (via FPGA)

Commands and data are transfered in MPSSE mode at 10 MHz. FT2232H takes care of SK/DO/CS signalling, GPIOL0 is used as data/command signal.

Supported commands:
- Raw pixel data
- Draw line
- Draw rectangle (with fill toggle)
- Clear display
- Clear window

## TODO List
- Add init procedure for bare FT2232H boards (currently init must be done in FPGA)
- Add interface configuration (currently interface B of FT2232H is hardcoded)
- Add frequency selection (currently 10 MHz is hardcoded)
- Add more commands
