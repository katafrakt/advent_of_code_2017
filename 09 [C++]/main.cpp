#include <iostream>
#include <fstream>
#include <vector>
using namespace std;

class StateMachine {
    public:
        void consume(char);
        int getScore() { return score; }
        int getGarbageCount() { return garbage_count; }
        StateMachine();
    private:
        enum State { initial, group, garbage, ignore_character };
        vector<State> states;
        int score, garbage_count;
        State currentState() { return states[states.size()-1]; }
        int groupsCount();
};

StateMachine::StateMachine() {
    score = 0;
    garbage_count = 0;
    states.push_back(initial);
}

void StateMachine::consume(char ch) {
    switch(currentState()) {
        case ignore_character:
            states.pop_back();
            break;
        case garbage:
            if(ch == '>') {
                states.pop_back();
            } else if (ch == '!') {
                states.push_back(ignore_character);
            } else {
                garbage_count++;
            }
            break;
        case initial:
        case group:
            if(ch == '{') {
                states.push_back(group);
                score += groupsCount();
            } else if(ch == '<') {
                states.push_back(garbage);
            } else if(ch == '!') {
                cout << '^';
                states.push_back(ignore_character);
            } else if(ch == '}') {
                states.pop_back();
            }
    }
}

int StateMachine::groupsCount() {
    int count = 0;
    for(int i=0; i < states.size(); i++) {
        if(states[i] == group)
            count++;
    }
    return count;
}

int main() {
    char ch;

    fstream fin("input", fstream::in);
    StateMachine sm;

    while(fin >> noskipws >> ch) {
        sm.consume(ch);
    }

    cout << "Part 1: " << sm.getScore() << endl;
    cout << "Part 2: " << sm.getGarbageCount() << endl;

    return 0;
}