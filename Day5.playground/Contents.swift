enum Mode {
  case position
  case immediate
}

enum Position {
  case first
  case second
}

func getParameterMode(for position: Position, _ value: Int) -> Mode {
  switch position {
  case .first:
    let firstValue = (value / 100) % 10
    return firstValue == 0 ? .position : .immediate
  case .second:
    let secondValue = value / 1000
    return secondValue == 0 ? .position : .immediate
  }
}

func getValue(for index: Int, with mode: Mode, _ program: [Int]) -> Int {
  switch mode {
  case .immediate:
    return program[index]
  case .position:
    return program[program[index]]
  }
}

func runProgram(program: inout [Int], input: Int) -> Int {
  var output = 0

  var instructionPointer = 0

  while instructionPointer < program.count && program[instructionPointer] != 99 {
    let value = program[instructionPointer]
    let instruction = value % 100

    if instruction == 1 {
      let firstMode = getParameterMode(for: .first, value)
      let secondMode = getParameterMode(for: .second, value)

      let first = getValue(for: instructionPointer + 1, with: firstMode, program)
      let second = getValue(for: instructionPointer + 2, with: secondMode, program)

      program[program[instructionPointer + 3]] = first + second
      instructionPointer += 4
    }

    else if instruction == 2 {
      let firstMode = getParameterMode(for: .first, value)
      let secondMode = getParameterMode(for: .second, value)

      let first = getValue(for: instructionPointer + 1, with: firstMode, program)
      let second = getValue(for: instructionPointer + 2, with: secondMode, program)

      program[program[instructionPointer + 3]] = first * second
      instructionPointer += 4
    }

    else if instruction == 3 {
      program[program[instructionPointer + 1]] = input
      instructionPointer += 2
    }

    else if instruction == 4 {
      // gotcha
      let firstMode = getParameterMode(for: .first, value)
      let first = getValue(for: instructionPointer + 1, with: firstMode, program)

      output = first
      instructionPointer += 2
    }

    else if instruction == 5 {
      let firstMode = getParameterMode(for: .first, value)
      let secondMode = getParameterMode(for: .second, value)

      let first = getValue(for: instructionPointer + 1, with: firstMode, program)
      let second = getValue(for: instructionPointer + 2, with: secondMode, program)

      if first == 0 {
        instructionPointer += 3
      } else {
        instructionPointer = second
      }
    }

    else if instruction == 6 {
      let firstMode = getParameterMode(for: .first, value)
      let secondMode = getParameterMode(for: .second, value)

      let first = getValue(for: instructionPointer + 1, with: firstMode, program)
      let second = getValue(for: instructionPointer + 2, with: secondMode, program)

      if first == 0 {
        instructionPointer = second
      } else {
        instructionPointer += 3
      }
    }

    else if instruction == 7 {
      let firstMode = getParameterMode(for: .first, value)
      let secondMode = getParameterMode(for: .second, value)

      let first = getValue(for: instructionPointer + 1, with: firstMode, program)
      let second = getValue(for: instructionPointer + 2, with: secondMode, program)

      let valueToStore = first < second ? 1 : 0
      program[program[instructionPointer + 3]] = valueToStore
      instructionPointer += 4
    }

    else if instruction == 8 {
      let firstMode = getParameterMode(for: .first, value)
      let secondMode = getParameterMode(for: .second, value)

      let first = getValue(for: instructionPointer + 1, with: firstMode, program)
      let second = getValue(for: instructionPointer + 2, with: secondMode, program)

      let valueToStore = first == second ? 1 : 0
      program[program[instructionPointer + 3]] = valueToStore
      instructionPointer += 4
    }
  }

  print(program)
  return output
}

