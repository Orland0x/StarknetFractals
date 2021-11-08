%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (signed_div_rem, sign)
from starkware.cairo.common.math_cmp import is_le

const RANGE_CHECK_BOUND = 2 ** 64
const SCALE_FP = 100 #Scale for floating point number representation, here we use 2 decimal places hence we require a scale of 100
const THRESHOLD = 400 #Threshold value for the magnitude of the series that is a sufficient condition for divergence
const MAX_STEPS = 25 #Total numbe of iterations that will be taken per value of c, the higher it is the more accurate the fractal 

struct ComplexNumber: 
    member re : felt
    member im : felt
end

@view
func mul_fp {range_check_ptr} (
        a : felt,
        b : felt
    ) -> (
        c : felt
    ):
    # signed_div_rem by SCALE_FP after multiplication

    tempvar product = a * b
    let (c, _) = signed_div_rem(product, SCALE_FP, RANGE_CHECK_BOUND)

    return (c)
end

@view 
func add_complex {range_check_ptr} (
        x : ComplexNumber,
        y : ComplexNumber
    ) -> (
        z : ComplexNumber
    ):
    tempvar z_re = x.re + y.re
    tempvar z_im = x.im + y.im 
    tempvar z : ComplexNumber = ComplexNumber(re=z_re, im=z_im)
    return (z)
end


@view 
func mul_complex_fp {range_check_ptr} (
        x : ComplexNumber,
        y : ComplexNumber
    ) -> (
        z : ComplexNumber
    ):
    alloc_locals

    let (local x_re_y_re) = mul_fp(x.re, y.re) 
    let (local x_im_y_im) = mul_fp(x.im, y.im)
    let (local x_re_y_im) = mul_fp(x.re, y.im)
    let (local x_im_y_re) = mul_fp(x.im, y.re)

    tempvar z_re = x_re_y_re - x_im_y_im 
    tempvar z_im = x_re_y_im + x_im_y_re 

    tempvar z : ComplexNumber = ComplexNumber(re=z_re, im=z_im)
    return (z)
end

@view 
func conjugate {range_check_ptr} ( 
        x : ComplexNumber
    ) -> (
        x_bar : ComplexNumber
    ): 
    tempvar x_bar_im = -x.im
    tempvar x_bar : ComplexNumber = ComplexNumber(re=x.re, im=x_bar_im)
    return (x_bar)
end 

@view 
func get_sqrd_mag {range_check_ptr} (
        x : ComplexNumber
    ) -> (
        mag : felt 
    ):
    alloc_locals 
    let (local re_2) = mul_fp(x.re,x.re)
    let (local im_2) = mul_fp(x.im,x.im)
    tempvar sqrd_mag = re_2 + im_2
    
    return (sqrd_mag)
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

#Core function that performs the iteration of z and checks for end conditions. Iterations occur by recursive calls. 
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

#Wrapper function around _get_iters so that the interface is simple to use
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








