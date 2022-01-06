
import pytest
import wodext as wod



class TestPyMovement:
    @pytest.fixture(scope="class")
    def pull_up(self):
        pull_up = wod.PyMovement("pull up", reps=10)
        yield pull_up
        del(pull_up)

    @pytest.fixture(scope="class")
    def row(self):
        row = wod.PyMovement("row", distance=200, equipment="row")
        yield row
        del(row)

    @pytest.fixture(scope="class")
    def thruster(self):
        thruster = wod.PyMovement("thruster", weight=95, equipment="barbell", reps=15)
        yield thruster
        del(thruster)

    def test_pull_up(self, pull_up):
        assert pull_up.name == "pull up"
        assert pull_up.weight == 0.
        assert pull_up.reps == 10
        assert pull_up.equipment == ""
        assert pull_up.distance == 0.

    def test_name_setter(self, pull_up):
        pull_up.name = "pu"
        assert pull_up.name == "pu"
        pull_up.name = "pull up"        

    def test_row(self, row):
        assert row.name == "row"
        assert row.weight == 0.
        assert row.reps == 0
        assert row.equipment == "row"
        assert row.distance == 200

    def test_thruster(self, thruster):
        assert thruster.name == "thruster"
        assert thruster.weight == 95
        assert thruster.reps == 15
        assert thruster.equipment == "barbell"
        assert thruster.distance == 0.


class TestPyWorkout:
    @pytest.fixture(scope="class")
    def workout(self):
        workout = wod.PyWorkout("wkout")
        yield workout
        del(workout)

    def test_name(self, workout):
        assert workout.name == "wkout"
        assert workout.get_name() == "wkout"

    def test_add_workout(self, workout):
        try:
            thruster = wod.PyMovement("thruster", weight=95, equipment="barbell", reps=15)
            workout.add(thruster)
            movements = workout.get_movements()
            assert isinstance(movements, list)
            assert all([isinstance(mov, wod.PyMovement) for mov in movements])
        finally:
            del(thruster)


class TestPyForTime:
    @pytest.fixture(scope="class")
    def murph(self):
        murph = wod.PyForTime("Murph", time_cap=50)
        yield murph
        del(murph)

    def test_time_cap(self, murph):
        assert murph.time_cap == 50

    def test_murph(self, murph):
        try:
            movements = [
                wod.PyMovement("run", distance=1600),
                wod.PyMovement("pull-up", reps=100),
                wod.PyMovement("push-up", reps=200),
                wod.PyMovement("air squat", reps=300),
                wod.PyMovement("run", distance=1600)
            ]
            for mov in movements:
                murph.add(mov)

            moves = murph.get_movements()
            assert [m1.name==m2.name for m1, m2 in zip(movements, moves)]

        finally:
            del(movements)


class TestPyAMRAP:
    @pytest.fixture(scope="class")
    def mary(self):
        mary = wod.PyAMRAP("Mary", time=50)
        yield mary
        del(mary)

    def test_mary(self, mary):
        try:
            movements = [
                wod.PyMovement("hspu", reps=5),
                wod.PyMovement("pistols", reps=10),
                wod.PyMovement("pull-up", reps=15)
            ]
            for mov in movements:
                mary.add(mov)

            moves = mary.get_movements()
            assert [m1.name==m2.name for m1, m2 in zip(movements, moves)]

        finally:
            del(mary)
            del(movements)


class TestPyEMOM:
    @pytest.fixture(scope="class")
    def macho_man(self):
        macho_man = wod.PyEMOM("Macho Man", rounds=20)
        yield macho_man
        del(macho_man)

    def test_macho_man(self, macho_man):
        try:
            movements = [
                wod.PyMovement("power clean", reps=3, equipment="barbell", weight=90),
                wod.PyMovement("front squat", reps=3, equipment="barbell", weight=90),
                wod.PyMovement("push jerk", reps=3, equipment="barbell", weight=90)
            ]
            interval = wod.PyWorkout("macho man round")
            for mov in movements:
                interval.add(mov)

            macho_man.add(interval)

            assert isinstance(macho_man, wod.PyEMOM)
            assert macho_man.get_name() == "Macho Man"
            intervals = macho_man.get_intervals()

            assert all([isinstance(interval, wod.PyWorkout) for interval in intervals])
            assert all([isinstance(mov, wod.PyMovement) for mov in intervals[0].get_movements()])

        finally:
            del(interval)
            del(macho_man)

