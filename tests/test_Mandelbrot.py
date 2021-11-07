"""contract.cairo test file."""
import os
import pytest
from starkware.starknet.testing.starknet import Starknet
import matplotlib.pyplot as plt
import numpy as np 
# The path to the contract source code.
CONTRACT_FILE = os.path.join("contracts", "mandelbrot.cairo")

PRIME = 3618502788666131213697322783095070105623107215331596699973092056135872020481
PRIME_HALF = PRIME//2

SCALE_FP = 100 #We work with 2 decimal place fixed point numbers
n=10 #Resolution of the resulting plot. The image will be n x n pixels

#Converts any real number to its corresponding floating point felt
def real_to_fp_felt(num):
    return int(num*SCALE_FP) + PRIME if num<0 else int(num*SCALE_FP)

#Converts any floating point felt to its corresponding real number
def fp_felt_to_real(num):
    return num/SCALE_FP if num<PRIME_HALF else (num-PRIME)/SCALE_FP

@pytest.mark.asyncio
async def test_Mandelbrot():
    # Create a new Starknet class that simulates the StarkNet
    # system.
    starknet = await Starknet.empty()

    # Deploy the contract.
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )


    #Test the mandelbrot generation 
    mx = 2.48/(n-1)
    my = 2.26/(n-1)     
    mapper_x = lambda x: mx*x - 2
    mapper_y = lambda y: my*y - 1.13
    img=np.full((n,n), 255)

    for x in range(n):
        print(x)
        _x = mapper_x(x)
        for y in range(n):
            _y = mapper_y(y)
            cmplx = contract.ComplexNumber(re=real_to_fp_felt(_x),im=real_to_fp_felt(_y))
            it = await contract.get_iters(cmplx).call()
            img[y][x] = 255 - it.result[0]

    print(img)

    plt.imshow(img, cmap="plasma")
    plt.axis("off")
    plt.show()














