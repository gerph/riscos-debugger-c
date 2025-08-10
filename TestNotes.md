# Notes for testing

## Simple testing

The disassembly of immediate constants should be automated in the future.
At present the tests are just being run locally for certain values. The
following are useful tests to try:

    pyrodev --common --load-module rm32/Debugger,ffa --command "memorya 9000 e3a01e65" --command "memoryi 9000+4"

This tests the instruction `e3a01e65` in disassembly.

## Testcode examples

The testcode directory contains an example binary which gives
example instructions in different forms. This can be used to check
the system is working properly.

## Using DisassembleArch tests

The testcode for Debugger_DisassembleArch can be triggered through the `debugger` test tool.

Example commands:

* `debugger a0,2203a0e3,` - disassemble an ARM sequence
* `debugger a0,2203a0e31234,` - disassemble an overlong ARM sequence
* `debugger a0,2203,` - disassemble a short ARM sequence (should fail)
* `debugger a1,a0000010,` - disassemble a AArch64 seqeunce
* `debugger a99,a0000010,` - disassemble an invalid architecture
* `debugger a3,1324,` - disassemble thumb
