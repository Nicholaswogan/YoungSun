from sunflux import sunflux
import os

fortpath = os.path.dirname(os.path.realpath(__file__))+'/'
sunflux.fileloc = "{:500}".format(fortpath)

def solarflux(timega,outfile):
    wv, flux = sunflux.solarflux(timega)
    fil = open(outfile,'w')
    fil.write('Wavelength (nm)  '+'Solar flux (mW/m^2/nm)\n')
    for i in range(len(wv)):
        fil.write("{:>15}".format('%.4f'%wv[i])+'  '\
                  +'%.6e'%flux[i]+'\n')
    fil.close()
