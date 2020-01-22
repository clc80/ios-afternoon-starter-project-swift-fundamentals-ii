import UIKit


//: ## 1. Create custom types to represent an Airport Departures display
//: ![Airport Departures](matthew-smith-5934-unsplash.jpg)
//: Look at data from [Departures at JFK Airport in NYC](https://www.airport-jfk.com/departures.php) for reference.
//:
//: a. Use an `enum` type for the FlightStatus (En Route, Scheduled, Canceled, Delayed, etc.)
//:
//: b. Use a struct to represent an `Airport` (Destination or Arrival)
//:
//: c. Use a struct to represent a `Flight`.
//:
//: d. Use a `Date?` for the departure time since it may be canceled.
//:
//: e. Use a `String?` for the Terminal, since it may not be set yet (i.e.: waiting to arrive on time)
//:
//: f. Use a class to represent a `DepartureBoard` with a list of departure flights, and the current airport
enum FlightStatus: String {
    case enRoute
    case enRouteOnTime = "enRoute - on time"
    case enRouteDelayed = "enRoute - delayed"
    case landedDelayed = "landed - delayed"
    case landedOntime = "landed - on time"
    case delayed
    case canceled
    case diverted
    case scheduled
    case boarding
}

struct Airport {
    var name: String
    var identifier: String
}

struct Flight {
    var airline: String
    var flightNumber: Int
    var departureAirport: Airport
    var departureTerminal: Int?
    var departureGate: String?
    var departureDate: Date?
    var departureTime: String?
    var arrivalAirport: Airport
    var arrivalTerminal: Int?
    var arrivalGate: String?
    var arrivalDate: Date?
    var arrivalTime: String?
    var status: FlightStatus
}

class DepartureBoard {
    var airport: Airport
    var flights: [Flight]
    
    init(airport: Airport ) {
        self.airport = airport
        flights = []
    }
    func flightStatus() {
        for flight in flights {
            switch flight.status {
            case .enRoute, .enRouteOnTime:
                if let arrivalTime = flight.arrivalTime{
                    print("Your flight is en route and is estimated to arrive at \(arrivalTime)")
                } else {
                    print("Your flight is en route we will update the time as soon as it becomes available")
                }
            case .boarding:
                if let departureTerminal = flight.departureTerminal {
                    print("Your flight is boarding, please head to terminal: \(departureTerminal) immediately. The doors are closing soon.")
                } else {
                    print("Your flight is boarding, please head to the nearest agent for help.")
                }
            case .enRouteDelayed:
                print("Your flight is en route, but delayed")
            case .landedDelayed, .landedOntime:
                print("Your plane has landed")
            case .delayed:
                print("Your flight is delayed at \(flight.departureAirport.name)")
            case .canceled:
                print("We're sorry your flight to \(flight.arrivalAirport.name) was canceled, here is a $500 voucher")
            case .diverted:
                print("Your flight has been diverted, we will update you soon")
            case .scheduled:
                if let departureTime = flight.departureTime, let departureTerminal = flight.departureTerminal{
                    print("Your flight to \(flight.arrivalAirport.name) is scheduled to depart at \(departureTime) from terminal: \(departureTerminal)")
                } else {
                    print("Your flight to \(flight.arrivalAirport.name) is scheduled to depart. Check back for updates on time and terminal.")
                }
            }
        }
    }
}
//: ## 2. Create 3 flights and add them to a departure board
//: a. For the departure time, use `Date()` for the current time
//:
//: b. Use the Array `append()` method to add `Flight`'s
//:
//: c. Make one of the flights `.canceled` with a `nil` departure time
//:
//: d. Make one of the flights have a `nil` terminal because it has not been decided yet.
//:
//: e. Stretch: Look at the API for [`DateComponents`](https://developer.apple.com/documentation/foundation/datecomponents?language=objc) for creating a specific time
//Create Airports
let sanFrancisco = Airport(name: "San Francisco", identifier: "KSFO")
let atlanta = Airport(name: "Atlanta", identifier: "KATL")
let boston = Airport(name: "Boston", identifier: "KBOS")
let losAngeles = Airport(name: "Los Angeles", identifier: "KLAX")

//create Flights
let sanFranciscoToAtlantaFlight = Flight(airline: "Delta", flightNumber: 1210, departureAirport: sanFrancisco, departureTerminal: nil, departureGate: nil, departureDate: Date(), departureTime: nil, arrivalAirport: atlanta, arrivalTerminal: nil, arrivalGate: nil, arrivalDate: nil, arrivalTime: nil, status: FlightStatus.canceled)
let sanFranciscoToBostonFlight = Flight(airline: "Alaska", flightNumber: 1352, departureAirport: sanFrancisco, departureTerminal: 2, departureGate: "D2", departureDate: Date(), departureTime: "7:00 AM", arrivalAirport: boston, arrivalTerminal: 1, arrivalGate: nil, arrivalDate: Date(), arrivalTime: "13:15 PM", status: FlightStatus.landedOntime)
let sanFranciscoToLosAngelesFlight = Flight(airline: "American Airlines", flightNumber: 890, departureAirport: sanFrancisco, departureTerminal: 2, departureGate: "D15", departureDate: nil, departureTime: nil, arrivalAirport: losAngeles, arrivalTerminal: nil, arrivalGate: nil, arrivalDate: nil, arrivalTime: nil, status: FlightStatus.delayed)

