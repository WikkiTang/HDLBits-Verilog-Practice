By default, al the unknown labels in a verilog file are defined as wires. This bahaviour is very dangerous. Any typo on the signals name will be not detected.

To solve this, all the verilog files include this command in the beginning:
`default_nettype none

If the tools detect a signal that has not been previously declared, an error will be shown

It very import that icestudio add automatically that statement. It will prevent a lot of hours of debugging
