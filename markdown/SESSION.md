# POST Session

- Method: https://onthemap-api.udacity.com/v1/session
- Method Type: POST
- Required Parameters:
    - udacity - (Dictionary) a dictionary containing a username/password pair used for authentication
    - username - (String) the username (email) for a Udacity student
    - password - (String) the password for a Udacity student
- Example Request:
```
    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    // encoding a JSON body from a string, can also use a Codable struct
    request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error…
            return
        }
        let range = Range(5..<data!.count)
        let newData = data?.subdata(in: range) /* subset response data! */
        print(String(data: newData!, encoding: .utf8)!)
    }
    task.resume()
```

