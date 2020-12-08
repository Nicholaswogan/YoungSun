# YoungSun

This is a Python wrapper of the `YoungSun` Fortran program from [Claire et al. 2012](https://iopscience.iop.org/article/10.1088/0004-637X/757/1/95/meta). The program calculates the solar flux at Earth at any time in Earth's 4.5 billion year old history.

If you use this Python package for an academic paper, please throw [Claire et al. 2012](https://iopscience.iop.org/article/10.1088/0004-637X/757/1/95/meta) a citation.

## Installation
To install this python package, download this repository, navigate a terminal to this repository, then run the command

`pip install .`

## Usage
This package has only one function, `YoungSun.solarflux.solarflux`. Use it like this:

```python
from YoungSun import solarflux
time_ga = 2.7
output_file = 'Sun_2.7Ga.txt'
solarflux.solarflux(time_ga,output_file)
```

The first argument to the function, `time_ga`, is a time in Earth's history in giga-annum (billions of years ago). The second argument, `output_file`, is the name of the output file.

Running the above code will generate a file `Sun_2.7Ga.txt` containing the solar flux at Earth 2.7 billion years ago.
