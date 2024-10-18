import numpy as np
from YoungSun import youngsun as pyyoungsun
from YoungSun.solarflux import solarflux, youngsun

def test():
    wv = np.logspace(np.log10(1),np.log10(250e3),10000)
    grid = wv*10
    timegas = np.linspace(-3,4.55,500)

    for timega in timegas:
        fluxmult_py = pyyoungsun.youngsun(timega, grid)
        fluxmult = youngsun(timega, grid)
        assert np.all(np.isclose(fluxmult_py,fluxmult,rtol=1e-2))

if __name__ == '__main__':
    test()