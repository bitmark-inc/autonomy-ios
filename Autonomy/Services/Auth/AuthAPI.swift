//
//  AuthAPI.swift
//  Autonomy
//
//  Created by thuyentruong on 11/1/19.
//  Copyright © 2019 Bitmark Inc. All rights reserved.
//

import Foundation
import Moya

enum AuthAPI {
    case auth(accountNumber: String, timestamp: String, signature: Data)
}

extension AuthAPI: VersionTargetType {

    var baseURL: URL {
        return URL(string: Constant.apiServerURL + "/api/auth")!
    }

    var path: String {
        return ""
    }

    var method: Moya.Method {
        return .post
    }

    var sampleData: Data {
        if let dataURL = R.file.authJson(), let data = try? Data(contentsOf: dataURL) {
            return data
        }

        return Data()
    }

    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .auth(let accountNumber, let timestamp, let signature):
            params["requester"] = accountNumber
            params["timestamp"] = timestamp
            params["signature"] = signature.hexEncodedString
        }
        return params
    }

    var task: Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
        return .requestPlain
    }

    var headers: [String: String]? {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
}
