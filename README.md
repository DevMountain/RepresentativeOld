# Representatives

### Level 2

Students will build an app to get the representatives (law makers) in a user-requested state to practice asynchronous network requests, working with JSON data, closures, and intermediate table views.

Students who complete this project independently are able to:

* use URLSession to make asynchronous network calls
* parse JSON data and generate model objects from the data
* use closures to execute code when an asynchronous task is complete
* build custom table views

### Implement Model

##### Create a `Representative` model struct that will hold the information of a representative to display to the user.

1. Create a `Representative.swift` file and define a new `Representative` struct.
2. Go to a sample endpoint of the [Who is my Representative](https://whoismyrepresentative.com) API and see what JSON (information) you will get back.
3. Using this information, add properties on `Representative`.
* `let name: String`
* `let party: String`
* `let state: String`
* `let district: String`
* `let phone: String`
* `let office: String`
* `let link: String`
4. Make `Representative` conform to the `Codable` protocol.

### Representative Controller

##### Create a `RepresentativeController` class.

This class will use the `URLSession` to fetch data and deserialize the results into `Representative` objects. This class will be used by the view controllers to fetch Representative objects through completion closures.

As of iOS 9, Apple is boosting security and requiring developers to use the secure HTTPS protocol and require the server to use the proper TLS Certificate version. So for this app, you will need to turn off the App Transport Security feature.

Open your `Info.plist` file and add a key-value pair to your Info.plist. This key-value pair should be:
`App Transport Security Settings : [Allow Arbitrary Loads : YES].`

1. The `RepresentativeController` should have a static constant that represents the `baseURL` of the API.
2. Add a  function `searchRepresentatives(forState state: ...)` that allows the developer to pass in the search parameter, create a dataTask to fetch the representatives' data, and through a completion closure provide an array of `Representative` objects.
3. This function should set create a dictionary of the URL parameters for the state and the output types, then create an array of `URLQueryItem`s from the dictionary.
4. Create an instance of `URLComponents` with the `baseURL`, then attach the array of `URLQueryItem`s to it.
5. Using the `url` property that is a part of your `URLComponents`, create a dataTask using `URLSession`. Use the initializer with that takes in a `URL`, and has a completion closure. This is used to get `Data` back from the API.
6. In the completion closure of your dataTask, use a guard statement to check for nil data, and if the guard statement fails, print an error message to the console and run the completion with an empty array.  
7. If the guard statement doesn't fail then use `JSONDecoder` to decode the `Data` as a dictionary `[String: [Representative]]`.  

**Note:** Currently, whoismyrepresentative.com incorrectly encodes letters with diacrtic marks, e.g. ú, using extended ASCII, not UTF-8. This means that trying to convert the data to a string using .utf8 will fail for some states, where the representatives have diacritics in their names. To workaround this, decode data into a string using `.ascii`, then reencode the string as data using `.utf8` before passing the fixed UTF-8 data into the JSON decoder.  

8. Get the array of `Representative`s using resultsDictionary["results"]
9. Call the completion closure with the array of decoded array of `Representative`s.

Note: There are many different patterns and techniques to deserialize JSON data into Model objects. Feel free to experiment with different techniques to turn the data returned from the URLSessionDataTask into an array of `Representative`s.

At this point you should be able to pull data for a specific state and deserialize a list of Representatives. Feel free to test this in your App Delegate by trying to print the results for a state to the console.

### View Hierarchy Notes

You will implement a 'Master-Detail' view hierarchy for this application.

Your Master View is a list of states. Selecting any state will segue to a Detail View displaying a list of representatives for the selected state.

Recognize that even though the list of representatives may be called a List view, it is also considered a Detail view in this project because it is the Detail view of the selected state.

### State List View Controller

Build a view that lists all states. Use the included `all` variable in the `States.swift` file to build the datasource for the UITableViewController. This view will be used to segue to a list of Representatives for the selected state.

1. Add a `UITableViewController` as your root view controller in Main.storyboard and embed it in a `UINavigationController`
2. Create an `StateListTableViewController` file as a subclass of `UITableViewController` and set the class of your root view controller scene
3. Implement the `UITableViewDataSource` functions using the included `all` states array in the `States.swift` file.
4. Set up your cells to display the name of each state

### State Detail View Controller

Build a view that lists all of the Representatives for a selected state. Use a UITableViewController and a custom UITableViewCell that displays the properties of a Representative (name, party, state, district, phone, and url).

The State List View Controller will pass a State string to this scene. We will use that value to perform the network request. When the network request is completed, you will reload the UITableView to display the results.

1. Add an additional `UITableViewController` scene to the Storyboard. Create a class file `StateDetailTableViewController.swift` and assign the class to the storyboard scene.
2. Create a prototype cell that uses a Stack View to display the name, party, district, website, and phone number of a `Representative`.
3. Create a custom `UITableViewCell` class with an `updateViews()` function that sets the labels to the `Representative` data and assign the prototype cell in storyboard to the class. (Don't forget to create outlets for your labels)
4. Create a `representative` computed property and in the `didSet` of that property call `updateViews()`.
5. In the `StateDetailTableViewController`, add a computed property of type `[Representative]` that will be used to populate the Table View. Set it to an empty array to satisfy the requirement that all properties have values upon initialization and in the `didSet` reload the table view.
6. Add an optional `state` property of type `String`. This will be set by the `StateListViewController` in the `prepare(for segue: UIStoryboardSegue, sender: Any?)` function.
7. Implement the UITableViewDataSource functions to return your custom prototype cell by setting the cell's `representative` variable. (You'll need to cast the cell as the custom cell you created)
8. Update your `viewDidLoad()` function to call the `RepresentativeController.searchRepresentatives(forState:...)` function using the unwrapped state property. In the completion closure, set `self.representatives` to the returned representatives and reload the UITableView on the main thread.

Note: It is good practice to let the user know that a network request is processing. This is most commonly done using the Network Activity Indicator in the status bar. Look up the documentation for the `isNetworkActivityIndicatorVisible` property on `UIApplication` to turn on the indicator when the view loads and to turn it off when the network call is complete.

### Wire Up the Views

Set up a segue from the State List View to the State Detail View that assigns the state that the State Detail View should load Representatives for.

1. Add a segue from the prototype cell on the `StateListTableViewController` scene to the `StateDetailTableViewController` and assign an identifier.
2. Implement the `prepare(for segue: UIStoryboardSegue, sender: Any?)` function on the `StateListTableViewController` class to capture the state and assign it to the `destinationViewController`'s `state` property.

The app is now finished. Run it, check for bugs, and fix any that you might find.

### Black Diamonds

* Implement another way for users to find their Congressman/Congresswoman.
* If no Representatives were found, notify the user that a search failed.
* Make the phone, office, and website labels links that would call, open a map view, and open a web view.

## Contributions

Please refer to CONTRIBUTING.md.

## Copyright

© DevMountain LLC, 2015. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.
