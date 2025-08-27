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
            }
        }
    }
}

class Room
{
    init(roomName: String, connectedRooms: Array<Room>, itemsInRoom: Array<Item>, challenge: Challenge)
    {
        self.connectedRooms = connectedRooms;
        self.itemsInRoom = itemsInRoom;
        self.challengeInRoom = challenge
        self.roomName = roomName;
    }
    var roomName:String
    var connectedRooms: Array<Room>
    var itemsInRoom: Array<Item>
    var challengeInRoom: Challenge
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
        let command = splitCommand[0]
        switch command
        {
        case "go":
            print("going up")
            inputValid = true
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


//Main Body
var gameOver = false

while(!gameOver)
{
    ParsePlayerCommand()
}
