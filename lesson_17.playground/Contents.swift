import Foundation

let mySql = DataSourceFabric.create(type: .MsSql)
mySql.getAll()

let game = Game()
let player = game.createPlayer()

var logManager = LogManager.shared
logManager.log("log1")
logManager.log("log2")
logManager.getLogs()

let math = MathAdapter(math: Math())
math.sqrt(a: 8)

let playerOperations = PlayerOperations(player: Player())
playerOperations.move()
playerOperations.stop()

let array = [-2, 10, -1, 0, 2, 4, 1]
let sortPerformer = SortPerformer(strategy: SortByDescStrategy())
sortPerformer.sort(in: array)

let animals = Animals()
animals.add(Bird())
animals.add(Dog())
animals.move(to: CGPoint(x: 10, y: 5))

let factoryFacade = FactoryFacade()
factoryFacade.produceCar()


let caretaker = Caretaker()
caretaker.memento = Memento(state: "save1")

let originator = Originator()
originator.setMemento(memento: caretaker.memento!)

caretaker.memento = Memento(state: "save2")

caretaker.memento = originator.restoreMemento()
caretaker.memento!.state

let client = Client()
client.test()

let notification = Notification()
notification.email()
