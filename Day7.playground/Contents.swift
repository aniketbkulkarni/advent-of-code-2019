struct ProgramVM {

  private enum Mode {
    case position
    case immediate
  }

  private enum Position {
    case first
    case second
  }

  var output = [Int]()
  private var program = [Int]()
  private(set) var finished = false

  private var instructionPointer = 0

  init(_ program: [Int]) {
    self.program = program
  }

  mutating func runProgram(_ inputs: [Int]) {
    var mutableInputs = inputs

    while instructionPointer < program.count {
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
        if mutableInputs.isEmpty {
          return
        } else {
          program[program[instructionPointer + 1]] = mutableInputs.removeFirst()
          instructionPointer += 2
        }
      }

      else if instruction == 4 {
        let firstMode = getParameterMode(for: .first, value)
        let first = getValue(for: instructionPointer + 1, with: firstMode, program)

        output.append(first)
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

      else if instruction == 99 {
        finished = true
        return
      }

      else {
        fatalError("Invalid instruction: \(instruction) with pointer \(instructionPointer)")
      }
    }
  }

  private func getParameterMode(for position: Position, _ value: Int) -> Mode {
    switch position {
    case .first:
      let firstValue = (value / 100) % 10
      return firstValue == 0 ? .position : .immediate
    case .second:
      let secondValue = value / 1000
      return secondValue == 0 ? .position : .immediate
    }
  }

  private func getValue(for index: Int, with mode: Mode, _ program: [Int]) -> Int {
    switch mode {
    case .immediate:
      return program[index]
    case .position:
      return program[program[index]]
    }
  }
}

// Helper functions
func generateSequencePermutations(possibleValues: [Int]) -> [[Int]] {
  var permutations = [[Int]]()
  let seenValues = [Bool](repeating: false, count: possibleValues.count)

  backtrack(permutations: &permutations, possibleValues: possibleValues, seenValues: seenValues, currentPermutation: [])

  return permutations
}

func backtrack(permutations: inout [[Int]], possibleValues: [Int], seenValues: [Bool], currentPermutation: [Int]) {
  // We have chosen all possible values for the current permutation
  if currentPermutation.count == possibleValues.count {
    permutations.append(currentPermutation)
  } else {
    // Create a new permutation by adding the current number at every position
    for (index, value) in possibleValues.enumerated() {
      if seenValues[index] {
        continue
      }

      var nextPermutation = currentPermutation
      nextPermutation.append(value)

      var nextSeenValues = seenValues
      nextSeenValues[index] = true

      backtrack(permutations: &permutations, possibleValues: possibleValues, seenValues: nextSeenValues, currentPermutation: nextPermutation)
    }
  }
}

func solvePartOne(sequences: [[Int]], input: [Int]) -> Int {
  var maxSignal = 0

  for sequence in sequences {
    var previousOutput = 0

    for value in sequence {
      var program = ProgramVM(input)
      program.runProgram([value, previousOutput])
      previousOutput = program.output.last!
    }

    maxSignal = max(maxSignal, previousOutput)
  }

  return maxSignal
}

func solvePartTwo(sequences: [[Int]], input: [Int]) -> Int {
  var maxSignal = 0

  for sequence in sequences {
    var a = ProgramVM(input)
    var b = ProgramVM(input)
    var c = ProgramVM(input)
    var d = ProgramVM(input)
    var e = ProgramVM(input)

    var firstRun = true

    while !e.finished {
      a.runProgram(firstRun ? [sequence[0], 0]: [e.output.last!])
      b.runProgram(firstRun ? [sequence[1], a.output.last!]: [a.output.last!])
      c.runProgram(firstRun ? [sequence[2], b.output.last!]: [b.output.last!])
      d.runProgram(firstRun ? [sequence[3], c.output.last!]: [c.output.last!])
      e.runProgram(firstRun ? [sequence[4], d.output.last!]: [d.output.last!])

      firstRun = false
    }
    maxSignal = max(maxSignal, e.output.last!)
  }

  return maxSignal
}


let part1Sequences = generateSequencePermutations(possibleValues: [0, 1, 2, 3, 4])
let part2Sequences = generateSequencePermutations(possibleValues: [5, 6, 7, 8, 9])

let puzzle = [3,8,1001,8,10,8,105,1,0,0,21,34,59,68,85,102,183,264,345,426,99999,3,9,101,3,9,9,102,3,9,9,4,9,99,3,9,1002,9,4,9,1001,9,2,9,1002,9,2,9,101,5,9,9,102,5,9,9,4,9,99,3,9,1001,9,4,9,4,9,99,3,9,101,3,9,9,1002,9,2,9,1001,9,5,9,4,9,99,3,9,1002,9,3,9,1001,9,5,9,102,3,9,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,99]
solvePartOne(sequences: part1Sequences, input: puzzle)
solvePartTwo(sequences: part2Sequences, input: puzzle)

solvePartTwo(sequences: [[9,8,7,6,5]], input: [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5])
solvePartTwo(sequences: [[9,7,8,5,6]], input: [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10])
