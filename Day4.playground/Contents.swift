func isPasswordValid(_ password: Int) -> Bool {

  // Increasing sequence
  var lastDigit = password % 10
  var remainingPassword = password / 10

  while remainingPassword > 0 {
    let currDigit = remainingPassword % 10

    if currDigit > lastDigit {
      // Found decreasing subsequence
      return false
    } else {
      lastDigit = currDigit
      remainingPassword /= 10
    }
  }

  // Adjacent same
  let digits = Array(String(password))
  var prev = digits[0]

  for i in 1..<digits.count {
    if prev == digits[i] {
      // Found two identical adjacent digits
      return true
    } else {
      prev = digits[i]
    }
  }

  // None
  return false
}

isPasswordValid(111111)
isPasswordValid(223450)
isPasswordValid(123789)


func isPasswordValidPart2(_ password: Int) -> Bool {

  // Increasing sequence
  var lastDigit = password % 10
  var remainingPassword = password / 10

  while remainingPassword > 0 {
    let currDigit = remainingPassword % 10

    if currDigit > lastDigit {
      // Found decreasing subsequence
      return false
    } else {
      lastDigit = currDigit
      remainingPassword /= 10
    }
  }

  // Adjacent same
  let digits = Array(String(password))
  var digitDict = [Character: Int]()

  for digit in digits {
    if let count = digitDict[digit] {
      digitDict[digit] = count + 1
    } else {
      digitDict[digit] = 1
    }
  }

  for (_, value) in digitDict {
    if value == 2 {
      return true
    }
  }

  // None
  return false
}

isPasswordValidPart2(112233)
isPasswordValidPart2(123444)
isPasswordValidPart2(111122)

var matchCount = 0

for i in 147981...691423 {
  if isPasswordValidPart2(i) {
    matchCount += 1
  }
}

matchCount
