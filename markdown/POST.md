# POST

- Method: https://onthemap-api.udacity.com/v1/StudentLocation
- Method Type: POST
- Example Request:
```
    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error…
            return
        }
        print(String(data: data!, encoding: .utf8)!)
    }
    task.resume()
```

