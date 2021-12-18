
import sys
import math
from HelperFunctions import subprocess_run, generate_plot_100
#from tests it was found that the max batch size achievable was about 225 (ie n=15). After this point, resource limits were hit. 
POINTS_PER_BATCH = 50  

def retrieveMandelbrotBatchedOnchain_100(contract_name): 
    
    num_batches = int(math.ceil(100*100/(2*POINTS_PER_BATCH)))
    output_array = []
    input_array = [0]
    for b in range(num_batches):
        input_str = str(b)
        cmd = f'nile call {contract_name} get_iters_batch_onchain {input_str}'
        cmd = cmd.split(' ')
        out = subprocess_run(cmd)  
        
        output_array_batch = [int(elem) for elem in out.split(' ')]
        output_array_batch = output_array_batch[1:] #removing first element which is the length
        output_array = output_array + output_array_batch

        print(f'Batch {b+1}/{num_batches} retrieved')

    print('All batches retrieved')
    generate_plot_100(output_array) 

if __name__=="__main__":
    alias = sys.argv[1]
    retrieveMandelbrotBatchedOnchain_100(alias)

