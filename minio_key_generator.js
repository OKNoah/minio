const crypto = require('crypto')

function rando () {
  var key = []

  while (key.length < 20) {
    var byte = crypto.randomBytes(1)
    var byteAsDec = parseInt(byte.toString('hex'), 10)
    if ((byteAsDec > 48 && byteAsDec < 57) || (byteAsDec > 65 && byteAsDec < 90)) {
      key.push(String.fromCharCode(byteAsDec))
    }
  }

  return key.join('')
}

function randoLong () {
  var key = []

  while (key.length < 40) {
    var byte = crypto.randomBytes(2)
    var byteAsDec = parseInt(byte.toString('hex'), 10) % 127
    if ((byteAsDec > 48 && byteAsDec < 57) || (byteAsDec > 65 && byteAsDec < 90) || (byteAsDec > 97 && byteAsDec < 122)) {
      key.push(String.fromCharCode(byteAsDec))
    }
  }

  return key.join('')
}

console.log(rando())
console.log(randoLong())