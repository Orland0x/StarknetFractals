from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import ( unsigned_div_rem, assert_nn_le)
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.alloc import alloc

const DIV_25 = 2**25
const DIV_50 = 2**50
const DIV_100 = 2**100

#Constants for 2 packing
const MAX_2 = 2**125 #the largest number that can be packed (can be set larger than this)
const SHIFT_2_1 = 2**125
const MASK_2_0 = 2**125 - 1 
const MASK_2_1 = 2**250 - 2**125 

#Constants for 5 packing 
const MAX_5 = 2**50 
const SHIFT_5_1 = 2**50 
const SHIFT_5_2 = 2**100 
const SHIFT_5_3 = 2**150 
const SHIFT_5_4 = 2**200 
const MASK_5_0 = 2**50 - 1 
const MASK_5_1 = 2**100 - 2**50 
const MASK_5_2 = 2**150 - 2**100 
const MASK_5_3 = 2**200 - 2**150
const MASK_5_4 = 2**250 - 2**200 

#Constants for 50 packing 

const MAX_50 = 2**5 
const SHIFT_50_1 = 2**5
const SHIFT_50_2 = 2**10
const SHIFT_50_3 = 2**15
const SHIFT_50_4 = 2**20
const SHIFT_50_5 = 2**25
const SHIFT_50_6 = 2**30
const SHIFT_50_7 = 2**35
const SHIFT_50_8 = 2**40
const SHIFT_50_9 = 2**45
const SHIFT_50_10 = 2**50
const SHIFT_50_11 = 2**55
const SHIFT_50_12 = 2**60
const SHIFT_50_13 = 2**65
const SHIFT_50_14 = 2**70
const SHIFT_50_15 = 2**75
const SHIFT_50_16 = 2**80
const SHIFT_50_17 = 2**85
const SHIFT_50_18 = 2**90
const SHIFT_50_19 = 2**95
const SHIFT_50_20 = 2**100
const SHIFT_50_21 = 2**105
const SHIFT_50_22 = 2**110
const SHIFT_50_23 = 2**115
const SHIFT_50_24 = 2**120
const SHIFT_50_25 = 2**125
const SHIFT_50_26 = 2**130
const SHIFT_50_27 = 2**135
const SHIFT_50_28 = 2**140
const SHIFT_50_29 = 2**145
const SHIFT_50_30 = 2**150
const SHIFT_50_31 = 2**155
const SHIFT_50_32 = 2**160
const SHIFT_50_33 = 2**165
const SHIFT_50_34 = 2**170
const SHIFT_50_35 = 2**175
const SHIFT_50_36 = 2**180
const SHIFT_50_37 = 2**185
const SHIFT_50_38 = 2**190
const SHIFT_50_39 = 2**195
const SHIFT_50_40 = 2**200
const SHIFT_50_41 = 2**205
const SHIFT_50_42 = 2**210
const SHIFT_50_43 = 2**215
const SHIFT_50_44 = 2**220
const SHIFT_50_45 = 2**225
const SHIFT_50_46 = 2**230
const SHIFT_50_47 = 2**235
const SHIFT_50_48 = 2**240
const SHIFT_50_49 = 2**245
const MASK_50_0 = 2**5 - 1
const MASK_50_1 = 2**10 - 2**5
const MASK_50_2 = 2**15 - 2**10
const MASK_50_3 = 2**20 - 2**15
const MASK_50_4 = 2**25 - 2**20
const MASK_50_5 = 2**30 - 2**25
const MASK_50_6 = 2**35 - 2**30
const MASK_50_7 = 2**40 - 2**35
const MASK_50_8 = 2**45 - 2**40
const MASK_50_9 = 2**50 - 2**45
const MASK_50_10 = 2**55 - 2**50
const MASK_50_11 = 2**60 - 2**55
const MASK_50_12 = 2**65 - 2**60
const MASK_50_13 = 2**70 - 2**65
const MASK_50_14 = 2**75 - 2**70
const MASK_50_15 = 2**80 - 2**75
const MASK_50_16 = 2**85 - 2**80
const MASK_50_17 = 2**90 - 2**85
const MASK_50_18 = 2**95 - 2**90
const MASK_50_19 = 2**100 - 2**95
const MASK_50_20 = 2**105 - 2**100
const MASK_50_21 = 2**110 - 2**105
const MASK_50_22 = 2**115 - 2**110
const MASK_50_23 = 2**120 - 2**115
const MASK_50_24 = 2**125 - 2**120
const MASK_50_25 = 2**130 - 2**125
const MASK_50_26 = 2**135 - 2**130
const MASK_50_27 = 2**140 - 2**135
const MASK_50_28 = 2**145 - 2**140
const MASK_50_29 = 2**150 - 2**145
const MASK_50_30 = 2**155 - 2**150
const MASK_50_31 = 2**160 - 2**155
const MASK_50_32 = 2**165 - 2**160
const MASK_50_33 = 2**170 - 2**165
const MASK_50_34 = 2**175 - 2**170
const MASK_50_35 = 2**180 - 2**175
const MASK_50_36 = 2**185 - 2**180
const MASK_50_37 = 2**190 - 2**185
const MASK_50_38 = 2**195 - 2**190
const MASK_50_39 = 2**200 - 2**195
const MASK_50_40 = 2**205 - 2**200
const MASK_50_41 = 2**210 - 2**205
const MASK_50_42 = 2**215 - 2**210
const MASK_50_43 = 2**220 - 2**215
const MASK_50_44 = 2**225 - 2**220
const MASK_50_45 = 2**230 - 2**225
const MASK_50_46 = 2**235 - 2**230
const MASK_50_47 = 2**240 - 2**235
const MASK_50_48 = 2**245 - 2**240
const MASK_50_49 = 2**250 - 2**245

func pack_2 {range_check_ptr} (
        num0 : felt, 
        num1 : felt 
    ) -> (
        num : felt
    ):
    #Checking that the numbers are within the valid range
    assert_nn_le(num0, MAX_2)
    assert_nn_le(num1, MAX_2)

    #Shifting via multiplication
    tempvar t1 = num1*SHIFT_2_1
    tempvar num = t1 + num0
    #packedData.write(t1 + num0)
    return (num)
