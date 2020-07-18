# DELETE Session

- Method: https://onthemap-api.udacity.com/v1/session
- Method Type: DELETE
- Example Request:
``` 
    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
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

