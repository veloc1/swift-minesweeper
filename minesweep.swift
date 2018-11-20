func printGreeting() {
  print("Hello there!")
  print("It's an minesweeper game in 10x10 field.")
  print("Type \"open x y\" to open a cell.")
  print("Type \"quit\" to close this app")
}

class Cell {
  var value = "#"
  var isBomb = false
}

class Field {
  let width = 10
  let height = 10
  let bombsCount = 10
  var cells = [[Cell]]()

  init() {
    for i in 0...height {
      cells.append([])
      for _ in 0...width {
        cells[i].append(Cell())
      }
    }
    for i in 0...bombsCount {
      var x = Int.random(in: 0 ... width)
      var y = Int.random(in: 0 ... height)
      cells[x][y].isBomb = true
    }
  }
  
  func open(x: Int, y: Int) {
    print("You opened \(x):\(y)")
    if cells[x][y].isBomb {
      cells[x][y].value = "B"
      print("Game over. Type \"restart\" to play again")
    } else {
      cells[x][y].value = String(getBombsCountInAdjacentCells(x: x, y: y))
    }
  }

  func getBombsCountInAdjacentCells(x: Int, y: Int) -> Int {
    var bombsCount = 0
    for x1 in x - 1 ... x + 1 {
      for y1 in y - 1 ... y + 1 {
        if cells[x1][y1].isBomb {
          bombsCount += 1
        }
      }
    }
    return bombsCount
  }

  func display() {
    for i in -1...width {
      print(i, terminator: " ")
    }
    print()
    for y in 0...height {
      print(y, terminator: " ")

      for x in 0...width {
        print(cells[x][y].value, terminator: " ")
      }
      print()
    }
  }

}

enum Command {
  case quit
  case open(x: Int, y: Int)
  case restart
  case unhandled

  init(command: String) {
    switch command {
    case "quit":
      self = .quit
    case "restart":
      self = .restart
    default:
      let comp = command.split(separator: " ")
      if comp.count > 2 && comp[0] == "open" {
        self = .open(x: Int(comp[1])!, y: Int(comp[2])!)
      } else {
        self = .unhandled
      }
    }
  } 
}

func main() {
  printGreeting()

  var field = Field()
  var command: String? = nil
  var parsedCommand: Command = .restart
  var quit = false
  repeat {
    command = readLine()
    parsedCommand = Command(command: command!)
    
    // clear screen
    print("\u{001B}[2J") 
        
    switch parsedCommand {
    case .quit:
      quit = true
    case .restart:
      print("You restarted the game")
      field = Field()
    case .open(let x, let y):
      field.open(x: x, y: y)
    default:
      print("Cannot handle that command")
    }
    
    field.display()

  } while !quit
  
  print("Bye!")
}

main()
