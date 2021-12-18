import matplotlib.pyplot as plt
import numpy as np

#generating the mandelbrot set with python. Used as a reference for the cairo implementation

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


def plotter_recursive(n, thresh, max_steps=25):
    mx = 2.48/n
    my = 2.26/n
    mapper = lambda x,y: (mx*x - 2, my*y - 1.13)
    img=np.full((n,n), 255)
    for x in range(n):
        for y in range(n):
            it = get_iter_recursive(c=complex(*mapper(x,y)), max_steps=32)
            img[y][x] = 255 - it
    return img




n=100
img = plotter_recursive(n, thresh=4, max_steps=25)
plt.imshow(img, cmap="plasma")
plt.axis("off")
plt.show()




