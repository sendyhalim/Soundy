import Foundation
import Moya
import RxSwift
import RxMoya

enum SoundcloudAPI {
  case searchTracks(String)
}

extension SoundcloudAPI: TargetType {
  static fileprivate let clientId = "327f7a3adac5989141fe01ce0416b1aa"

  var baseURL: URL {
    return URL(string: "http://api.soundcloud.com")!
  }

  var path: String {
    switch self {
      case .searchTracks(_):
        return "/tracks"
    }
  }

  var method: Moya.Method {
    return Moya.Method.get
  }

  var parameters: [String: Any]? {
    switch self {
    case .searchTracks(let searchQuery):
      return [
        "q": searchQuery,
        "linked_partitioning": "1",
        "client_id": SoundcloudAPI.clientId
      ]
    }
  }

  var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }

  var sampleData: Data {
    switch self {
    case .searchTracks(_):
      return "{\"collection\": [], \"next_href\": null}".data(using: String.Encoding.utf8)!
    }
  }

  var task: Task {
    return Task.request
  }
}

struct Soundcloud {
  static let provider = RxMoyaProvider<SoundcloudAPI>()

  static func request(api: SoundcloudAPI) -> Observable<Response> {
    return provider.request(api)
  }

  static func streamURL(url: URL) -> URL {
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
    urlComponents.queryItems = [
      URLQueryItem(name: "client_id", value: SoundcloudAPI.clientId)
    ]

    return urlComponents.url!
  }
}
