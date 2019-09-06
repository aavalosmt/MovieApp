# MovieApp

## Arch: Viper Rx

## Layers
---------

### Model Layer: 
Model objects used to represent and get data needed by the app. 
  * Persistance Layer: 
        Repositories and PersistanceControllers, the PersistanceController interacts directly with the persistance model (Core Data, Realm, SQL), it is injected to the Repository so the selected persistance layer is decoupled from the repository logic.
        The repository communicates with the use case and the PersistanceController to save and fetch data

### UseCases: 
Class containing business rule logic, fetching and saving the data provided or requested from the interactor, it's placed between the interactor and the model layer. Communicates interactor with model layer
 
### Interactor: 
Class that handles the use cases interactions and gives the result to the presenter. Communicates with presenter and use cases

### Presenter: 
Class that contains the logic to drive the UI. Connects the Router with the Interactor and the View
* Note: Altough in this project the Presenter fetches data and passes the entities to the view, the correct implementation should be that the presenter transformed the entities into a view model that contained the information to be shown in the UI. TLDR; model entities shouldn't be passed to View layer. Due to time restrictions this flaw couldn't be corrected
  
### View: 
All UI the user views and can interact with. The View should be passive, it shouldn't ask the presenter for data, rather it should notify the presenter about it's state changes and the presenter should fetch the data to drive the UI.

### Router: 
Handles the view presentating and flow logic.

### SOLID: 
* SRP: Every class should handle a single responsability and have a single reason to change - UseCases
* Open/Closed: Classes and other entities should be open for extension but closed for modification - In this case the access to the classes was not properly handled due to time 
* Liskov substitution: Objects should be able to be replaceable by subtypes or other objects implementing the same protocol. 
*  Interface Segregation Principle: Interfaces should be client specific rather than general. - Rather than having for example aa Service that does all requests and be used in every use case, there should be injected from use case perspective a Service that only does the functions that the use case requires
* Dependency Inversion Principle: Depend on abstractions rather than concretions. - p.e. in the app the PersistanceController is injected by a concrete object communicating with a concrete persistance layer but from Repository perspective it is a generic abstraction

### A Good code:
Should have/be:
* Great Readability
* Great Testability
* Great Scalability

Having loosed coupled layers and conforming to SOLID principles helps to obtain the characteristics above listed.

### A Good Unit Test:

* Readable: Unit tests should be easy to understand

* Isolated: Unit tests are standalone, can be run in isolation, and have no dependencies on any outside factors such as a file system, database or network calls. - p.e. in the app the cache is mocked, every test creates its dependencies

* Repeatable: Running a unit test should be consistent with its results, that is, it always returns the same result if you do not change anything in between runs. - p.e. in the app the services are mocked with OHTTPSubs to avoid calling the real service

* Self-Checking. The test should be able to automatically detect if it passed or failed without any human interaction.

* Timely: A unit test should not take a disproportionally long time to write compared to the code being test

### Notes:
---------

Some things couldn't be fully implemented due to time: Loaders when requesting data, cleaning return Viper references (aka "weak" references between components) because are replaced with Observable binds, correct use of access modifiers in all code, marks and other code comments.
