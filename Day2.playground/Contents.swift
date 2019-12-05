func runProgram(program: [Int]) -> [Int] {
  var mutableProgram = program

  for opcodeIndex in stride(from: 0, to: program.count, by: 4) {
    let opcode = mutableProgram[opcodeIndex]

    if opcode == 99 {
      break
    }

    let first = mutableProgram[mutableProgram[opcodeIndex + 1]]
    let second = mutableProgram[mutableProgram[opcodeIndex + 2]]
    let outputIndex = mutableProgram[opcodeIndex + 3]
    if opcode == 1 {
      mutableProgram[outputIndex] = first + second
    }
    else if opcode == 2 {
      mutableProgram[outputIndex] = first * second
    }
  }
  return mutableProgram
}

runProgram(program: [1,9,10,3,2,3,11,0,99,30,40,50]) == [3500,9,10,70,2,3,11,0,99,30,40,50]
runProgram(program: [1,0,0,0,99]) == [2,0,0,0,99]
runProgram(program: [2,3,0,3,99]) == [2,3,0,6,99]
runProgram(program: [2,4,4,5,99,0]) == [2,4,4,5,99,9801]
runProgram(program: [1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99]

runProgram(program: [1,5,6,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,9,19,1,5,19,23,1,6,23,27,1,27,10,31,1,31,5,35,2,10,35,39,1,9,39,43,1,43,5,47,1,47,6,51,2,51,6,55,1,13,55,59,2,6,59,63,1,63,5,67,2,10,67,71,1,9,71,75,1,75,13,79,1,10,79,83,2,83,13,87,1,87,6,91,1,5,91,95,2,95,9,99,1,5,99,103,1,103,6,107,2,107,13,111,1,111,10,115,2,10,115,119,1,9,119,123,1,123,9,127,1,13,127,131,2,10,131,135,1,135,5,139,1,2,139,143,1,143,5,0,99,2,0,14,0])

var input = [1,5,6,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,9,19,1,5,19,23,1,6,23,27,1,27,10,31,1,31,5,35,2,10,35,39,1,9,39,43,1,43,5,47,1,47,6,51,2,51,6,55,1,13,55,59,2,6,59,63,1,63,5,67,2,10,67,71,1,9,71,75,1,75,13,79,1,10,79,83,2,83,13,87,1,87,6,91,1,5,91,95,2,95,9,99,1,5,99,103,1,103,6,107,2,107,13,111,1,111,10,115,2,10,115,119,1,9,119,123,1,123,9,127,1,13,127,131,2,10,131,135,1,135,5,139,1,2,139,143,1,143,5,0,99,2,0,14,0]

outerLoop: for i in 0...99 {
  for j in 0...99 {
    input[1] = i
    input[2] = j
    if runProgram(program: input)[0] == 19690720 {
      print(100 * i + j)
      break outerLoop
    }
  }
}
