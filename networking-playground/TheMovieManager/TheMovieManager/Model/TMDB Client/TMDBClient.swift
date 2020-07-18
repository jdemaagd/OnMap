import Foundation

class TMDBClient {
    
    static let apiKey = "1"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getWatchlist
        case getFavorites
        case getRequestToken
        case login
        case createSessionId
        case logout
        case webAuth
        case search(String)
        case markWatchlist
        case markFavorite
        case posterImage(String)
        
        var stringValue: String {
            switch self {
            case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getFavorites:
                return Endpoints.base + "/account/\(Auth.accountId)/favorite/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getRequestToken:
                return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
            case .login:
                return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            case .createSessionId:
                return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
            case .logout:
                return Endpoints.base + "/authentication/session" + Endpoints.apiKeyParam
            case .webAuth:
                return "https://www.themoviedb.org/authenticate/\(Auth.requestToken)?redirect_to=themoviemanager:authenticate"
            case .search(let query):
                return Endpoints.base + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
            case .markWatchlist:
                return Endpoints.base + "/account/\(Auth.accountId)/watchlist" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .markFavorite:
                return Endpoints.base + "/account/\(Auth.accountId)/favorite" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .posterImage(let posterPath):
                return "https://image.tmdb.org/t/p/w500/" + posterPath
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, res, err in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, err?.localizedDescription as? Error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let res = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(res, nil)
                }
            } catch {
                do {
                    let err2 = try decoder.decode(TMDBResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, err2.localizedDescription as? Error)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, err?.localizedDescription as? Error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.httpBody = try! JSONEncoder().encode(body)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: req) { data, res, err in
            guard let safeData = data else {
                DispatchQueue.main.async {
                    completion(nil, err?.localizedDescription as? Error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let safeRes = try decoder.decode(ResponseType.self, from: safeData)
                DispatchQueue.main.async {
                    completion(safeRes, nil)
                }
            } catch {
                do {
                    let err2 = try decoder.decode(TMDBResponse.self, from: safeData) as Error
                    DispatchQueue.main.async {
                        completion(nil, err2.localizedDescription as? Error)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, err?.localizedDescription as? Error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getWatchlist.url, responseType: MovieResults.self) { res, err in
            if let safeRes = res {
                completion(safeRes.results, nil)
            } else {
                completion([], err?.localizedDescription as? Error)
            }
        }
    }
    
    class func getFavorites(completion: @escaping ([Movie], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getFavorites.url, responseType: MovieResults.self) { res, err in
            if let safeRes = res {
                completion(safeRes.results, nil)
            } else {
                completion([], err?.localizedDescription as? Error)
            }
        }
    }
    
    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getRequestToken.url, responseType: RequestTokenResponse.self) { res, err in
            if let safeRes = res {
                Auth.requestToken = safeRes.requestToken
                completion(true, nil)
            } else {
                completion(false, err?.localizedDescription as? Error)
            }
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(username: username, password: password, requestToken: Auth.requestToken)
        taskForPOSTRequest(url: Endpoints.login.url, responseType: RequestTokenResponse.self, body: body) { res, err in
            if let safeRes = res {
                Auth.requestToken = safeRes.requestToken
                completion(true, nil)
            } else {
                completion(false, err?.localizedDescription as? Error)
            }
        }
    }
    
    class func createSessionId(completion: @escaping (Bool, Error?) -> Void) {
        let body = PostSession(requestToken: Auth.requestToken)
        taskForPOSTRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: body) { res, err in
            if let safeRes = res {
                Auth.sessionId = safeRes.sessionId
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var req = URLRequest(url: Endpoints.logout.url)
        req.httpMethod = "DELETE"
        let body = LogoutRequest(sessionId: Auth.sessionId)
        req.httpBody = try! JSONEncoder().encode(body)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: req) { data, res, err in
            Auth.requestToken = ""
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }
    
    class func search(query: String, completion: @escaping ([Movie], Error?) -> Void) -> URLSessionDataTask {
        let task = taskForGETRequest(url: Endpoints.search(query).url, responseType: MovieResults.self) { res, err in
            if let safeRes = res {
                completion(safeRes.results, nil)
            } else {
                completion([], err?.localizedDescription as? Error)
            }
        }
        return task
    }
    
    class func markWatchlist(movieId: Int, watchlist: Bool, completion: @escaping (Bool, Error?) -> Void) {
        let body = MarkWatchlist(mediaType: "movie", mediaId: movieId, watchlist: watchlist)
        taskForPOSTRequest(url: Endpoints.markWatchlist.url, responseType: TMDBResponse.self, body: body) { res, err in
            if let safeRes = res {
                // separate codes are used for posting, deleting, and updating a response
                // all are considered "successful"
                completion(safeRes.statusCode == 1 || safeRes.statusCode == 12 || safeRes.statusCode == 13, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    class func markFavorite(movieId: Int, favorite: Bool, completion: @escaping (Bool, Error?) -> Void) {
        let body = MarkFavorite(mediaType: "movie", mediaId: movieId, favorite: favorite)
        taskForPOSTRequest(url: Endpoints.markFavorite.url, responseType: TMDBResponse.self, body: body) { res, err in
            if let safeRes = res {
                completion(safeRes.statusCode == 1 || safeRes.statusCode == 12 || safeRes.statusCode == 13, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    class func downloadPosterImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.posterImage(path).url) { data, res, err in
            DispatchQueue.main.async {
                completion(data, err?.localizedDescription as? Error)
            }
        }
        task.resume()
    }
}
