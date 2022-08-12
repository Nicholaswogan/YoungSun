#!/usr/bin/env python3
def configuration(parent_package='',top_path=None):
    from numpy.distutils.misc_util import Configuration
    config = Configuration('',parent_package,top_path)

    config.add_data_dir(('YoungSun/data','YoungSun/data'))
    return config

if __name__ == "__main__":
    from numpy.distutils.core import setup, Extension
    #setup(**configuration(top_path='').todict())
    extensions = [
        Extension(name="sunflux",
                  sources=["YoungSun/SunFlux.f90"]),]
    setup(name = 'YoungSun',
    packages=['YoungSun'],
    version='1.2',
    ext_modules=extensions,
    configuration=configuration)