end

func unpack_2 {bitwise_ptr : BitwiseBuiltin*, range_check_ptr} (
        num : felt
    ) -> (
        num0 : felt,
        num1 : felt
    ):
    #Masking out each number 
    let (num0) = bitwise_and(num, MASK_2_0)
    let (t1) = bitwise_and(num, MASK_2_1)

    #Shifting via division
    let (t1, _) = unsigned_div_rem(t1, DIV_100)
    let (num1, _) = unsigned_div_rem(t1, DIV_25)
     
    return (num0, num1)
end 

func pack_2_array {range_check_ptr} (
        num_array_len : felt, 
        num_array : felt* 
    ) -> (
        num : felt 
    ):
    assert_nn_le(num_array[0], MAX_2)
    assert_nn_le(num_array[1], MAX_2)

    tempvar t1 = num_array[1]*SHIFT_2_1
 
    tempvar num = t1 + num_array[0]
    return (num)
end 

func unpack_2_array {bitwise_ptr : BitwiseBuiltin*, range_check_ptr} (
        num : felt 
    ) -> (
        num_array_len : felt, 
        num_array : felt* 
    ): 
    alloc_locals
    let (local num_array : felt*) = alloc()

    #Masking out each number 
    let (num0) = bitwise_and(num, MASK_2_0)
    let (t1) = bitwise_and(num, MASK_2_1)
 

    #Shifting via division
    let (t1, _) = unsigned_div_rem(t1, DIV_100)
    let (num1, _) = unsigned_div_rem(t1, DIV_25) 

    assert num_array[0] = num0 
    assert num_array[1] = num1

    return (2, num_array)
end 

func pack_5 {range_check_ptr} (
        num0 : felt, 
        num1 : felt,
        num2 : felt,
        num3 : felt,
        num4 : felt 
    ) -> (
        num : felt 
    ):
    #Checking that the numbers are within the valid range 
    assert_nn_le(num0, MAX_5)
    assert_nn_le(num1, MAX_5)
    assert_nn_le(num2, MAX_5)
    assert_nn_le(num3, MAX_5)
    assert_nn_le(num4, MAX_5)

    #Shifting via multiplication
    tempvar t1 = num1*SHIFT_5_1
    tempvar t2 = num2*SHIFT_5_2
    tempvar t3 = num3*SHIFT_5_3
    tempvar t4 = num4*SHIFT_5_4 
    
    tempvar num = t4 + t3 + t2 + t1 + num0
    return (num)
end

func unpack_5 {bitwise_ptr : BitwiseBuiltin*, range_check_ptr} (
        num : felt 
    ) -> (
        num0 : felt,
        num1 : felt,
        num2 : felt,
        num3 : felt, 
        num4 : felt 
    ):
    #Masking out each number 
    let (num0) = bitwise_and(num, MASK_5_0)
    let (t1) = bitwise_and(num, MASK_5_1)
    let (t2) = bitwise_and(num, MASK_5_2)
    let (t3) = bitwise_and(num, MASK_5_3)
    let (t4) = bitwise_and(num, MASK_5_4)

    #Shifting via division 
    let (num1, _) = unsigned_div_rem(t1, DIV_50)
    let (num2, _) = unsigned_div_rem(t2, DIV_100)
    let (t3, _) = unsigned_div_rem(t3, DIV_100)
    let (num3, _) = unsigned_div_rem(t3, DIV_50)
    let (t4, _) = unsigned_div_rem(t4, DIV_100)
    let (num4, _) = unsigned_div_rem(t4, DIV_100)

    return (num0, num1, num2, num3, num4)
end 

func pack_5_array {range_check_ptr} (
        num_array_len : felt, 
        num_array : felt* 
    ) -> (
        num : felt 
    ):
    assert_nn_le(num_array[0], MAX_5)
    assert_nn_le(num_array[1], MAX_5)
    assert_nn_le(num_array[2], MAX_5)
    assert_nn_le(num_array[3], MAX_5)
    assert_nn_le(num_array[4], MAX_5)

    tempvar t1 = num_array[1]*SHIFT_5_1
    tempvar t2 = num_array[2]*SHIFT_5_2
    tempvar t3 = num_array[3]*SHIFT_5_3
    tempvar t4 = num_array[4]*SHIFT_5_4    

    tempvar num = t4 + t3 + t2 + t1 + num_array[0]
    return (num)
end 

func unpack_5_array {bitwise_ptr : BitwiseBuiltin*, range_check_ptr} (
        num : felt 
    ) -> (
        num_array_len : felt, 
        num_array : felt* 
    ): 
    alloc_locals
    let (local num_array : felt*) = alloc()

    #Masking out each number 
    let (num0) = bitwise_and(num, MASK_5_0)
    let (t1) = bitwise_and(num, MASK_5_1)
    let (t2) = bitwise_and(num, MASK_5_2)
    let (t3) = bitwise_and(num, MASK_5_3)
    let (t4) = bitwise_and(num, MASK_5_4) 

    #Shifting via division 
    let (num1, _) = unsigned_div_rem(t1, DIV_50)
    let (num2, _) = unsigned_div_rem(t2, DIV_100)
    let (t3, _) = unsigned_div_rem(t3, DIV_100)
    let (num3, _) = unsigned_div_rem(t3, DIV_50)
    let (t4, _) = unsigned_div_rem(t4, DIV_100)
    let (num4, _) = unsigned_div_rem(t4, DIV_100) 

    assert num_array[0] = num0 
    assert num_array[1] = num1
    assert num_array[2] = num2
    assert num_array[3] = num3
    assert num_array[4] = num4

    return (5, num_array)
end 

