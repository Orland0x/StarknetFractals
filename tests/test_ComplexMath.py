"""contract.cairo test file."""
import os
import pytest
from starkware.starknet.testing.starknet import Starknet

# The path to the contract source code.
CONTRACT_FILE = os.path.join("contracts", "ComplexMath.cairo")

PRIME = 3618502788666131213697322783095070105623107215331596699973092056135872020481
PRIME_HALF = PRIME//2
SCALE_FP = 100 #using 2 decimal place fixed point numbers here

#Converts any real number to its corresponding floating point felt
def real_to_fp_felt(num):
    return int(num*SCALE_FP) + PRIME if num<0 else int(num*SCALE_FP)

#Converts any floating point felt to its corresponding real number
def fp_felt_to_real(num):
    return num/SCALE_FP if num<PRIME_HALF else (num-PRIME)/SCALE_FP


@pytest.mark.asyncio
async def test_ComplexMath():
    # Create a new Starknet class that simulates the StarkNet
    # system.
    starknet = await Starknet.empty()

    # Deploy the contract.
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    #Floating Point multiplication test
    out = await contract.mul_fp(71,73).call()
    #print(out.result[0])
     
    #Generating some ComplexNumber structs
    cmplx1 = contract.ComplexNumber(re=700,im=300)
    cmplx2 = contract.ComplexNumber(re=300,im=400)


    #Complex Addition Test
    out = await contract.add_complex(cmplx1, cmplx2).call() 
    assert out.result[0] == contract.ComplexNumber(re=1000,im=700)

    #Complex Floating Point multipication test
    out = await contract.mul_complex_fp(cmplx1,cmplx2).call()
    print(out.result[0])

    #Compound multipication test
    cmplx3 = out.result[0]
    out = await contract.mul_complex_fp(cmplx3,cmplx2).call()
    print(out.result[0])

    #Complex Conjugate Test
    c = await contract.conjugate(cmplx1).call()  
    cmplx1Conj = c.result[0] #Is there a better way to extract ouptut? This seems messy
    print(cmplx1Conj)

    c = await contract.mul_complex_fp(cmplx1, cmplx1Conj).call()
    magSqrd = c.result[0]

    #Because (x+yi)(x-yi) = x^2 + y^2 + 0i
    assert magSqrd == contract.ComplexNumber(re=cmplx1.re**2/SCALE_FP+cmplx1.im**2/SCALE_FP,im=0)

    


