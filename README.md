# wodext
Practice cython wrapping of C++

This short project is just to gain some experience on wrapping C++ code with Cython. 

It contains basic representation of crossfit workouts/metcons, as well as a means a representation of the movements involded.


## Usage

The following two samples show how to create a For Time wod `Murph`, and an AMRAP, `Mary`, as well as their representation.

`Murph`:

```python
>>> import wodext as wod
>>> murph = wod.PyForTime("Murph", time_cap=50)
>>> movements = [
...     wod.PyMovement("run", distance=1600),
...     wod.PyMovement("pull-up", reps=100),
...     wod.PyMovement("push-up", reps=200),
...     wod.PyMovement("air squat", reps=300),
...     wod.PyMovement("run", distance=1600)
... ]
>>> for mov in movements:
>>>     murph.add(mov)
>>> print(murph)
PyForTime
---------
- run 1600.0 m
- pull-up, reps: 100
- push-up, reps: 200
- air squat, reps: 300
- run 1600.0 m
---------
```

`Mary`:

```python
>>> mary = wod.PyAMRAP("Mary", time=20)
>>> movements = [
...     wod.PyMovement("hspu", reps=5),
...     wod.PyMovement("pistols", reps=10),
...     wod.PyMovement("pull-up", reps=15)
... ]
>>> 
>>> for mov in movements:
...     mary.add(mov)
>>> print(mary)
PyAMRAP
-------
- hspu, reps: 5
- pistols, reps: 10
- pull-up, reps: 15
-------
```

## How To guide

Install the dependencies in a new virtual environment:

```sh
pip install -r requirements.txt
```

Build the extension:

```sh
make compile
```

Run the unit tests:

```sh
make test
```

If everything worked properly, the extension is importable from python as `wodext`.

### References

Personal references for future me.

Documentation
- [cython docs 1](https://cython.readthedocs.io/en/latest/src/userguide/wrapping_CPlusPlus.html)
- [cython docs 2](https://cython.readthedocs.io/en/latest/src/tutorial/clibraries.html)
- [cython docs 3](https://cython.readthedocs.io/en/latest/src/userguide/sharing_declarations.html)

- [cython-cpp intro](https://azhpushkin.me/posts/cython-cpp-intro)

- [regarding arguments of sublcasses](https://cython.readthedocs.io/en/latest/src/userguide/special_methods.html)


Sample packages including cython:
- [pyaacrl](https://github.com/azhpushkin/pyaacrl)
- [uvloop](https://github.com/MagicStack/uvloop/blob/master/setup.py)
- [cython docs](https://cython.readthedocs.io/en/latest/src/userguide/wrapping_CPlusPlus.html)

Inheritance
- [stackoverflow on inheritance](https://stackoverflow.com/questions/28573479/cython-python-c-inheritance-passing-derived-class-as-argument-to-function-e)

- [inheritance](https://coderedirect.com/questions/490860/cython-python-c-inheritance-passing-derived-class-as-argument-to-function-e)

- [polymorphism](https://altugkarakurt.github.io/how-to-wrap-polymorphic-cpp-classes-with-cython)

- [polymorphism example repo](https://github.com/altugkarakurt/OCIMP/blob/master/TIM%2B/Tim/InfGraph.cpp)
