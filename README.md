# Representatives

### Level 2

Students will build an app to get the representives (law makers) in a user-requested state to practice asyncronous network requests, working with JSON data, closures, and intermediate table views.

Students who complete this project independently are able to:

* use NSURLSession to make aysncronous network calls
* parse JSON data and generate model object from the data
* use closures to execute code when an asyncronous task is complete
* build custom table views

### Implement Model

##### Create a `Representative` model class that will hold the information of a representative to display to the user.

1. Create a `Representative.swift` class file and define a new `Representative` class.
2. Go to a sample endpoint of the [Who is my Representative](http://whoismyrepresentative.com) API and see what JSON (information) you will get back.
3. Using this information, add properties on `Representative`.
    * `let name: String`
    * `let party: String`
    * `let state: String`
    * `let district: String`
    * `let phone: String`
    * `let office: String`
    * `let link: String`
4. Create a failable initializer method with a parameter of a JSON dictionary (`[String: AnyObject]`. This is the method you will use to initialize your `Representative` object from the JSON dictionary. Remember to use a sample endpoint to inspect the JSON you will get back and the keys you will use to get each piece of data.

### Network Controller

Create a `NetworkController` class. This will have methods to build the different URLs you might want and it should have a method to return NSData from a URL. 

The `NetworkController` will be responsible for building URLs and executing  HTTP requests. Build the `NetworkController` to support different HTTP methods (GET, PUT, POST, PATCH, DELETE), and keep things generic such that you could use the same `NetworkController` in future projects if desired.

It is good practice to write reusable code. Even when you do not plan to reuse the class in future projects, it will help you keep the roles of your types properly separated. In this specific case, it is good practice for the `NetworkController` to not know anything about the project's model or controller types.

1. Write a `String` typed `enum` called `HTTPMethod`. You will use this enum to classify our HTTP requests as GET, PUT, POST, PATCH, or DELETE requests. Add cases for each.
    * example: `case Get = "GET"`
2. Write a function signature `performRequest` that will take a `URL`, an `HTTPMethod`, an optional `[String: String]` dictionary of URL parameters, an optional `Data` request body, and an optional completion closure. The completion closure should include a `Data?` data parameter and an `Error?` error parameter, and the should return `Void`. 
    * note: At this point, it is OK if you do not understand why you are including each parameter. Spend some time contemplating each parameter and why you would include it in this function. For example: An HTTP request is made up of a URL, and an HTTP Method. Certain requests need URL parameters. Certain POST or PUT requests can carry a body. The completion closure is included so you know when the request is complete.
3. Add the following `url(byAdding parameters` function to your `NetworkController` class. This function takes a base URL, URL parameters, and returns a completed URL with the parameters in place.
    * example: To perform a Google Search, you use the URL `https://google.com/search?q=test`. 'q' and 'test' are URL parameters, with 'q' being the name, and 'test' beging the value. This function will take the base URL `https://google.com/search` and a `[String: String]` dictionary `["q":"test"]`, and return the URL `https://google.com/search?q=test`

```swift
    static func url(byAdding parameters: [String: String], to url: URL) -> URL {
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters.flatMap({URLQueryItem(name: $0.0, value: $0.1)})
        
        guard let url = components?.url else { 
            fatalError("URL optional is nil") 
        } 
        return url
    }
```

4. Implement the `perform(request)` function.
    * Use the `url(byAdding` to get a requestURL.
    * Creating a new `URLRequest`, set the HTTP method, set the body.
    * Generate and start the data task.
    * Calling the completion when the data task completes.

This method will make the network call and call the completion closer with the `Data?` result. If successful, `Data?` will contain the response, if unsuccessful, `Data?` will be nil. The class or function that calls this function will need to handle nil data.

5. Use a Playground to test your network controller method with a sample endpoint from the [Who is My Representative API](http://whoismyrepresentative.com) to see if you are getting data returned.

As of iOS 9, Apple is boosting security and requiring developers to use the secure HTTPS protocol and requires the server to use the proper TLS Certificate version. The Post API does support HTTPS but does not use the correct TLS Certificate version. So for this app, you will need to turn off the App Transport Security feature.

6. Open your `Info.plist` file and add a key-value pair to your Info.plist. This key-value pair should be: 
`App Transport Security Settings : [Allow Arbitrary Loads : YES].`

### Representative Controller

##### Create a `RepresentativeController` class. This class will use the `NetworkController` to fetch data, and will serialize the results into `Representative` objects. This class will be used by the view controllers to fetch Representative objects through completion closures.

1. The `RepresentativeController` should have some static constant that represents the `baseURL` of the API.
2. Add a method `searchRepresentatives(forState` that allows the developer to pass in the search parameter and, through a completion closure, provide an array of `Representative` objects.
    * This method should set URL parameters for the state and the output types.
    * This method should call the NetworkController's `performRequest(for` method to get the Data at the URL created in the previous bullet point.
    * In the closure of the `performRequest(for`, use a guard to check for nil Data, and to unwrap the array of `[String: Any]` dictionaries that hold Representative data. You will need to use the `try?` keyword to use `JSONSerialization` to serialize the `Data`.
    * If the guard fails, print an error message to the console and run the completion with an empty array.
    * If the Data can be serialized, create a `Representative` objects and call the completion closure with the populated array. (Hint: Use a for loop or `flatMap` to iterate through the dictionaries and initialize a new array of `Representative` objects.)

Note: There are many different patterns and techniques to serialize JSON data into Model objects. Feel free to experiment with different techniques to get at the `[String: Any]` dictionaries within the Data returned from the URLSessionDataTask. 

At this point you should be able to pull data for a specific state and serialize a list of Representatives. Test this functionality with a Playground or in your App Delegate by trying to print the results for a state to the console.

### View Hierarchy Notes

You will implement a 'Master-Detail' view hierarchy for this application. 

Your Master View is a list of states. Selecting any state will segue to a Detail View displaying a list of representatives for the selected state.

Recognize that even though the list of representatives may be called a List view, it is also considered a Detail view in this project, because it is the Detail view of the selected state.

### State List View Controller

Build a view that lists all states. Use the included `all` variable in the `States.swift` file to build the datasource for the UITableViewController. This view will be used to segue to a list of Representatives for the selected state.

1. Add a `UITableViewController` as your root view controller in Main.storyboard and embed it into a `UINavigationController`
2. Create an `StateListTableViewController` file as a subclass of `UITableViewController` and set the class of your root view controller scene
3. Implement the UITableViewDataSource functions using the included `all` states array in the  `States.swift` file.
4. Set up your cells to display the name of each state

### State Detail View Controller

Build a view that lists all of the Representatives for a selected state. Use a UITableViewController and a custom UITableViewCell that displays the properties of a Representative (name, party, state, district, phone, and url). 

The State List View Controller will pass a State string to this scene. We will use that value to perform the network request. When the network request is completed, you will reload the UITableView to display the results.

1. Add an additional `UITableViewController` scene to the Storyboard. Create a class file `StateDetailTableViewController.swift` and assign the class to the storyboard scene.
2. Create a prototype cell that uses a Stack View to display the name, party, district, website, and phone number of a `Representative`. 
3. Create a custom `UITableViewCell` class with an `updateViews` function that sets the labels to the `Representative` data, and assign the prototype cell to the class. Call this function in the `didSet` of the `representative` variable.
4. In the `StateDetailTableViewController`, Add a property of type `[Representative]` that will be used to populate the Table View. Set it to an empty array to satisfy the requirement that all properties have values upon initialization. 
5. Add an optional `state` property of type `String`. This will be set by the `StateListViewController` in the `prepareForSegue` function.
6. Implement the UITableViewDataSource functions to return your custom prototype by setting the cell's `representative` variable.
7. Update your `viewDidLoad` function to call the `RepresentativeController.searchRepresentatives` function using the unwrapped state property. In the completion closure, set `self.representatives` to the returned representatives and reload the UITableView on the main thread.

Note: It is good practice to let the user know that a network request is processing. This is most commonly done using the Network Activity Indicator in the status bar. Look up the documentation for `isNetworkActivityIndicatorVisible` property on `UIApplication` to turn on the indicator when the view loads, and turn it off when the network call is complete.

### Wire Up the Views

Set up a segue from the State List View to the State Detail View that assigns the state that the State Detail View should load Representatives for.

1. Add a segue from the prototype cell on the `StateListTableViewController` scene to the `StateDetailTableViewController` and assign an identifier.
2. Implement the `prepare(for segue:` function on the `StateListTableViewController` class to capture the state and assign it to the `destinationViewController`'s `state` property.

### Black Diamonds

* Notice how after tapping the search button, the app hangs and doesn't do anything while the network call is being performed. Give visual feedback to the user that the search is being conducted.
* Implement another way for users to find their Congressman/Congresswoman.
* If no Represenatives were "found", notify the user that a search failed.
* Make the phone, office, and website labels links that would call, open a map view, and open a web view.

## Contributions

Please refer to CONTRIBUTING.md.

## Copyright

© DevMountain LLC, 2015. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.
