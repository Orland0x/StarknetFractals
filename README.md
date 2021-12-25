# StarknetFractals
Generating the mandelbrot set on Starknet. Computes a 100x100 mandelbrot plot and stores necessary data to recontruct it onchain in 100 storage felts. One can then call the contract to retrieve the data and reconstruct the plot. 

## Environment Setup 

Create a python environment, activate it, and install Cairo within it as described in: https://www.cairo-lang.org/docs/quickstart.html  

Install Nile:
```bash
pip install cairo-nile
```

## Compiling and Deploying 

Compile: 
```bash
nile compile contracts/mandelbrotOnChain.cairo
``` 

Run a local starknet-devnet node:
```bash
nile node
``` 

Deploy (using an alias of your choosing):
```bash
nile deploy mandelbrotOnChain --alias mandelbrotOnChain_Instance
```  
## Generation and Retrieval 

Invoke the contract using the script supplied to generate the Mandelbrot set and store the data to produce it within the contract: 
```bash
python3.7 scripts/generateMandelbrotOnChain.py mandelbrotOnChain_Instance 
``` 

Retrieve the Mandelbrot set data from within the contract and generate the plot of it using the supplied script:
```bash
python3.7 scripts/retrieveMandelbrotOnChain.py mandelbrotOnChain_Instance 
``` 
The resulting plot is stored within the images directory. It should look like this!

![alt text](https://github.com/orlandothefraser/StarknetFractals/blob/main/images/mandelbrot_100_25.png)









