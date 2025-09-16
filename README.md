# RISC OS Debugger module in C

## Summary

This is a module for RISC OS which integrates some open source disassembler components into a RISC OS module.
The repository is intended for use on RISC OS 32bit and 64bit systems.

The Debugger module here pulls in components from two open source repositories:

* `DArm` - an ARM/Thumb disassembly library (https://github.com/gerph/darm, forked from https://githum.com/jbremer/darm)
* `Armadillo` an AArch64 disassembly library (https://github.com/gerph/armadillo, forked from https://github.com/jsherman212/armadillo)

## Functionality

The code here supports building for 32bit and 64bit environments, allowing it to be used on RISC OS Classic, RISC OS Pyromaniac and RISC OS Pyromaniac running in AArch64 ('RISC OS 64').

The disassembly supports:

* `*MemoryI`
* `*MemoryA`
* `*DumpI` (new *-command, as supported by RISC OS Pyromaniac)
* `*InitStore`
* `*ShowRegs`
* `*BreakSet` (not for RISC OS 64)
* `*BreakClr` (not for RISC OS 64)
* `*BreakList` (not for RISC OS 64)
* `*Debug` (not for RISC OS 64)
* `*Continue` (not for RISC OS 64)
* SWI `Debugger_Disassemble`
* SWI `Debugger_DisassembleThumb`
* SWI `Debugger_DisassembleArch` (for AArch32 ARM and Thumb, and for AArch64 instructions)

## Development

The development of this module is documented through a live coding series on YouTube. The full playlist of all the live sessions can be found here: https://www.youtube.com/watch?v=H08vtW1nZ9g&list=PLVVIu906Y7rG9arQQU7hzueTykjxtiGVH


## License

The code is released under the [3-clause BSD license](LICENCE).
