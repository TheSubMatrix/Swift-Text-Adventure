import Foundation
class Inventory
{
    init()
    {
        self.items = Array<Item>()
    }
    var items: Array<Item>
    func CheckForItem(itemToCheckFor: Item) -> Bool
    {
        if(items.contains(itemToCheckFor))
        {
            return true;
        }
        return false;
    }
    func AddToInventory(itemToAdd: Item)
    {
        if(items.contains(itemToAdd)) {return;}
        items.append(itemToAdd)
    }
    func RemoveFromInventory(itemToRemove: Item)
    {
        for i in 0...items.count
        {
            if(items[i] == itemToRemove)
            {
                items.remove(at: i)
                break;
            }
        }
    }
    func CheckInventoryWinCondition(itemsToWin: Array<Item>) -> Bool
    {
        var result = true;
        for i in itemsToWin
        {
            if !items.contains(i)
            {
                result = false;
            }
        }
        return result;
    }
}

class Room
{
    init(roomName: String, connectedRooms: Array<Room>, itemsInRoom: Array<Item>, challenge: Challenge?)
    {
        self.connectedRooms = connectedRooms;
        self.itemsInRoom = itemsInRoom;
        self.challengeInRoom = challenge
        self.roomName = roomName;
    }
    var roomName:String
    var connectedRooms: Array<Room>
    var itemsInRoom: Array<Item>
    var challengeInRoom: Challenge?
}
struct Challenge
{
    var reward: Item
    var requiredItem: Item
    var successFlavorText: String
    var failFlavorText: String
}

func ParsePlayerCommand()
{
    var inputValid = false
    while inputValid == false
    {
        let userCommand = readLine()
        let splitCommand: Array<String> = (userCommand?.components(separatedBy: " "))!
        let command = splitCommand[0].lowercased()
        var splitCommandParams = Array<String>(splitCommand)
        splitCommandParams.removeFirst()
        let commandParams = splitCommandParams.joined()
        switch command
        {
        case "go":
            if(TravelCommand(playerInput: commandParams))
            {
                print("Traveled to " + commandParams)
                inputValid = true
            }
            else
            {
                print("Not a valid location")
            }
        case "pickup":
            if PickupCommand(playerInput: commandParams)
            {
                print("Picked up " + commandParams)
                inputValid = true
            }
            else
            {
                print("Not a valid item")
            }
        case "inventory":
            InventoryCommand()
        default:
            print("Invalid command, please try again")
        }
    }
    
}
struct Item: Equatable
{
    init(name: String)
    {
        self.name = name
    }
    var name:String
}

func TravelCommand(playerInput: String) -> Bool
{
    if let roomToTravelTo = currentRoom.connectedRooms.first(where: {(s1: Room) -> Bool in return playerInput != "" && s1.roomName.lowercased() == playerInput.lowercased()})
    {
        currentRoom = roomToTravelTo;
        return true;
    }
    return false;
}
func PickupCommand(playerInput: String) -> Bool
{
    if let itemToPickup = currentRoom.itemsInRoom.first(where: {(s1: Item) -> Bool in return playerInput != "" && s1.name.lowercased() == playerInput.lowercased()})
    {
        playerInventory.AddToInventory(itemToAdd: itemToPickup)
        if playerInventory.items.count == 0 {return false;}
        for i in 0...currentRoom.itemsInRoom.count-1
        {
            if(currentRoom.itemsInRoom[i] == itemToPickup)
            {
                currentRoom.itemsInRoom.remove(at: i)
                break;
            }
        }
        return true;
    }
    return false;
}

func InventoryCommand()
{
    if(playerInventory.items.count > 0)
    {
        for i in 0...playerInventory.items.count-1
        {
            var suffix = ", "
            if(i >= playerInventory.items.count-1)
            {
                suffix = ""
            }
            print(playerInventory.items[i].name + suffix , terminator: "")
        }
        print("")
    }else
    {
        print("Empty")
    }
}

func PrintCurrentGameState()
{
    print("You are at the " + currentRoom.roomName + ".")
    print("You see ", terminator: "")
    if(currentRoom.itemsInRoom.count > 0)
    {
        for i in 0...currentRoom.itemsInRoom.count-1
        {
            var suffix = ", "
            if(i >= currentRoom.itemsInRoom.count-1)
            {
                suffix = ""
            }
            print(currentRoom.itemsInRoom[i].name + suffix , terminator: "")
        }
        print("")
    }
    else
    {
        print("nothing")
    }
    print("You can go to ", terminator: "")
    for i in 0...currentRoom.connectedRooms.count-1
    {
        var suffix = ", "
        if(i >= currentRoom.connectedRooms.count-1)
        {
            suffix = ""
        }
        print(currentRoom.connectedRooms[i].roomName + suffix, terminator: "")
    }
    print("")
    
}

//======Main Body======
var gameOver = false
var playerInventory = Inventory()

var crown = Item(name: "Crown")
var bracelet = Item(name: "Bracelet")
var necklace = Item(name: "Necklace")
var ring = Item(name: "Ring")
var earrings = Item(name: "Earrings")

var startingRoom = Room(roomName: "Entrance", connectedRooms: Array<Room>(), itemsInRoom: Array<Item>(), challenge: nil)
var northRoom = Room(roomName: "North", connectedRooms: Array<Room>(), itemsInRoom: Array<Item>(), challenge: nil)
var southRoom = Room(roomName: "South", connectedRooms: Array<Room>(), itemsInRoom: Array<Item>(), challenge: nil)
var eastRoom = Room(roomName: "East", connectedRooms: Array<Room>(), itemsInRoom: Array<Item>(), challenge: nil)
var westRoom = Room(roomName: "West", connectedRooms: Array<Room>(), itemsInRoom: Array<Item>(), challenge: nil)

northRoom.connectedRooms.append(startingRoom)
southRoom.connectedRooms.append(startingRoom)
eastRoom.connectedRooms.append(startingRoom)
westRoom.connectedRooms.append(startingRoom)
startingRoom.connectedRooms.append(northRoom)
startingRoom.connectedRooms.append(southRoom)
startingRoom.connectedRooms.append(eastRoom)
startingRoom.connectedRooms.append(westRoom)

startingRoom.itemsInRoom.append(crown)
northRoom.itemsInRoom.append(bracelet)
southRoom.itemsInRoom.append(necklace)
eastRoom.itemsInRoom.append(ring)
westRoom.itemsInRoom.append(earrings)

var currentRoom = startingRoom
while(!gameOver)
{
    PrintCurrentGameState()
    ParsePlayerCommand()
    if(playerInventory.CheckInventoryWinCondition(itemsToWin: [crown, bracelet, necklace, ring, earrings]))
    {
        print("You win!")
        gameOver = true
    }
}
