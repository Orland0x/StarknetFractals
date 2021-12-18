
import sys
import math 
import timeit
from HelperFunctions import subprocess_run, create_input_array_100

#from tests it was found that the max batch size achievable was about 225 (ie n=15). After this point, resource limits were hit. 
POINTS_PER_BATCH = 50  

def generateMandelbrotBatchedOnchain_100(contract_name):
    c_array = create_input_array_100()
    
    #round up
    num_batches = int(math.ceil(100*100/(2*POINTS_PER_BATCH)))
    output_array = []
    start_total = timeit.default_timer()
    for b in range(num_batches):
        #Each point takes up 2 slots in c_array
        c_array_batch = c_array[2*b*POINTS_PER_BATCH:2*(b+1)*POINTS_PER_BATCH]
        c_array_batch_length = [len(c_array_batch)] 
        batch_number = [b]
        input_array = batch_number + c_array_batch_length + c_array_batch #adding length of array to beginning 
        input_str = ' '.join([str(elem) for elem in input_array]) 
        # print('input str: ', input_str)
        cmd = f'nile invoke {contract_name} store_iters_batch_onchain {input_str}'
        cmd = cmd.split(' ')
        start = timeit.default_timer()
        subprocess_run(cmd)
        stop = timeit.default_timer()
        print(f'Batch {b+1}/{num_batches} completed in {stop - start} seconds')
        # output_array_batch = [int(elem) for elem in out.split(' ')]
        # output_array_batch = output_array_batch[1:] #removing first element which is the length
        # output_array = output_array + output_array_batch

    stop_total = timeit.default_timer()
    print(f'All Batches completed, taking {stop_total-start_total} seconds total') 


if __name__=="__main__":
    alias = sys.argv[1]
    generateMandelbrotBatchedOnchain_100(alias)