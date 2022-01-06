#include <string>
#include <vector>


namespace wodext {

    class Movement {
        public:
            std::string name;
            double weight = 0.;  // kg
            int reps = 0;
            std::string equipment = "";
            double distance = 0.;  // meters
    };

    class Workout {
        protected:
            std::string name;
            std::vector<Movement> movements;

        public:
            Workout();
            Workout(std::string name);
            ~Workout();
            void add(Movement mov);
            std::vector<Movement> get_movements();
            std::string get_name();
    };

    class ForTime: public Workout {
        private:
            int time_cap;

        public:
            ForTime(std::string name, int time_cap);
            ~ForTime();
            int get_time_cap();
    };

    class AMRAP: public Workout {
        private:
            int time;

        public:
            AMRAP(std::string name, int time_cap);
            ~AMRAP();
            int get_time();
    };

    class EMOM {
        private:
            std::string name;
            std::vector<Workout> workouts;
            int rounds;
            int interval_duration;

        public:
            EMOM(std::string name, int rounds, int interval_duration);
            ~EMOM();
            void add(Workout wkt);
            std::vector<Workout> get_intervals();
            std::string get_name();
    };

}