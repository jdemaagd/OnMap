# PUT

- Method: https://onthemap-api.udacity.com/v1/StudentLocation/<objectId>
- Method Type: PUT
- Required Parameters:
    - objectId - (String) the object ID of the StudentLocation to update; specify the object ID right after StudentLocation in URL as seen below
    - Example: https://onthemap-api.udacity.com/v1/StudentLocation/8ZExGR5uX8
- Example Request:
```
    let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/8ZExGR5uX8"
    let url = URL(string: urlString)
    var request = URLRequest(url: url!)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error…
            return
        }
        print(String(data: data!, encoding: .utf8)!)
    }
    task.resume()
```

