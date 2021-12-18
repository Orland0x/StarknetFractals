%lang starknet
%builtins pedersen range_check bitwise 

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.math import (signed_div_rem, sign, assert_nn)
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc




from contracts.lib.ComplexMath import (
    ComplexNumber,
    add_complex, 
    mul_complex_fp, 
    conjugate,
    get_sqrd_mag 
) 

from contracts.lib.PackFelt import ( 
    pack_50_array,
    unpack_50_array
)

const RANGE_CHECK_BOUND = 2 ** 64
const SCALE_FP = 100 #Scale for floating point number representation, here we use 2 decimal places hence we require a scale of 100
const THRESHOLD = 400 #Threshold value for the magnitude of the series that is a sufficient condition for divergence
const MAX_STEPS = 31 #Total numbe of iterations that will be taken per value of c, the higher it is the more accurate the fractal 


#OFFCHAIN: Can produce arbitrarly resolution mandelbrot plots and send results to the ouput. Call store_iters_batch_offchain for this.

#ONCHAIN: Produces a 100x100 mandelbrot plot and stores data required to generate the plot fully onchain. Do to the non-generalized felt packing, this only works for the specific case.

#As the plot is symmetric about the x axis, only the positive y quadrants need to be generated and the other half can be reconstructed. 
#This means we need to just compute 50x100=5000 points. Each pixel consists of an iteration number in the range [0,MAX_STEPS].
#Using MAX_STEPS=31, means we can encode this iteration number using 5 bits. Felts can store up to 251 bits which means that we can store
#50 points (ie an entire column) in a single felt storage slot.
#We therefore need 100 storage slots to store the entire plot. 




#mapping to store the packed mandelbrot set. Each key points to a column [1,50] and each corresponding key stores the pixel data for that column. 
@storage_var
func mandelbrotData(col : felt) -> (packedData : felt):
end 




#Computes mandelbrot iterations for complex points supplied, does not store result on chain
@view 
func store_iters_batch_offchain {range_check_ptr} (
        c_array_len : felt, 
        c_array : felt*
    ) -> (
        i_array_len : felt,
        i_array : felt*
    ):
    alloc_locals
    let num_c = c_array_len / ComplexNumber.SIZE 
    assert_nn(num_c) 

    let (local i_array : felt*) = alloc()

    let i_array_len = c_array_len / ComplexNumber.SIZE
    _compute_iters_batch(c_array_len, c_array, i_array_len, i_array)

    return (i_array_len,i_array) 
end

#Computes a given column of the mandelbrot plot and stores it on chain in a packed format
@external 
func store_iters_batch_onchain {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr} (
        col_num : felt,
        c_array_len : felt, 
        c_array : felt*
    ):
    alloc_locals 
    let i_array_len = c_array_len / ComplexNumber.SIZE 
    assert_nn(i_array_len) 

    let (local i_array : felt*) = alloc() 

    _compute_iters_batch(c_array_len, c_array, i_array_len, i_array)

    let (packed_i_array) = pack_50_array(i_array_len, i_array) 
    mandelbrotData.write(col_num, packed_i_array)
    return ()
end 

#retrieves storage felt containing packed mandelbrot data for a given column number, unpacks it and then returns the resulting values as an array. 
#Call this to recontruct the mandelbrot plot from the on chain data
@view 
func get_iters_batch_onchain {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr} (
        col_num : felt 
    ) -> (
        i_array_len : felt, 
        i_array : felt*
    ): 
    let (num) = mandelbrotData.read(col_num) 
    let (i_array_len, i_array) = unpack_50_array(num) 

    return (i_array_len, i_array)
end 







# ------- INTERNAL FUNCTIONS -------- #

#Takes an array of complex points and stores the mandelbrot iterations for each in another empty array
@view
func _compute_iters_batch {range_check_ptr} (
        c_array_len : felt, 
        c_array : felt*,
        i_array_len : felt,
        i_array : felt*
    ):

    if c_array_len == 0:
        return ()
    end

    let c = cast(c_array, ComplexNumber*)
    let (i) = get_iters([c])
    assert i_array[i_array_len - c_array_len/ComplexNumber.SIZE] = i
    _compute_iters_batch(c_array_len-ComplexNumber.SIZE, c_array+ComplexNumber.SIZE, i_array_len, i_array)

    return ()
end

#Performs the iteration of z and checks for end conditions. Iterations occur by recursive calls. 
@view 
func _get_iters {range_check_ptr} (
        c : ComplexNumber,       
        z : ComplexNumber,
        steps : felt
    ) -> (
        iters : felt
    ):
    alloc_locals  

    let (local true) = end_condition(z,steps)
    if true!=0:
        return (steps) 
    end

   let (local z_2) = mul_complex_fp(z,z)
   let (local new_z) = add_complex(z_2, c)

   let (local iters) = _get_iters(c, new_z, steps+1)

   return (iters)
end

#Wrapper function around _get_iters that sets up the initial conditions for the recursive iteration. 
@view 
func get_iters {range_check_ptr} (
        c : ComplexNumber
    ) -> (
        iters : felt
    ):
    alloc_locals
    tempvar z = ComplexNumber(0,0)
    let (local iters) = _get_iters(c, z, 0)

    return (iters)
end


#Returns 1 or 2 if the end condition is met, 0 otherwise.
#The end condition is met when either the squared magnitude of z is greater than 4 (which is a sufficient condition for divergence) or MAX_STEPS has been reached. 
@view 
func end_condition {range_check_ptr} (
        z : ComplexNumber,
        steps : felt
    ) -> (
        true : felt 
    ):
    alloc_locals

    let (local sqrd_mag_z) = get_sqrd_mag(z) 
    let (local is_gt_threshold) = is_le(THRESHOLD, sqrd_mag_z)

    local is_steps_max_steps
    if steps==MAX_STEPS:
        assert is_steps_max_steps = 1 
    else: 
        assert is_steps_max_steps = 0
    end

    tempvar true = is_steps_max_steps + is_gt_threshold

    return (true)

end

#Performs the increment of z, ie z = z^2 + c
@view 
func increment_z {range_check_ptr} (
        z : ComplexNumber,
        c : ComplexNumber
    ) -> (
        z_new : ComplexNumber
    ):
    alloc_locals 

    let (local z_2) = mul_complex_fp(z,z)
    let (local new_z) = add_complex(z_2, c)

    return (new_z)
end




