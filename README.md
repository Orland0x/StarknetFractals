# StarknetFractals
Generating the mandelbrot set on Starknet. 

Current Implementation generates 1 pixel of the fractal per call(). It takes a few minutes to generate a 10x10 plot (100 pixels) like shown. 

![alt text](https://github.com/orlandothefraser/StarknetFractals/blob/main/images/mandelbrot_10_25.png)

Math for fixed point complex numbers was required here but could be used for other things, so I made a separate cairo file will this stuff in. 

TODO: To increase resolution without the render taking days, the pixel generation should be batched into fewer calls. The gas limit will limit the maximum batch size. There are additionally some optimizations that can be taken to reduce computation per pixel generation. 



This is what we are aiming for - 1000x1000 plot 
![alt text](https://github.com/orlandothefraser/StarknetFractals/blob/main/images/mandelbrot_1000_25.png)