func pack_50 {range_check_ptr} (
        num0 : felt, 
        num1 : felt,
        num2 : felt,
        num3 : felt,
        num4 : felt, 
        num5 : felt, 
        num6 : felt,
        num7 : felt,
        num8 : felt,
        num9 : felt,
        num10 : felt, 
        num11 : felt,
        num12 : felt,
        num13 : felt,
        num14 : felt, 
        num15 : felt, 
        num16 : felt,
        num17 : felt,
        num18 : felt,
        num19 : felt,
        num20 : felt, 
        num21 : felt,
        num22 : felt,
        num23 : felt,
        num24 : felt, 
        num25 : felt, 
        num26 : felt,
        num27 : felt,
        num28 : felt,
        num29 : felt,
        num30 : felt, 
        num31 : felt,
        num32 : felt,
        num33 : felt,
        num34 : felt, 
        num35 : felt, 
        num36 : felt,
        num37 : felt,
        num38 : felt,
        num39 : felt,
        num40 : felt, 
        num41 : felt,
        num42 : felt,
        num43 : felt,
        num44 : felt, 
        num45 : felt, 
        num46 : felt,
        num47 : felt,
        num48 : felt,
        num49 : felt,
    ) -> (
        num : felt 
    ):
    #Checking that the numbers are within the valid range 
    assert_nn_le(num0, MAX_50)
    assert_nn_le(num1, MAX_50)
    assert_nn_le(num2, MAX_50)
    assert_nn_le(num3, MAX_50)
    assert_nn_le(num4, MAX_50)
    assert_nn_le(num5, MAX_50)
    assert_nn_le(num6, MAX_50)
    assert_nn_le(num7, MAX_50)
    assert_nn_le(num8, MAX_50)
    assert_nn_le(num9, MAX_50)
    assert_nn_le(num10, MAX_50)
    assert_nn_le(num11, MAX_50)
    assert_nn_le(num12, MAX_50)
    assert_nn_le(num13, MAX_50)
    assert_nn_le(num14, MAX_50)
    assert_nn_le(num15, MAX_50)
    assert_nn_le(num16, MAX_50)
    assert_nn_le(num17, MAX_50)
    assert_nn_le(num18, MAX_50)
    assert_nn_le(num19, MAX_50)
    assert_nn_le(num20, MAX_50)
    assert_nn_le(num21, MAX_50)
    assert_nn_le(num22, MAX_50)
    assert_nn_le(num23, MAX_50)
    assert_nn_le(num24, MAX_50)
    assert_nn_le(num25, MAX_50)
    assert_nn_le(num26, MAX_50)
    assert_nn_le(num27, MAX_50)
    assert_nn_le(num28, MAX_50)
    assert_nn_le(num29, MAX_50)
    assert_nn_le(num30, MAX_50)
    assert_nn_le(num31, MAX_50)
    assert_nn_le(num32, MAX_50)
    assert_nn_le(num33, MAX_50)
    assert_nn_le(num34, MAX_50)
    assert_nn_le(num35, MAX_50)
    assert_nn_le(num36, MAX_50)
    assert_nn_le(num37, MAX_50)
    assert_nn_le(num38, MAX_50)
    assert_nn_le(num39, MAX_50)
    assert_nn_le(num40, MAX_50)
    assert_nn_le(num41, MAX_50)
    assert_nn_le(num42, MAX_50)
    assert_nn_le(num43, MAX_50)
    assert_nn_le(num44, MAX_50)
    assert_nn_le(num45, MAX_50)
    assert_nn_le(num46, MAX_50)
    assert_nn_le(num47, MAX_50)
    assert_nn_le(num48, MAX_50)
    assert_nn_le(num49, MAX_50)

    #Shifting via multiplication
    tempvar t1 = num1*SHIFT_50_1
    tempvar t2 = num2*SHIFT_50_2
    tempvar t3 = num3*SHIFT_50_3
    tempvar t4 = num4*SHIFT_50_4 
    tempvar t5 = num5*SHIFT_50_5
    tempvar t6 = num6*SHIFT_50_6
    tempvar t7 = num7*SHIFT_50_7
    tempvar t8 = num8*SHIFT_50_8
    tempvar t9 = num9*SHIFT_50_9
    tempvar t10 = num10*SHIFT_50_10
    tempvar t11 = num11*SHIFT_50_11
    tempvar t12 = num12*SHIFT_50_12
    tempvar t13 = num13*SHIFT_50_13
    tempvar t14 = num14*SHIFT_50_14 
    tempvar t15 = num15*SHIFT_50_15
    tempvar t16 = num16*SHIFT_50_16
    tempvar t17 = num17*SHIFT_50_17
    tempvar t18 = num18*SHIFT_50_18
    tempvar t19 = num19*SHIFT_50_19
    tempvar t20 = num20*SHIFT_50_20
    tempvar t21 = num21*SHIFT_50_21
    tempvar t22 = num22*SHIFT_50_22
    tempvar t23 = num23*SHIFT_50_23
    tempvar t24 = num24*SHIFT_50_24 
    tempvar t25 = num25*SHIFT_50_25
    tempvar t26 = num26*SHIFT_50_26
    tempvar t27 = num27*SHIFT_50_27
    tempvar t28 = num28*SHIFT_50_28
    tempvar t29 = num29*SHIFT_50_29
    tempvar t30 = num30*SHIFT_50_30
    tempvar t31 = num31*SHIFT_50_31
    tempvar t32 = num32*SHIFT_50_32
    tempvar t33 = num33*SHIFT_50_33
    tempvar t34 = num34*SHIFT_50_34 
    tempvar t35 = num35*SHIFT_50_35
    tempvar t36 = num36*SHIFT_50_36
    tempvar t37 = num37*SHIFT_50_37
    tempvar t38 = num38*SHIFT_50_38
    tempvar t39 = num39*SHIFT_50_39
    tempvar t40 = num40*SHIFT_50_40
    tempvar t41 = num41*SHIFT_50_41
    tempvar t42 = num42*SHIFT_50_42
    tempvar t43 = num43*SHIFT_50_43
    tempvar t44 = num44*SHIFT_50_44 
    tempvar t45 = num45*SHIFT_50_45
    tempvar t46 = num46*SHIFT_50_46
    tempvar t47 = num47*SHIFT_50_47
    tempvar t48 = num48*SHIFT_50_48
    tempvar t49 = num49*SHIFT_50_49

    tempvar num = t49 + t48 + t47 + t46 + t45 + t44 + t43 + t42 + t41 + 
                t40 + t39 + t38 + t37 + t36 + t35 + t34 + t33 + t32 + t31 + 
                t30 + t29 + t28 + t27 + t26 + t25 + t24 + t23 + t22 + t21 + 
                t20 + t19 + t18 + t17 + t16 + t15 + t14 + t13 + t12 + t11 + 
                t10 + t9  + t8  + t7  + t6  + t5  + t4  + t3  + t2  + t1  + num0
    return(num)
