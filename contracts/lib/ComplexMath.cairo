from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (signed_div_rem, sign)

const RANGE_CHECK_BOUND = 2 ** 64
const SCALE_FP = 100

###Library functions for dealing with fixed point complex numbers.

#TODO: add division operations 

struct ComplexNumber: 
    member re : felt
    member im : felt
end

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

    local z : ComplexNumber = ComplexNumber(re=z_re, im=z_im)
    return (z)
end

func conjugate {range_check_ptr} ( 
        x : ComplexNumber
    ) -> (
        x_bar : ComplexNumber
    ): 
    tempvar x_bar_im = -x.im
    tempvar x_bar : ComplexNumber = ComplexNumber(re=x.re, im=x_bar_im)
    return (x_bar)
end 

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
