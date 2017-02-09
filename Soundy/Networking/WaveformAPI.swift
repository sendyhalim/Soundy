import Foundation
import Moya
import RxMoya
import RxSwift

///  API for fetching soundcloud waveform data
///
///  - waveformData: Endpoint for fetching wave form data
enum WaveformAPI {
  case waveformData(URL)
}

extension WaveformAPI: TargetType {
  var baseURL: URL {
    return URL(string: "http://www.waveformjs.org/w")!
  }

  var path: String {
    switch self {
    case .waveformData(_):
      return "/w"
    }
  }

  var method: Moya.Method {
    return Moya.Method.get
  }

  var parameters: [String: Any]? {
    switch self {
    case .waveformData(let waveformURL):
      return [
        "url": waveformURL.description.replacingOccurrences(of: "https", with: "http")
      ]
    }
  }

  var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }

  var sampleData: Data {
    switch self {
    case .waveformData(_):
      return "[]".data(using: String.Encoding.utf8)!
    }
  }

  var task: Task {
    return Task.request
  }
}

struct Waveform {
  static let provider = RxMoyaProvider<WaveformAPI>()

  static func request(api: WaveformAPI) -> Observable<Response> {
    return provider.request(api)
  }
}
