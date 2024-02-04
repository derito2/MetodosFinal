%{

#include <stdio.h>
#include <stdbool.h>

int yylex();
void yyerror(const char *s);

enum Direction {
    LEFT,
    UP
};

typedef struct {
    int x;
    int y;
    enum Direction direction;
} T_Position;

T_Position T_position = {0, 0, LEFT};

int calculateNewDirection(int currentDirection, int degrees);
void turn(int value);
bool Moving(int value);
void move(int value);


#define PRINT_INSTRUCTION(action, value) \
    printf("%s,%d\n", action, value)

%}

%token T_BLOCK_NUMBER T_DEGREE_NUMBER T_ROBOT_PLEASE T_MOVE T_TURN T_BLOCKS T_DEGREES T_THEN T_NEWLINE T_OTHER

%%

program_code : statements_code
             | /* empty */
             ;

statements_code : statement_code
               | statement_code statements_code
               ;

statement_code : T_ROBOT_PLEASE actions_code T_NEWLINE { printf("SUCCESS\n"); }
               | error T_NEWLINE { printf("FAIL\n"); yyclearin; }
               // | actions_code T_NEWLINE { printf("FAIL\n"); }
               ;


actions_code : action_code
             | action_code T_THEN actions_code
             ;

action_code : move_code
            | turn_code
            ;

move_code : T_MOVE T_BLOCK_NUMBER T_BLOCKS      {move($2);}
          ;

turn_code : T_TURN T_DEGREE_NUMBER T_DEGREES {turn($2);}

%%

void yyerror(const char* s) {
    // fprintf(stderr, "Error: %s\n", s);
}

bool Moving(int value) {
    switch (T_position.direction) {
        case LEFT:
            return T_position.x + value < 10;
        case UP:
            return T_position.y + value < 10;
    }
}

void move(int value) {
    if (Moving(value)) {
        switch (T_position.direction) {
            case LEFT:
                T_position.x += value;
                break;
            case UP:
                T_position.y += value;
                break;
        }
        PRINT_INSTRUCTION("MOV", value);
    } 
}

int calculateNewDirection(int currentDirection, int degrees) {
    return (currentDirection + (360 - degrees) / 90) % 4;
}

void turn(int value) {
    int newDirection = calculateNewDirection(T_position.direction, value);
    T_position.direction = newDirection;
    PRINT_INSTRUCTION("TURN", value);
}

extern FILE *yyin;

int main(int argc, char *argv[]) {
    yyin = fopen("input.txt", "r");
    if (!yyin) {
        perror("Error opening file");
        return 1;
    }

    yyparse();

    fclose(yyin);
    return 0;
}