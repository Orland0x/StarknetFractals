import sys
import numpy as np
import subprocess
import timeit 
import math
import matplotlib.pyplot as plt 
#Run nile commands as subprocesses

PRIME = 3618502788666131213697322783095070105623107215331596699973092056135872020481
PRIME_HALF = PRIME//2

SCALE_FP = 100 #We work with 2 decimal place fixed point numbers
N=5 #Resolution of the resulting plot. The image will be N x N pixels

#from tests it was found that the max batch size achievable was about 225 (ie n=15). After this point, resource limits were hit. 
POINTS_PER_BATCH = 100  

#Converts any real number to its corresponding floating point felt
def real_to_fp_felt(num):
    return int(num*SCALE_FP) + PRIME if num<0 else int(num*SCALE_FP)

#Converts any floating point felt to its corresponding real number
def fp_felt_to_real(num):
    return num/SCALE_FP if num<PRIME_HALF else (num-PRIME)/SCALE_FP

#produce single 1d array of all complex points c in the nxn set
def create_input_array(n):
    mx = 2.48/(n-1)
    my = 2.26/(n-1)
    mapper_x = lambda x: mx*x - 2
    mapper_y = lambda y: my*y - 1.13

    array = [] 
    for x in range(n):
        _x = mapper_x(x)
        for y in range(n):
            _y = mapper_y(y)
            array.append(real_to_fp_felt(_x))
            array.append(real_to_fp_felt(_y))

    return array

def generate_plot(array,n):
    array_np = np.array(array)
    array_np = 255 - np.reshape(array_np, (n,n), order='F')

    plt.imshow(array_np, cmap="plasma")
    plt.axis("off")
    plt.savefig(f'images/mandelbrot_{n}_25.png')

def subprocess_run (cmd):
    #from @guiltygyoza github
	result = subprocess.run(cmd, stdout=subprocess.PIPE)
	result = result.stdout.decode('utf-8')[:-1] # remove trailing newline
	return result

def compile(contract_name):
    cmd = f'nile compile contracts/{contract_name}.cairo'
    cmd = cmd.split(' ')
    out = subprocess_run(cmd)
    print(out)
    print(f'{contract_name} at contracts/{contract_name}.cairo compiled successfully')

def deploy(contract_name):
    cmd = f'nile deploy {contract_name} --alias {contract_name}'
    cmd = cmd.split(' ')
    out = subprocess_run(cmd)
    print(out)
    print(f'{contract_name} deployed successfully')

#Generates the plot in a single function call, only works with max about n=15. After which resource limits are hit
def generateMandelbrot(contract_name, n):
    c_array = create_input_array(n)
    c_array_length = [len(c_array)]

    input_array = c_array_length + c_array #adding length of array to beginning 
    input_str = ' '.join([str(elem) for elem in input_array]) 

    cmd = f'nile call {contract_name} get_iters_batch {input_str}'
    cmd = cmd.split(' ')
    print(cmd)
    out = subprocess_run(cmd)

    output_array = [int(elem) for elem in out.split(' ')]
    output_array = output_array[1:] #removing first element which is the length

    generate_plot(output_array, n)

    print('done')

#Batched generation which should allow much higher resolution plots to be generated 
def generateMandelbrotBatched(contract_name, n):
    c_array = create_input_array(n)
    
    #round up
    num_batches = int(math.ceil(n*n/POINTS_PER_BATCH))
    output_array = []
    start_total = timeit.default_timer()
    for b in range(num_batches):
        #Each point takes up 2 slots in c_array
        c_array_batch = c_array[2*b*POINTS_PER_BATCH:2*(b+1)*POINTS_PER_BATCH]
        c_array_batch_length = [len(c_array_batch)]
        input_array = c_array_batch_length + c_array_batch #adding length of array to beginning 
        input_str = ' '.join([str(elem) for elem in input_array]) 

        cmd = f'nile call {contract_name} get_iters_batch {input_str}'
        cmd = cmd.split(' ')
        start = timeit.default_timer()
        out = subprocess_run(cmd)
        stop = timeit.default_timer()
        print(f'Batch {b+1}/{num_batches} completed in {stop - start} seconds')

        output_array_batch = [int(elem) for elem in out.split(' ')]
        output_array_batch = output_array_batch[1:] #removing first element which is the length
        output_array = output_array + output_array_batch

    stop_total = timeit.default_timer()
    print(f'All Batches completed, taking {stop_total-start_total} seconds total')
    generate_plot(output_array, n)


if __name__=="__main__":

    compile('mandelbrot')
    deploy('mandelbrot')
    generateMandelbrotBatched('mandelbrot',40)


