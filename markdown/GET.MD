# GET

- Method: https://onthemap-api.udacity.com/v1/StudentLocation
- Method Type: GET
- Optional Parameters:
    - limit - (Number) specifies the maximum number of StudentLocation objects to return in the JSON response
        - Example: https://onthemap-api.udacity.com/v1/StudentLocation?limit=100
    - skip - (Number) use this parameter with limit to paginate through results
        - Example: https://onthemap-api.udacity.com/v1/StudentLocation?limit=200&skip=400
    - order - (String) a comma-separate list of key names that specify the sorted order of the results
        - Prefixing a key name with a negative sign reverses the order (default order is ascending)
        - Example: https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt
    - uniqueKey - (String) a unique key (user ID). Gets only student locations with a given user ID.
        - Filtering by the user ID can be useful if the user has already posted a location (for example, pre-filling the location field). You probably won't need this since the user IDs are randomized.
        - Example: https://onthemap-api.udacity.com/v1/StudentLocation?uniqueKey=1234

```
    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error...
            return
        }
        print(String(data: data!, encoding: .utf8)!)
    }
    task.resume()
```

