# distutils: language=c++
# cython: c_string_type=unicode, c_string_encoding=utf8

from cython.operator cimport dereference as deref

from libcpp.string cimport string
from libcpp.vector cimport vector


cdef extern from "Workout.hpp" namespace "wodext":
    cdef cppclass Movement:
        string name
        float weight
        int reps
        string equipment
        float distance

    cdef cppclass Workout:
        Workout() except +
        Workout(string name) except +
        void add(Movement mov)
        vector[Movement] get_movements()
        string get_name()

    cdef cppclass ForTime(Workout):
        ForTime(string name, int time_cap) except +
        int get_time_cap()

    cdef cppclass AMRAP(Workout):
        AMRAP(string name, int time) except +
        int get_time()

    cdef cppclass EMOM:
        EMOM(string name, int rounds, int interval_duration) except +
        void add(Workout wkt)
        vector[Workout] get_intervals()
        string get_name()



cdef class PyMovement:
    cdef Movement movement
   
    def __cinit__(
        self,
        string name,
        float weight = 0,
        float distance = 0,
        int reps = 0,
        string equipment = string(b"")
    ):
        self.movement.name = name
        self.movement.weight = weight
        self.movement.distance = distance
        self.movement.reps = reps
        self.movement.equipment = equipment

    def __repr__(self):
        return type(self).__name__ + f"({self.name})"

    def __str__(self):
        repr_ = self.name
        if self.weight > 0.:
            repr_ += f" at {self.weight}Kg"
        if self.distance > 0.:
            repr_ += f" {self.distance} m"
        if self.reps > 0:
            repr_ += f", reps: {self.reps}"

        return repr_

    @property
    def name(self):
        return self.movement.name

    @name.setter
    def name(self, name_):
        self.movement.name = name_

    @property
    def weight(self):
        return self.movement.weight

    @property
    def distance(self):
        return self.movement.distance

    @property
    def reps(self):
        return self.movement.reps

    @property
    def equipment(self):
        return self.movement.equipment


cdef PyMovement parse_movement(Movement mov):
    return PyMovement(
        mov.name,
        weight=mov.weight,
        distance=mov.distance,
        reps=mov.reps,
        equipment=mov.equipment
    )


cdef class PyWorkout:
    cdef Workout *thisptr

    def __cinit__(self, *args, **kwargs):
        # Reason behind args/kwargs:
        # https://cython.readthedocs.io/en/latest/src/userguide/special_methods.html#initialisation-methods-cinit-and-init
        cdef vector[Movement] movements_
        self.thisptr = new Workout(args[0])  # Only the name is passed

    def __dealloc__(self):
        del(self.thisptr)

    def __repr__(self):
        return type(self).__name__ + "(" + str(self.get_name()) + ")"

    def _type(self):
        return

    def _str(self):
        name = type(self).__name__ + f" - {self.name})"
        name += self._type()
        repr_ = type(self).__name__ + "\n"
        repr_ += len(type(self).__name__) * "-" + "\n"
        for mov in self.get_movements():
            repr_ += "- " + str(mov) + "\n"
        repr_ += len(type(self).__name__) * "-"

        return repr_

    def __str__(self):
        return self._str()

    def add(self, mov: PyMovement):
        self.thisptr.add(mov.movement)

    def get_movements(self):
        moves = self.thisptr.get_movements()
        return [parse_movement(mov) for mov in moves]

    def get_name(self):
        return self.thisptr.get_name()

    @property
    def name(self):
        return self.thisptr.get_name()


cdef class PyForTime(PyWorkout):
    cdef ForTime *thisptr_ft

    def __cinit__(self, string name, int time_cap = 100):
        self.thisptr_ft = new ForTime(name, time_cap=time_cap)

    def __dealloc__(self):
        del(self.thisptr_ft)

    def _type(self):
        return f", TC. {self.time_cap}"

    def get_time_cap(self):
        return self.thisptr_ft.get_time_cap()

    @property
    def time_cap(self):
        return self.get_time_cap()


cdef class PyAMRAP(PyWorkout):
    cdef AMRAP *thisptr_ft

    def __cinit__(self, string name, int time = 100):
        self.thisptr_ft = new AMRAP(name, time=time)

    def __dealloc__(self):
        del(self.thisptr_ft)

    def _type(self):
        return f", {self.time} minutes"

    def get_time(self):
        return self.thisptr_ft.get_time()

    @property
    def time(self):
        return self.get_time()


cdef get_intervals_from_cpp(vector[Workout] workouts):
    wkouts = []
    for wkt in workouts:
        wkout = get_interval_from_cpp(wkt)
        wkouts.append(wkout)

    return wkouts


cdef PyWorkout get_interval_from_cpp(Workout wkt):
    cdef vector[Movement] moves
    cdef Movement mov
    moves = wkt.get_movements()
    wkout = PyWorkout(wkt.get_name())
    for mov in moves:
        wkout.add(parse_movement(mov))

    return wkout


cdef class PyEMOM:
    cdef EMOM *thisptr

    def __cinit__(self, string name, int rounds = 5, int interval_duration = 1):
        self.thisptr = new EMOM(name, rounds, interval_duration)
        self._type = f"EMOM for {rounds} minutes"
        if interval_duration > 1:
            self._type += f", every {interval_duration}"

    def __dealloc__(self):
        del(self.thisptr)

    def add(self, PyWorkout wkt):
        self.thisptr.add(deref(wkt.thisptr))

    def get_intervals(self):
        intervals = self.thisptr.get_intervals()
        return get_intervals_from_cpp(intervals)

    def get_name(self):
        return self.thisptr.get_name()
