#include "Workout.hpp"

using namespace wodext;

//Definition of Workout class

Workout::Workout() {
    name = "";
}

Workout::Workout(std::string name_) {
    name = name_;
}

Workout::~Workout() {    
}

void Workout::add(Movement mov) {
    movements.push_back(mov);
}

std::vector<Movement> Workout::get_movements() {
    return movements;
}

std::string Workout::get_name() {
    return name;
}


//Definition of ForTime class

ForTime::ForTime(
    std::string name_,
    int time_cap_
) : Workout(name_) {
    time_cap = time_cap_;
}

ForTime::~ForTime() {    
}

int ForTime::get_time_cap() {
    return time_cap;
}


//Definition of AMRAP class

AMRAP::AMRAP(
    std::string name_,
    int time_
) : Workout(name_) {
    time = time_;
}

AMRAP::~AMRAP() {    
}

int AMRAP::get_time() {
    return time;
}


//Definition of EMOM class

EMOM::EMOM(
    std::string name_,
    int rounds_,
    int interval_duration_
) {
    name = name_;
    rounds = rounds_;
    interval_duration = interval_duration_;
}

EMOM::~EMOM() {

}

std::string EMOM::get_name() {
    return name;
}

void EMOM::add(Workout wkt) {
    workouts.push_back(wkt);
}

std::vector<Workout> EMOM::get_intervals() {
    return workouts;
}
