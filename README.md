# MovieApp

## Arch: Viper Rx

## Layers
---------

### Model Layer: Model objects used to represent and get data needed by the app. 
  * Persistance Layer: 
        Repositories and PersistanceControllers, the PersistanceController interacts directly with the persistance model (Core Data, Realm, SQL), it is injected to the Repository so the selected persistance layer is decoupled from the repository logic.
        The repository communicates with the use case and the PersistanceController to save and fetch data

### UseCases: Class containing business rule logic, fetching and saving the data provided or requested from the interactor, it's placed between the interactor and the model layer. Communicates interactor with model layer
 
### Interactor: Class that handles the use cases interactions and gives the result to the presenter. Communicates with presenter and use cases

### Presenter: Class that contains the logic to drive the UI. Connects the Router with the Interactor and the View
* Note: Altough in this project the Presenter fetches data and passes the entities to the view, the correct implementation should be that the presenter transformed the entities into a view model that contained the information to be shown in the UI. TLDR; model entities shouldn't be passed to View layer. Due to time restrictions this flaw couldn't be corrected
  
### View: All UI the user views and can interact with. The View should be passive, it shouldn't ask the presenter for data, rather it should notify the presenter about it's state changes and the presenter should fetch the data to drive the UI.

### Router: Handles the view presentating and flow logic.
