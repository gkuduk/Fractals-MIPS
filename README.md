# Fractals-MIPS
Fractals (Julia and Mandelbrot's sets) generation in MIPS assembly.

Program copies the header from the in.bmp file (default 500x500), calculates the chosen set using only int registers and saves the output to FractalRes.bmp.
The colors are calculated by simple multiplication based on the 'scale' variable (default 50 30 20).

## Examples

Julia's Set for 40 iterations, x = 0.3400 and y = 0.5000:

![](/../Screenshots/JuliaExample.bmp?raw=true)


Mandelbrot's Set for 40 iterations:

![](/../Screenshots/MandExample.bmp?raw=true)

## License
MIT
