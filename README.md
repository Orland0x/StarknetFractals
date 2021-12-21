# StarknetFractals
Generating the mandelbrot set on Starknet

## Environment Setup 

Install Cairo within a python environment as described in https://www.cairo-lang.org/docs/quickstart.html 






Generate the plot via running the scripts/deployment.py script. This first compiles and deploys the contract before generating the plot. Output plot will be saved in the images folder.

The generation is batched into calls to the mandelbrot.cairo contract. Each batch generates a certain number of points. From tests, 100 points per call is the rough limit before rescource limits are hit. 

Here is an example 40x40 pixel plot. It took 553 seconds total to generate. 
![alt text](https://github.com/orlandothefraser/StarknetFractals/blob/main/images/mandelbrot_40_25.png)

Math for fixed point complex numbers was required here but could be used for other things, so I made a separate cairo file ComplexMath.cairo with this stuff in. 

TODO:
Currently runs on local devnet via nile. Add mainnet support
There are additionally some optimizations that can be taken to reduce computation per pixel generation. 




This is what we are aiming for - 1000x1000 plot in as few calls as possible.
![alt text](https://github.com/orlandothefraser/StarknetFractals/blob/main/images/mandelbrot_1000_25.png)