end 

func unpack_50 {bitwise_ptr : BitwiseBuiltin*, range_check_ptr} (
        num : felt 
    ) -> (
        num0 : felt, 
        num1 : felt,
        num2 : felt,
        num3 : felt,
        num4 : felt, 
        num5 : felt, 
        num6 : felt,
        num7 : felt,
        num8 : felt,
        num9 : felt,
        num10 : felt, 
        num11 : felt,
        num12 : felt,
        num13 : felt,
        num14 : felt, 
        num15 : felt, 
        num16 : felt,
        num17 : felt,
        num18 : felt,
        num19 : felt,
        num20 : felt, 
        num21 : felt,
        num22 : felt,
        num23 : felt,
        num24 : felt, 
        num25 : felt, 
        num26 : felt,
        num27 : felt,
        num28 : felt,
        num29 : felt,
        num30 : felt, 
        num31 : felt,
        num32 : felt,
        num33 : felt,
        num34 : felt, 
        num35 : felt, 
        num36 : felt,
        num37 : felt,
        num38 : felt,
        num39 : felt,
        num40 : felt, 
        num41 : felt,
        num42 : felt,
        num43 : felt,
        num44 : felt, 
        num45 : felt, 
        num46 : felt,
        num47 : felt,
        num48 : felt,
        num49 : felt,
    ):
    #Masking out each number 
    let (num0) = bitwise_and(num, MASK_50_0)
    let (t1) = bitwise_and(num, MASK_50_1)
    let (t2) = bitwise_and(num, MASK_50_2)
    let (t3) = bitwise_and(num, MASK_50_3)
    let (t4) = bitwise_and(num, MASK_50_4)
    let (t5) = bitwise_and(num, MASK_50_5)
    let (t6) = bitwise_and(num, MASK_50_6)
    let (t7) = bitwise_and(num, MASK_50_7)
    let (t8) = bitwise_and(num, MASK_50_8)
    let (t9) = bitwise_and(num, MASK_50_9)
    let (t10) = bitwise_and(num, MASK_50_10)
    let (t11) = bitwise_and(num, MASK_50_11)
    let (t12) = bitwise_and(num, MASK_50_12)
    let (t13) = bitwise_and(num, MASK_50_13)
    let (t14) = bitwise_and(num, MASK_50_14)
    let (t15) = bitwise_and(num, MASK_50_15)
    let (t16) = bitwise_and(num, MASK_50_16)
    let (t17) = bitwise_and(num, MASK_50_17)
    let (t18) = bitwise_and(num, MASK_50_18)
    let (t19) = bitwise_and(num, MASK_50_19)
    let (t20) = bitwise_and(num, MASK_50_20)
    let (t21) = bitwise_and(num, MASK_50_21)
    let (t22) = bitwise_and(num, MASK_50_22)
    let (t23) = bitwise_and(num, MASK_50_23)
    let (t24) = bitwise_and(num, MASK_50_24)
    let (t25) = bitwise_and(num, MASK_50_25)
    let (t26) = bitwise_and(num, MASK_50_26)
    let (t27) = bitwise_and(num, MASK_50_27)
    let (t28) = bitwise_and(num, MASK_50_28)
    let (t29) = bitwise_and(num, MASK_50_29)
    let (t30) = bitwise_and(num, MASK_50_30)
    let (t31) = bitwise_and(num, MASK_50_31)
    let (t32) = bitwise_and(num, MASK_50_32)
    let (t33) = bitwise_and(num, MASK_50_33)
    let (t34) = bitwise_and(num, MASK_50_34)
    let (t35) = bitwise_and(num, MASK_50_35)
    let (t36) = bitwise_and(num, MASK_50_36)
    let (t37) = bitwise_and(num, MASK_50_37)
    let (t38) = bitwise_and(num, MASK_50_38)
    let (t39) = bitwise_and(num, MASK_50_39)
    let (t40) = bitwise_and(num, MASK_50_40)
    let (t41) = bitwise_and(num, MASK_50_41)
    let (t42) = bitwise_and(num, MASK_50_42)
    let (t43) = bitwise_and(num, MASK_50_43)
    let (t44) = bitwise_and(num, MASK_50_44)
    let (t45) = bitwise_and(num, MASK_50_45)
    let (t46) = bitwise_and(num, MASK_50_46)
    let (t47) = bitwise_and(num, MASK_50_47)
    let (t48) = bitwise_and(num, MASK_50_48)
    let (t49) = bitwise_and(num, MASK_50_49)


    #Shifting via division 
    let (num1, _) = unsigned_div_rem(t1, SHIFT_50_1)
    let (num2, _) = unsigned_div_rem(t2, SHIFT_50_2)
    let (num3, _) = unsigned_div_rem(t3, SHIFT_50_3)
    let (num4, _) = unsigned_div_rem(t4, SHIFT_50_4)
    let (num5, _) = unsigned_div_rem(t5, SHIFT_50_5)
    let (num6, _) = unsigned_div_rem(t6, SHIFT_50_6)
    let (num7, _) = unsigned_div_rem(t7, SHIFT_50_7)
    let (num8, _) = unsigned_div_rem(t8, SHIFT_50_8)
    let (num9, _) = unsigned_div_rem(t9, SHIFT_50_9)
    let (num10, _) = unsigned_div_rem(t10, SHIFT_50_10)
    let (num11, _) = unsigned_div_rem(t11, SHIFT_50_11)
    let (num12, _) = unsigned_div_rem(t12, SHIFT_50_12)
    let (num13, _) = unsigned_div_rem(t13, SHIFT_50_13)
    let (num14, _) = unsigned_div_rem(t14, SHIFT_50_14)
    let (num15, _) = unsigned_div_rem(t15, SHIFT_50_15)
    let (num16, _) = unsigned_div_rem(t16, SHIFT_50_16)
    let (num17, _) = unsigned_div_rem(t17, SHIFT_50_17)
    let (num18, _) = unsigned_div_rem(t18, SHIFT_50_18)
    let (num19, _) = unsigned_div_rem(t19, SHIFT_50_19)
    let (num20, _) = unsigned_div_rem(t20, SHIFT_50_20)
    let (num21, _) = unsigned_div_rem(t21, SHIFT_50_21)
    let (num22, _) = unsigned_div_rem(t22, SHIFT_50_22)
    let (num23, _) = unsigned_div_rem(t23, SHIFT_50_23)
    let (num24, _) = unsigned_div_rem(t24, SHIFT_50_24)

    let (t25, _) = unsigned_div_rem(t25, SHIFT_50_24)
    let (num25, _) = unsigned_div_rem(t25, SHIFT_50_1)
    let (t26, _) = unsigned_div_rem(t26, SHIFT_50_24)
    let (num26, _) = unsigned_div_rem(t26, SHIFT_50_2)
    let (t27, _) = unsigned_div_rem(t27, SHIFT_50_24)
    let (num27, _) = unsigned_div_rem(t27, SHIFT_50_3)
    let (t28, _) = unsigned_div_rem(t28, SHIFT_50_24)
    let (num28, _) = unsigned_div_rem(t28, SHIFT_50_4)
    let (t29, _) = unsigned_div_rem(t29, SHIFT_50_24)
    let (num29, _) = unsigned_div_rem(t29, SHIFT_50_5)
    let (t30, _) = unsigned_div_rem(t30, SHIFT_50_24)
    let (num30, _) = unsigned_div_rem(t30, SHIFT_50_6)
    let (t31, _) = unsigned_div_rem(t31, SHIFT_50_24)
    let (num31, _) = unsigned_div_rem(t31, SHIFT_50_7)
    let (t32, _) = unsigned_div_rem(t32, SHIFT_50_24)
    let (num32, _) = unsigned_div_rem(t32, SHIFT_50_8)
    let (t33, _) = unsigned_div_rem(t33, SHIFT_50_24)
    let (num33, _) = unsigned_div_rem(t33, SHIFT_50_9)
    let (t34, _) = unsigned_div_rem(t34, SHIFT_50_24)
    let (num34, _) = unsigned_div_rem(t34, SHIFT_50_10)
    let (t35, _) = unsigned_div_rem(t35, SHIFT_50_24)
    let (num35, _) = unsigned_div_rem(t35, SHIFT_50_11)
    let (t36, _) = unsigned_div_rem(t36, SHIFT_50_24)
    let (num36, _) = unsigned_div_rem(t36, SHIFT_50_12)
    let (t37, _) = unsigned_div_rem(t37, SHIFT_50_24)
    let (num37, _) = unsigned_div_rem(t37, SHIFT_50_13)
    let (t38, _) = unsigned_div_rem(t38, SHIFT_50_24)
    let (num38, _) = unsigned_div_rem(t38, SHIFT_50_14)
    let (t39, _) = unsigned_div_rem(t39, SHIFT_50_24)
    let (num39, _) = unsigned_div_rem(t39, SHIFT_50_15)
    let (t40, _) = unsigned_div_rem(t40, SHIFT_50_24)
    let (num40, _) = unsigned_div_rem(t40, SHIFT_50_16)
    let (t41, _) = unsigned_div_rem(t41, SHIFT_50_24)
    let (num41, _) = unsigned_div_rem(t41, SHIFT_50_17)
    let (t42, _) = unsigned_div_rem(t42, SHIFT_50_24)
    let (num42, _) = unsigned_div_rem(t42, SHIFT_50_18)
    let (t43, _) = unsigned_div_rem(t43, SHIFT_50_24)
    let (num43, _) = unsigned_div_rem(t43, SHIFT_50_19)
    let (t44, _) = unsigned_div_rem(t44, SHIFT_50_24)
    let (num44, _) = unsigned_div_rem(t44, SHIFT_50_20)
    let (t45, _) = unsigned_div_rem(t45, SHIFT_50_24)
    let (num45, _) = unsigned_div_rem(t45, SHIFT_50_21)
    let (t46, _) = unsigned_div_rem(t46, SHIFT_50_24)
    let (num46, _) = unsigned_div_rem(t46, SHIFT_50_22)
    let (t47, _) = unsigned_div_rem(t47, SHIFT_50_24)
    let (num47, _) = unsigned_div_rem(t47, SHIFT_50_23)
    let (t48, _) = unsigned_div_rem(t48, SHIFT_50_24)
    let (num48, _) = unsigned_div_rem(t48, SHIFT_50_24)

    #last value hits the size limits so required a more specific divisor to make it work 
    let (t49, _) = unsigned_div_rem(t49, 2**122)
    let (t49, _) = unsigned_div_rem(t49, 2**122)
    let (num49, _) = unsigned_div_rem(t49, 2)

    return (num0, num1, num2, num3, num4, num5, num6, num7, num8, num9,
            num10, num11, num12, num13, num14, num15, num16, num17, num18, num19,
            num20, num21, num22, num23, num24, num25, num26, num27, num28, num29,
            num30, num31, num32, num33, num34, num35, num36, num37, num38, num39,
            num40, num41, num42, num43, num44, num45, num46, num47, num48, num49,
    )
