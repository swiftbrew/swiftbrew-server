import Just
import Vapor

private let appSlug = ProcessInfo.processInfo.environment["APP_SLUG"]!
private let buildTriggerToken = ProcessInfo.processInfo.environment["BUILD_TRIGGER_TOKEN"]!

public func routes(_ router: Router) throws {
    router.post("bottles") { req -> Future<HTTPStatus> in
        return try req.content.decode(SwiftPackage.self).map(to: HTTPStatus.self) { package in
            let endpointURL = "https://app.bitrise.io/app/\(appSlug)/build/start.json"
            let json: [String: Any] = [
                "hook_info": [
                    "type": "bitrise",
                    "build_trigger_token": buildTriggerToken,
                ],
                "build_params": [
                    "environments": [
                        [
                            "mapped_to": "PACKAGE_NAME",
                            "value": package.name,
                            "is_expand":true
                        ],
                        [
                            "mapped_to": "PACKAGE_GIT_URL",
                            "value": package.gitURL,
                            "is_expand":true
                        ],
                        [
                            "mapped_to": "PACKAGE_VERSION",
                            "value": package.version,
                            "is_expand":true
                        ]
                    ]
                ]
            ]

            let result = Just.post(endpointURL, json: json)

            if result.ok {
                return .ok
            } else {
                // TODO: Properly handle error
                return .internalServerError
            }
        }
    }
}
