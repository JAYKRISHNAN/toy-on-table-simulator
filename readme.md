## Running the app
- Open the terminal
- Clone the app `git clone git@github.com:JAYKRISHNAN/toy-on-table-simulator.git`
- Go to the root directory of the app `cd toy-on-table-simulator/`
- Give the input in the correct format in the file `input.txt` in the root directory of the app
- Run program, run  `ruby -I lib bin/toy_on_table input.txt output.txt`
- Output is written to the file `output.txt` in the root directory of the app

## Test cases

- A comprehensive suite of test cases are written in the automated test suite here -https://github.com/JAYKRISHNAN/toy-on-table-simulator/blob/master/spec/toy_on_table/runner_spec.rb#L44-L121


## Running the test suite
- First, run `bundle install`
- Then, run `bundle exec rspec`


# ToyOnTable

- The application is a simulation of a toy robot moving on a square tabletop, of dimensions 5 units x 5 units.
- There are no other obstructions on the table surface.
- The robot is free to roam around the surface of the table, but must be prevented from falling to destruction. Any movement
  that would result in the robot falling from the table must be prevented, however further valid movement commands must still
  be allowed.


## Constraints

The toy robot must not fall off the table during movement. This also includes the initial placement of the toy robot.
Any move that would cause the robot to fall must be ignored.

## Example Input and Output:

```plain
PLACE 0,0,NORTH
MOVE
REPORT
Output: 0,1,NORTH
```

```plain
PLACE 0,0,NORTH
LEFT
REPORT
Output: 0,0,WEST
```

```plain
PLACE 1,2,EAST
MOVE
MOVE
LEFT
MOVE
REPORT
Output: 3,3,NORTH
```
