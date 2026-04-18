![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# DSP FIR Tiny Tapeout

This is a Digital Signal Processor implemented using a 8-bit, 8-taps  Finite Impulse Response (FIR) Filter with configurable coefficients using Q1.7 fixed point arithmetic.

- This repo holds the latest Verilog RTL source file for DSP FIR Tiny Tapeout Project.
- Initially targeting the Sky130 PDK, however this project couldn't be delivered in time for the TTSKY26a Shuttle.
- A separate repo for the TTGF26a Shuttle targeting the GlobalFoundries 180nm PDK is in the works.

## Related Repositories
- [dsp_fir_tapeout](https://github.com/seapanda0/dsp_fir_tapeout) - Tapeout ready repo for TTSKY26a shuttle.
- [simulation_dsp_fir](https://github.com/seapanda0/simulation_dsp_fir) - Simulate FIR filter and generate coefficients.
- [stm_dsp_fir](https://github.com/seapanda0/stm_dsp_fir) - Software implementation of the FIR filter with STM32F401 Microcontroller.
- [dsp_fir_fpga](https://github.com/seapanda0/stm_dsp_fir) - Hardware implementation on DE2i-150 Cyclone IV FPGA Board.
- [adc08100_sim](https://github.com/seapanda0/adc08100_sim) - Simulate the behaviour of ADC08100 IC using a STM32F401 (works fine at low speeds).

## How to Test

This project has been verified using an FPGA. An external ADC and DAC IC with 8 bit parallel interface is needed. A microcontroller is also needed to load the coefficients before starting the filter operation.

## External hardware

ADC08100 Datasheet:
https://www.ti.com/lit/ds/symlink/adc08100.pdf?ts=1774533804655 

AD9708 Datasheet: https://www.analog.com/media/en/technical-documentation/data-sheets/ad9708.pdf 


## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital and analog designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.