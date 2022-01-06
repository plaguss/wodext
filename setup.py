
from setuptools import setup, Extension

from Cython.Build import cythonize


extensions = [
    Extension(
        "wodext",
        sources=["wodext/wodext.pyx", "wodext/Workout.cpp"],
    )
]


setup(
    ext_modules=cythonize(
        extensions,
        language_level=3
    )
)
