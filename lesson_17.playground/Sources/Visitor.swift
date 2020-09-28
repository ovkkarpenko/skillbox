import Foundation

struct Mechanic {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

struct Customer {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

protocol Documenter {
    func process(documentable: Quote)
    func process(documentable: Appointment)
}

protocol Documentable {
    func accept(documenter: Documenter)
}

class Quote: Documentable {
    var customer: Customer
    
    init(customer: Customer) {
        self.customer = customer
    }
    
    func accept(documenter: Documenter) {
        documenter.process(documentable: self)
    }
}

class Appointment: Documentable {
    var customer: Customer
    var mechanic: Mechanic
    
    init(customer: Customer, mechanic: Mechanic) {
        self.customer = customer
        self.mechanic = mechanic
    }
    
    func accept(documenter: Documenter) {
        documenter.process(documentable: self)
    }
}

class EmailDocumenter: Documenter {
    func process(documentable: Quote) {
        let content = "Hello \(documentable.customer.name)."
        print(content)
    }
    
    func process(documentable: Appointment) {
        var content = "Hello \(documentable.customer.name) "
        content += "\(documentable.mechanic.name) will be more than happy " +
            "to answer any questions you might have."
        print(content)
    }
}

public class Notification {
    var quotes = [Documentable]()
    var appointments = [Documentable]()
    
    public init() {
        let joe = Mechanic(name: "Joe Stevenson")
        let reza = Customer(name: "Reza Shirazian")
        let lyanne = Customer(name: "Lyanne Borne")

        let quote = Quote(customer: reza)
        quotes.append(quote)
        
        let appointment = Appointment(customer: lyanne, mechanic: joe)
        appointments.append(appointment)
    }
    
    public func email() {
        let emailDocumenter = EmailDocumenter()

        for quote in quotes {
          quote.accept(documenter: emailDocumenter)
        }

        for appointment in appointments {
          appointment.accept(documenter: emailDocumenter)
        }
    }
}