end 

func pack_50_array {range_check_ptr} (
        num_array_len : felt, 
        num_array : felt* 
    ) -> (
        num : felt 
    ):
    #Checking that the numbers are within the valid range 
    assert_nn_le(num_array[0], MAX_50)
    assert_nn_le(num_array[1], MAX_50)
    assert_nn_le(num_array[2], MAX_50)
    assert_nn_le(num_array[3], MAX_50)
    assert_nn_le(num_array[4], MAX_50)
    assert_nn_le(num_array[5], MAX_50)
    assert_nn_le(num_array[6], MAX_50)
    assert_nn_le(num_array[7], MAX_50)
    assert_nn_le(num_array[8], MAX_50)
    assert_nn_le(num_array[9], MAX_50)
    assert_nn_le(num_array[10], MAX_50)
    assert_nn_le(num_array[11], MAX_50)
    assert_nn_le(num_array[12], MAX_50)
    assert_nn_le(num_array[13], MAX_50)
    assert_nn_le(num_array[14], MAX_50)
    assert_nn_le(num_array[15], MAX_50)
    assert_nn_le(num_array[16], MAX_50)
    assert_nn_le(num_array[17], MAX_50)
    assert_nn_le(num_array[18], MAX_50)
    assert_nn_le(num_array[19], MAX_50)
    assert_nn_le(num_array[20], MAX_50)
    assert_nn_le(num_array[21], MAX_50)
    assert_nn_le(num_array[22], MAX_50)
    assert_nn_le(num_array[23], MAX_50)
    assert_nn_le(num_array[24], MAX_50)
    assert_nn_le(num_array[25], MAX_50)
    assert_nn_le(num_array[26], MAX_50)
    assert_nn_le(num_array[27], MAX_50)
    assert_nn_le(num_array[28], MAX_50)
    assert_nn_le(num_array[29], MAX_50)
    assert_nn_le(num_array[30], MAX_50)
    assert_nn_le(num_array[31], MAX_50)
    assert_nn_le(num_array[32], MAX_50)
    assert_nn_le(num_array[33], MAX_50)
    assert_nn_le(num_array[34], MAX_50)
    assert_nn_le(num_array[35], MAX_50)
    assert_nn_le(num_array[36], MAX_50)
    assert_nn_le(num_array[37], MAX_50)
    assert_nn_le(num_array[38], MAX_50)
    assert_nn_le(num_array[39], MAX_50)
    assert_nn_le(num_array[40], MAX_50)
    assert_nn_le(num_array[41], MAX_50)
    assert_nn_le(num_array[42], MAX_50)
    assert_nn_le(num_array[43], MAX_50)
    assert_nn_le(num_array[44], MAX_50)
    assert_nn_le(num_array[45], MAX_50)
    assert_nn_le(num_array[46], MAX_50)
    assert_nn_le(num_array[47], MAX_50)
    assert_nn_le(num_array[48], MAX_50)
    assert_nn_le(num_array[49], MAX_50)

    #Shifting via multiplication
    tempvar t1 = num_array[1]*SHIFT_50_1
    tempvar t2 = num_array[2]*SHIFT_50_2
    tempvar t3 = num_array[3]*SHIFT_50_3
    tempvar t4 = num_array[4]*SHIFT_50_4 
    tempvar t5 = num_array[5]*SHIFT_50_5
    tempvar t6 = num_array[6]*SHIFT_50_6
    tempvar t7 = num_array[7]*SHIFT_50_7
    tempvar t8 = num_array[8]*SHIFT_50_8
    tempvar t9 = num_array[9]*SHIFT_50_9
    tempvar t10 = num_array[10]*SHIFT_50_10
    tempvar t11 = num_array[11]*SHIFT_50_11
    tempvar t12 = num_array[12]*SHIFT_50_12
    tempvar t13 = num_array[13]*SHIFT_50_13
    tempvar t14 = num_array[14]*SHIFT_50_14 
    tempvar t15 = num_array[15]*SHIFT_50_15
    tempvar t16 = num_array[16]*SHIFT_50_16
    tempvar t17 = num_array[17]*SHIFT_50_17
    tempvar t18 = num_array[18]*SHIFT_50_18
    tempvar t19 = num_array[19]*SHIFT_50_19
    tempvar t20 = num_array[20]*SHIFT_50_20
    tempvar t21 = num_array[21]*SHIFT_50_21
    tempvar t22 = num_array[22]*SHIFT_50_22
    tempvar t23 = num_array[23]*SHIFT_50_23
    tempvar t24 = num_array[24]*SHIFT_50_24 
    tempvar t25 = num_array[25]*SHIFT_50_25
    tempvar t26 = num_array[26]*SHIFT_50_26
    tempvar t27 = num_array[27]*SHIFT_50_27
    tempvar t28 = num_array[28]*SHIFT_50_28
    tempvar t29 = num_array[29]*SHIFT_50_29
    tempvar t30 = num_array[30]*SHIFT_50_30
    tempvar t31 = num_array[31]*SHIFT_50_31
    tempvar t32 = num_array[32]*SHIFT_50_32
    tempvar t33 = num_array[33]*SHIFT_50_33
    tempvar t34 = num_array[34]*SHIFT_50_34 
    tempvar t35 = num_array[35]*SHIFT_50_35
    tempvar t36 = num_array[36]*SHIFT_50_36
    tempvar t37 = num_array[37]*SHIFT_50_37
    tempvar t38 = num_array[38]*SHIFT_50_38
    tempvar t39 = num_array[39]*SHIFT_50_39
    tempvar t40 = num_array[40]*SHIFT_50_40
    tempvar t41 = num_array[41]*SHIFT_50_41
    tempvar t42 = num_array[42]*SHIFT_50_42
    tempvar t43 = num_array[43]*SHIFT_50_43
    tempvar t44 = num_array[44]*SHIFT_50_44 
    tempvar t45 = num_array[45]*SHIFT_50_45
    tempvar t46 = num_array[46]*SHIFT_50_46
    tempvar t47 = num_array[47]*SHIFT_50_47
    tempvar t48 = num_array[48]*SHIFT_50_48
    tempvar t49 = num_array[49]*SHIFT_50_49

    tempvar num = t49 + t48 + t47 + t46 + t45 + t44 + t43 + t42 + t41 + 
                t40 + t39 + t38 + t37 + t36 + t35 + t34 + t33 + t32 + t31 + 
                t30 + t29 + t28 + t27 + t26 + t25 + t24 + t23 + t22 + t21 + 
                t20 + t19 + t18 + t17 + t16 + t15 + t14 + t13 + t12 + t11 + 
                t10 + t9  + t8  + t7  + t6  + t5  + t4  + t3  + t2  + t1  + num_array[0]
    return(num)