//Add departure flights for sanFrancisco
let sanFranciscoDepartureBoard = DepartureBoard(airport: sanFrancisco)
sanFranciscoDepartureBoard.flights.append(sanFranciscoToAtlantaFlight)
sanFranciscoDepartureBoard.flights.append(sanFranciscoToBostonFlight)
sanFranciscoDepartureBoard.flights.append(sanFranciscoToLosAngelesFlight)
//: ## 3. Create a free-standing function that can print the flight information from the `DepartureBoard`
//: a. Use the function signature: `printDepartures(departureBoard:)`
//:
//: b. Use a `for in` loop to iterate over each departure
//:
//: c. Make your `FlightStatus` enum conform to `String` so you can print the `rawValue` String values from the `enum`. See the [enum documentation](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html).
//:
//: d. Print out the current DepartureBoard you created using the function
func printDepartures(departureBoard: DepartureBoard) {
    for flight in departureBoard.flights {
        print(flight)
    }
}

printDepartures(departureBoard: sanFranciscoDepartureBoard)
//: ## 4. Make a second function to print print an empty string if the `departureTime` is nil
//: a. Createa new `printDepartures2(departureBoard:)` or modify the previous function
//:
//: b. Use optional binding to unwrap any optional values, use string interpolation to turn a non-optional date into a String
//:
//: c. Call the new or udpated function. It should not print `Optional(2019-05-30 17:09:20 +0000)` for departureTime or for the Terminal.
//:
//: d. Stretch: Format the time string so it displays only the time using a [`DateFormatter`](https://developer.apple.com/documentation/foundation/dateformatter) look at the `dateStyle` (none), `timeStyle` (short) and the `string(from:)` method
//:
//: e. Your output should look like:
//:
//:     Destination: Los Angeles Airline: Delta Air Lines Flight: KL 6966 Departure Time:  Terminal: 4 Status: Canceled
//:     Destination: Rochester Airline: Jet Blue Airways Flight: B6 586 Departure Time: 1:26 PM Terminal:  Status: Scheduled
//:     Destination: Boston Airline: KLM Flight: KL 6966 Departure Time: 1:26 PM Terminal: 4 Status: Scheduled
func printDepartures2(departureBoard: DepartureBoard) {
    for flight in departureBoard.flights {
        if let departureTime = flight.departureTime, let departureTerminal = flight.departureTerminal {
            print("Destination: \(flight.arrivalAirport.name) - Airline: \(flight.airline) - Flight: \(flight.flightNumber) - Departure Time: \(departureTime) - Terminal: \(departureTerminal) - Status: \(flight.status.rawValue)")
        } else {
            print ("Your flight is \(flight.status.rawValue)")
        }
    }
}

printDepartures2(departureBoard: sanFranciscoDepartureBoard)
//: ## 5. Add an instance method to your `DepatureBoard` class (above) that can send an alert message to all passengers about their upcoming flight. Loop through the flights and use a `switch` on the flight status variable.
//: a. If the flight is canceled print out: "We're sorry your flight to \(city) was canceled, here is a $500 voucher"
//:
//: b. If the flight is scheduled print out: "Your flight to \(city) is scheduled to depart at \(time) from terminal: \(terminal)"
//:
//: c. If their flight is boarding print out: "Your flight is boarding, please head to terminal: \(terminal) immediately. The doors are closing soon."
//:
//: d. If the `departureTime` or `terminal` are optional, use "TBD" instead of a blank String
//:
//: e. If you have any other cases to handle please print out appropriate messages
//:
//: d. Call the `alertPassengers()` function on your `DepartureBoard` object below
//:
//: f. Stretch: Display a custom message if the `terminal` is `nil`, tell the traveler to see the nearest information desk for more details.
sanFranciscoDepartureBoard.flightStatus()

//: ## 6. Create a free-standing function to calculate your total airfair for checked bags and destination
//: Use the method signature, and return the airfare as a `Double`
//:
//:     func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> Double {
//:     }
//:
//: a. Each bag costs $25
//:
//: b. Each mile costs $0.10
//:
//: c. Multiply the ticket cost by the number of travelers
//:
//: d. Call the function with a variety of inputs (2 bags, 2000 miles, 3 travelers = $750)
//:
//: e. Make sure to cast the numbers to the appropriate types so you calculate the correct airfare
//:
//: f. Stretch: Use a [`NumberFormatter`](https://developer.apple.com/documentation/foundation/numberformatter) with the `currencyStyle` to format the amount in US dollars.
func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> Double {
    let bagCost = Double(checkedBags * 25)
    let miles = Double(distance) * 0.10
    let cost = Double(travelers) * bagCost + miles
    
    //trying to use number formatter but it does it as a string not a double. Can't figure out how to convert to double
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale(identifier: "en_US")

    let airfare = currencyFormatter.string(from: NSNumber(value: cost))!
    print(airfare)
    
    return cost
}

print(calculateAirfare(checkedBags: 2, distance: 300, travelers: 1))
print(calculateAirfare(checkedBags: 3, distance: 4000, travelers: 3))
print(calculateAirfare(checkedBags: 5, distance: 1500, travelers: 1))
