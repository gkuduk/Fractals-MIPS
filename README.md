# Fractals-MIPS
Fractals (Julia and Mandelbrot's sets) generation in MIPS assembly.

Program copies the header from the in.bmp file, which is 500x500 by default, and then calculates the chosen set using only int registers.
The colors are calculated by simple multiplicaiton based on the 'scale' (default 50 30 20).

## Examples

Julia's Set for 40 iterations, x = 0.3400 and y = 0.5000:

![](/../Screenshots/JuliaExample.bmp?raw=true)


Mandelbrot's Set for 40 iterations:

![](/../Screenshots/MandExample.bmp?raw=true)

## License
MIT
