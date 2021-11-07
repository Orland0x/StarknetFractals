import matplotlib.pyplot as plt
import numpy as np

def get_iter(c:complex, thresh:int =4, max_steps:int =25) -> int:
    # Z_(n) = (Z_(n-1))^2 + c
    # Z_(0) = c
    z=c
    i=1
    while i<max_steps and (z*z.conjugate()).real<thresh:
        z=z*z +c
        i+=1
    return i


def get_iter_recursive(c:complex, max_steps:int=25, thresh:int=4, z:complex=0,  steps:int=0) -> int:

    if steps==max_steps or (z*z.conjugate()).real>thresh:
        return steps 
    z=z*z+c 
    return get_iter_recursive(c=c, max_steps=max_steps, thresh=thresh, z=z, steps=steps+1)


def get_iter_recursive2(c:complex, z:complex=0, max_steps:int=25, thresh:int=4) -> int:
    if max_steps==0 or (z*z.conjugate()).real>thresh:
        return max_steps 
    z=z*z+c 
    return get_iter_recursive2(c=c,z=z, max_steps=max_steps-1)



def plotter(n, thresh, max_steps=25):
    mx = 2.48 / (n-1)
    my = 2.26 / (n-1)
    mapper = lambda x,y: (mx*x - 2, my*y - 1.13)
    img=np.full((n,n), 255)
    for x in range(n):
        for y in range(n):
            it = get_iter(complex(*mapper(x,y)), thresh=thresh, max_steps=max_steps)
            img[y][x] = 255 - it
    return img


def plotter2(n, thresh, max_steps=25):
    mx = 2.48/n
    my = 2.26/n
    mapper = lambda x,y: (mx*x - 2, my*y - 1.13)
    img=np.full((n,n), 255)
    for x in range(n):
        for y in range(n):
            it = get_iter_recursive(c=complex(*mapper(x,y)), max_steps=25)
            img[y][x] = 255 - it
    print(img)
    return img



# cmplx1 = complex(0.71,3.2)
# cmplx2 = complex(3.7,4.1)
# print(cmplx1*cmplx1+cmplx2)


# cmplx = complex(0.3,0.07)
# print(cmplx)
# iters = get_iter_recursive(c=cmplx, max_steps=25)
# print(iters)

n=1000
img = plotter2(n, thresh=4, max_steps=25)
plt.imshow(img, cmap="plasma")
plt.axis("off")
plt.show()


# n = 1000
# mx = 2.48 / (n-1)
# my = 2.26 / (n-1)
# mapper = lambda x,y: (mx*x - 2, my*y - 1.13)
# print(complex(*mapper(1,1)))


