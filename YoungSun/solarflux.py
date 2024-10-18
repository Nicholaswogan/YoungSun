import numpy as np
import ctypes as ct
import os
import platform

rootdir = os.path.dirname(os.path.realpath(__file__))+'/'

if platform.uname()[0] == "Windows":
    name = "libyoungsun.dll"
elif platform.uname()[0] == "Linux":
    name = "libyoungsun.so"
else:
    name = "libyoungsun.dylib"
libyoungsun = ct.CDLL(rootdir+name)

solarflux_c = libyoungsun.solarflux
solarflux_c.argtypes = [
    ct.c_double,
    ct.c_char_p,
    ct.POINTER(ct.c_double),
    ct.POINTER(ct.c_double),
]
solarflux_c.restype = None

youngsun_c = libyoungsun.youngsun_c
youngsun_c.argtypes = [
    ct.c_int,
    ct.c_double,
    ct.POINTER(ct.c_double),
    ct.c_char_p,
    ct.POINTER(ct.c_double),
]
youngsun_c.restype = None

def youngsun(timega, grid):
    grid = grid.astype(np.double)
    n = len(grid)
    fluxmult = np.empty(n,np.double)
    rootdir_c = ct.create_string_buffer(rootdir.encode())
    c_double_p = ct.POINTER(ct.c_double)
    youngsun_c(n, timega, grid.ctypes.data_as(c_double_p), rootdir_c, fluxmult.ctypes.data_as(c_double_p))
    return fluxmult

def solarflux(timega, outfile):
    
    timega_ = float(timega)
    rootdir_c = ct.create_string_buffer(rootdir.encode())
    n = 26650
    wv = np.empty((n,),np.double)
    flux = np.empty((n,),np.double)
    c_double_p = ct.POINTER(ct.c_double)

    solarflux_c(timega_, rootdir_c, wv.ctypes.data_as(c_double_p), flux.ctypes.data_as(c_double_p))

    fil = open(outfile,'w')
    fil.write('Wavelength (nm)  '+'Solar flux (mW/m^2/nm)\n')
    for i in range(len(wv)):
        fil.write("{:>15}".format('%.4f'%wv[i])+'  '\
                  +'%.6e'%flux[i]+'\n')
    fil.close()
