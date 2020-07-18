# GET User Data

- Method Name: https://onthemap-api.udacity.com/v1/users/<user_id>
- Method Type: GET
- Example Request:
```
    let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/3903878747")!)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error...
            return
        }
        let range = Range(5..<data!.count)
        let newData = data?.subdata(in: range) /* subset response data! */
        print(String(data: newData!, encoding: .utf8)!)
    }
    task.resume()
```