// Part 1
var test1 = [1002,4,3,4,33] // last value should be 99
var test2 = [1101,100,-1,4,0] // last value should be 99
var test3 = [3,0,4,0,99]
var puzzle1 = [3,225,1,225,6,6,1100,1,238,225,104,0,1102,9,19,225,1,136,139,224,101,-17,224,224,4,224,102,8,223,223,101,6,224,224,1,223,224,223,2,218,213,224,1001,224,-4560,224,4,224,102,8,223,223,1001,224,4,224,1,223,224,223,1102,25,63,224,101,-1575,224,224,4,224,102,8,223,223,1001,224,4,224,1,223,224,223,1102,55,31,225,1101,38,15,225,1001,13,88,224,1001,224,-97,224,4,224,102,8,223,223,101,5,224,224,1,224,223,223,1002,87,88,224,101,-3344,224,224,4,224,102,8,223,223,1001,224,7,224,1,224,223,223,1102,39,10,225,1102,7,70,225,1101,19,47,224,101,-66,224,224,4,224,1002,223,8,223,1001,224,6,224,1,224,223,223,1102,49,72,225,102,77,166,224,101,-5544,224,224,4,224,102,8,223,223,1001,224,4,224,1,223,224,223,101,32,83,224,101,-87,224,224,4,224,102,8,223,223,1001,224,3,224,1,224,223,223,1101,80,5,225,1101,47,57,225,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1008,677,226,224,1002,223,2,223,1005,224,329,1001,223,1,223,107,226,677,224,1002,223,2,223,1006,224,344,101,1,223,223,1007,677,677,224,1002,223,2,223,1006,224,359,1001,223,1,223,8,677,226,224,102,2,223,223,1005,224,374,101,1,223,223,108,226,677,224,102,2,223,223,1006,224,389,1001,223,1,223,1008,677,677,224,1002,223,2,223,1006,224,404,1001,223,1,223,1107,677,677,224,102,2,223,223,1005,224,419,1001,223,1,223,1008,226,226,224,102,2,223,223,1005,224,434,101,1,223,223,8,226,677,224,1002,223,2,223,1006,224,449,101,1,223,223,1007,677,226,224,102,2,223,223,1005,224,464,1001,223,1,223,107,677,677,224,1002,223,2,223,1005,224,479,1001,223,1,223,1107,226,677,224,1002,223,2,223,1005,224,494,1001,223,1,223,7,677,677,224,102,2,223,223,1006,224,509,101,1,223,223,1007,226,226,224,1002,223,2,223,1005,224,524,101,1,223,223,7,677,226,224,102,2,223,223,1005,224,539,101,1,223,223,8,226,226,224,1002,223,2,223,1006,224,554,101,1,223,223,7,226,677,224,102,2,223,223,1005,224,569,101,1,223,223,1108,677,226,224,1002,223,2,223,1005,224,584,101,1,223,223,108,677,677,224,1002,223,2,223,1006,224,599,101,1,223,223,107,226,226,224,1002,223,2,223,1006,224,614,101,1,223,223,1108,226,226,224,1002,223,2,223,1005,224,629,1001,223,1,223,1107,677,226,224,1002,223,2,223,1005,224,644,101,1,223,223,108,226,226,224,1002,223,2,223,1005,224,659,101,1,223,223,1108,226,677,224,1002,223,2,223,1005,224,674,1001,223,1,223,4,223,99,226]

runProgram(program: &test1, input: 1)
runProgram(program: &test2, input: 1)
runProgram(program: &test3, input: 1)
runProgram(program: &puzzle1, input: 1)

// Part 2
var test4 = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]
var test5 = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1]

var puzzle2 = [3,225,1,225,6,6,1100,1,238,225,104,0,1102,9,19,225,1,136,139,224,101,-17,224,224,4,224,102,8,223,223,101,6,224,224,1,223,224,223,2,218,213,224,1001,224,-4560,224,4,224,102,8,223,223,1001,224,4,224,1,223,224,223,1102,25,63,224,101,-1575,224,224,4,224,102,8,223,223,1001,224,4,224,1,223,224,223,1102,55,31,225,1101,38,15,225,1001,13,88,224,1001,224,-97,224,4,224,102,8,223,223,101,5,224,224,1,224,223,223,1002,87,88,224,101,-3344,224,224,4,224,102,8,223,223,1001,224,7,224,1,224,223,223,1102,39,10,225,1102,7,70,225,1101,19,47,224,101,-66,224,224,4,224,1002,223,8,223,1001,224,6,224,1,224,223,223,1102,49,72,225,102,77,166,224,101,-5544,224,224,4,224,102,8,223,223,1001,224,4,224,1,223,224,223,101,32,83,224,101,-87,224,224,4,224,102,8,223,223,1001,224,3,224,1,224,223,223,1101,80,5,225,1101,47,57,225,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1008,677,226,224,1002,223,2,223,1005,224,329,1001,223,1,223,107,226,677,224,1002,223,2,223,1006,224,344,101,1,223,223,1007,677,677,224,1002,223,2,223,1006,224,359,1001,223,1,223,8,677,226,224,102,2,223,223,1005,224,374,101,1,223,223,108,226,677,224,102,2,223,223,1006,224,389,1001,223,1,223,1008,677,677,224,1002,223,2,223,1006,224,404,1001,223,1,223,1107,677,677,224,102,2,223,223,1005,224,419,1001,223,1,223,1008,226,226,224,102,2,223,223,1005,224,434,101,1,223,223,8,226,677,224,1002,223,2,223,1006,224,449,101,1,223,223,1007,677,226,224,102,2,223,223,1005,224,464,1001,223,1,223,107,677,677,224,1002,223,2,223,1005,224,479,1001,223,1,223,1107,226,677,224,1002,223,2,223,1005,224,494,1001,223,1,223,7,677,677,224,102,2,223,223,1006,224,509,101,1,223,223,1007,226,226,224,1002,223,2,223,1005,224,524,101,1,223,223,7,677,226,224,102,2,223,223,1005,224,539,101,1,223,223,8,226,226,224,1002,223,2,223,1006,224,554,101,1,223,223,7,226,677,224,102,2,223,223,1005,224,569,101,1,223,223,1108,677,226,224,1002,223,2,223,1005,224,584,101,1,223,223,108,677,677,224,1002,223,2,223,1006,224,599,101,1,223,223,107,226,226,224,1002,223,2,223,1006,224,614,101,1,223,223,1108,226,226,224,1002,223,2,223,1005,224,629,1001,223,1,223,1107,677,226,224,1002,223,2,223,1005,224,644,101,1,223,223,108,226,226,224,1002,223,2,223,1005,224,659,101,1,223,223,1108,226,677,224,1002,223,2,223,1005,224,674,1001,223,1,223,4,223,99,226]
runProgram(program: &test4, input: 0)
runProgram(program: &test4, input: 1)
runProgram(program: &test5, input: 0)
runProgram(program: &test5, input: 1)
runProgram(program: &puzzle2, input: 5)
