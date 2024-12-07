struct APIService {
    let baseURL: String = "htps://www.themealdb.com/api/json/v1/1/"
    var method: HTTPMethod = .GET
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}