end 

func unpack_50_array {bitwise_ptr : BitwiseBuiltin*, range_check_ptr} (
        num : felt 
    ) -> (
        num_array_len : felt, 
        num_array : felt* 
    ):
    alloc_locals
    let (local num_array : felt*) = alloc()

    #Masking out each number 
    let (num0) = bitwise_and(num, MASK_50_0)
    let (t1) = bitwise_and(num, MASK_50_1)
    let (t2) = bitwise_and(num, MASK_50_2)
    let (t3) = bitwise_and(num, MASK_50_3)
    let (t4) = bitwise_and(num, MASK_50_4)
    let (t5) = bitwise_and(num, MASK_50_5)
    let (t6) = bitwise_and(num, MASK_50_6)
    let (t7) = bitwise_and(num, MASK_50_7)
    let (t8) = bitwise_and(num, MASK_50_8)
    let (t9) = bitwise_and(num, MASK_50_9)
    let (t10) = bitwise_and(num, MASK_50_10)
    let (t11) = bitwise_and(num, MASK_50_11)
    let (t12) = bitwise_and(num, MASK_50_12)
    let (t13) = bitwise_and(num, MASK_50_13)
    let (t14) = bitwise_and(num, MASK_50_14)
    let (t15) = bitwise_and(num, MASK_50_15)
    let (t16) = bitwise_and(num, MASK_50_16)
    let (t17) = bitwise_and(num, MASK_50_17)
    let (t18) = bitwise_and(num, MASK_50_18)
    let (t19) = bitwise_and(num, MASK_50_19)
    let (t20) = bitwise_and(num, MASK_50_20)
    let (t21) = bitwise_and(num, MASK_50_21)
    let (t22) = bitwise_and(num, MASK_50_22)
    let (t23) = bitwise_and(num, MASK_50_23)
    let (t24) = bitwise_and(num, MASK_50_24)
    let (t25) = bitwise_and(num, MASK_50_25)
    let (t26) = bitwise_and(num, MASK_50_26)
    let (t27) = bitwise_and(num, MASK_50_27)
    let (t28) = bitwise_and(num, MASK_50_28)
    let (t29) = bitwise_and(num, MASK_50_29)
    let (t30) = bitwise_and(num, MASK_50_30)
    let (t31) = bitwise_and(num, MASK_50_31)
    let (t32) = bitwise_and(num, MASK_50_32)
    let (t33) = bitwise_and(num, MASK_50_33)
    let (t34) = bitwise_and(num, MASK_50_34)
    let (t35) = bitwise_and(num, MASK_50_35)
    let (t36) = bitwise_and(num, MASK_50_36)
    let (t37) = bitwise_and(num, MASK_50_37)
    let (t38) = bitwise_and(num, MASK_50_38)
    let (t39) = bitwise_and(num, MASK_50_39)
    let (t40) = bitwise_and(num, MASK_50_40)
    let (t41) = bitwise_and(num, MASK_50_41)
    let (t42) = bitwise_and(num, MASK_50_42)
    let (t43) = bitwise_and(num, MASK_50_43)
    let (t44) = bitwise_and(num, MASK_50_44)
    let (t45) = bitwise_and(num, MASK_50_45)
    let (t46) = bitwise_and(num, MASK_50_46)
    let (t47) = bitwise_and(num, MASK_50_47)
    let (t48) = bitwise_and(num, MASK_50_48)
    let (t49) = bitwise_and(num, MASK_50_49)


    #Shifting via division 
    let (num1, _) = unsigned_div_rem(t1, SHIFT_50_1)
    let (num2, _) = unsigned_div_rem(t2, SHIFT_50_2)
    let (num3, _) = unsigned_div_rem(t3, SHIFT_50_3)
    let (num4, _) = unsigned_div_rem(t4, SHIFT_50_4)
    let (num5, _) = unsigned_div_rem(t5, SHIFT_50_5)
    let (num6, _) = unsigned_div_rem(t6, SHIFT_50_6)
    let (num7, _) = unsigned_div_rem(t7, SHIFT_50_7)
    let (num8, _) = unsigned_div_rem(t8, SHIFT_50_8)
    let (num9, _) = unsigned_div_rem(t9, SHIFT_50_9)
    let (num10, _) = unsigned_div_rem(t10, SHIFT_50_10)
    let (num11, _) = unsigned_div_rem(t11, SHIFT_50_11)
    let (num12, _) = unsigned_div_rem(t12, SHIFT_50_12)
    let (num13, _) = unsigned_div_rem(t13, SHIFT_50_13)
    let (num14, _) = unsigned_div_rem(t14, SHIFT_50_14)
    let (num15, _) = unsigned_div_rem(t15, SHIFT_50_15)
    let (num16, _) = unsigned_div_rem(t16, SHIFT_50_16)
    let (num17, _) = unsigned_div_rem(t17, SHIFT_50_17)
    let (num18, _) = unsigned_div_rem(t18, SHIFT_50_18)
    let (num19, _) = unsigned_div_rem(t19, SHIFT_50_19)
    let (num20, _) = unsigned_div_rem(t20, SHIFT_50_20)
    let (num21, _) = unsigned_div_rem(t21, SHIFT_50_21)
    let (num22, _) = unsigned_div_rem(t22, SHIFT_50_22)
    let (num23, _) = unsigned_div_rem(t23, SHIFT_50_23)
    let (num24, _) = unsigned_div_rem(t24, SHIFT_50_24)

    let (t25, _) = unsigned_div_rem(t25, SHIFT_50_24)
    let (num25, _) = unsigned_div_rem(t25, SHIFT_50_1)
    let (t26, _) = unsigned_div_rem(t26, SHIFT_50_24)
    let (num26, _) = unsigned_div_rem(t26, SHIFT_50_2)
    let (t27, _) = unsigned_div_rem(t27, SHIFT_50_24)
    let (num27, _) = unsigned_div_rem(t27, SHIFT_50_3)
    let (t28, _) = unsigned_div_rem(t28, SHIFT_50_24)
    let (num28, _) = unsigned_div_rem(t28, SHIFT_50_4)
    let (t29, _) = unsigned_div_rem(t29, SHIFT_50_24)
    let (num29, _) = unsigned_div_rem(t29, SHIFT_50_5)
    let (t30, _) = unsigned_div_rem(t30, SHIFT_50_24)
    let (num30, _) = unsigned_div_rem(t30, SHIFT_50_6)
    let (t31, _) = unsigned_div_rem(t31, SHIFT_50_24)
    let (num31, _) = unsigned_div_rem(t31, SHIFT_50_7)
    let (t32, _) = unsigned_div_rem(t32, SHIFT_50_24)
    let (num32, _) = unsigned_div_rem(t32, SHIFT_50_8)
    let (t33, _) = unsigned_div_rem(t33, SHIFT_50_24)
    let (num33, _) = unsigned_div_rem(t33, SHIFT_50_9)
    let (t34, _) = unsigned_div_rem(t34, SHIFT_50_24)
    let (num34, _) = unsigned_div_rem(t34, SHIFT_50_10)
    let (t35, _) = unsigned_div_rem(t35, SHIFT_50_24)
    let (num35, _) = unsigned_div_rem(t35, SHIFT_50_11)
    let (t36, _) = unsigned_div_rem(t36, SHIFT_50_24)
    let (num36, _) = unsigned_div_rem(t36, SHIFT_50_12)
    let (t37, _) = unsigned_div_rem(t37, SHIFT_50_24)
    let (num37, _) = unsigned_div_rem(t37, SHIFT_50_13)
    let (t38, _) = unsigned_div_rem(t38, SHIFT_50_24)
    let (num38, _) = unsigned_div_rem(t38, SHIFT_50_14)
    let (t39, _) = unsigned_div_rem(t39, SHIFT_50_24)
    let (num39, _) = unsigned_div_rem(t39, SHIFT_50_15)
    let (t40, _) = unsigned_div_rem(t40, SHIFT_50_24)
    let (num40, _) = unsigned_div_rem(t40, SHIFT_50_16)
    let (t41, _) = unsigned_div_rem(t41, SHIFT_50_24)
    let (num41, _) = unsigned_div_rem(t41, SHIFT_50_17)
    let (t42, _) = unsigned_div_rem(t42, SHIFT_50_24)
    let (num42, _) = unsigned_div_rem(t42, SHIFT_50_18)
    let (t43, _) = unsigned_div_rem(t43, SHIFT_50_24)
    let (num43, _) = unsigned_div_rem(t43, SHIFT_50_19)
    let (t44, _) = unsigned_div_rem(t44, SHIFT_50_24)
    let (num44, _) = unsigned_div_rem(t44, SHIFT_50_20)
    let (t45, _) = unsigned_div_rem(t45, SHIFT_50_24)
    let (num45, _) = unsigned_div_rem(t45, SHIFT_50_21)
    let (t46, _) = unsigned_div_rem(t46, SHIFT_50_24)
    let (num46, _) = unsigned_div_rem(t46, SHIFT_50_22)
    let (t47, _) = unsigned_div_rem(t47, SHIFT_50_24)
    let (num47, _) = unsigned_div_rem(t47, SHIFT_50_23)
    let (t48, _) = unsigned_div_rem(t48, SHIFT_50_24)
    let (num48, _) = unsigned_div_rem(t48, SHIFT_50_24)

    #last value hits the size limits so required a more specific divisor to make it work 
    let (t49, _) = unsigned_div_rem(t49, 2**122)
    let (t49, _) = unsigned_div_rem(t49, 2**122)
    let (num49, _) = unsigned_div_rem(t49, 2)

    assert num_array[0] = num0
    assert num_array[1] = num1
    assert num_array[2] = num2
    assert num_array[3] = num3
    assert num_array[4] = num4
    assert num_array[5] = num5 
    assert num_array[6] = num6
    assert num_array[7] = num7
    assert num_array[8] = num8
    assert num_array[9] = num9
    assert num_array[10] = num10 
    assert num_array[11] = num11
    assert num_array[12] = num12
    assert num_array[13] = num13
    assert num_array[14] = num14
    assert num_array[15] = num15 
    assert num_array[16] = num16
    assert num_array[17] = num17
    assert num_array[18] = num18
    assert num_array[19] = num19
    assert num_array[20] = num20 
    assert num_array[21] = num21
    assert num_array[22] = num22
    assert num_array[23] = num23
    assert num_array[24] = num24
    assert num_array[25] = num25 
    assert num_array[26] = num26
    assert num_array[27] = num27
    assert num_array[28] = num28
    assert num_array[29] = num29
    assert num_array[30] = num30 
    assert num_array[31] = num31
    assert num_array[32] = num32
    assert num_array[33] = num33
    assert num_array[34] = num34
    assert num_array[35] = num35 
    assert num_array[36] = num36
    assert num_array[37] = num37
    assert num_array[38] = num38
    assert num_array[39] = num39
    assert num_array[40] = num40 
    assert num_array[41] = num41
    assert num_array[42] = num42
    assert num_array[43] = num43
    assert num_array[44] = num44
    assert num_array[45] = num45 
    assert num_array[46] = num46
    assert num_array[47] = num47
    assert num_array[48] = num48
    assert num_array[49] = num49

    return (50, num_array)
end 

