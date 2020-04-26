import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.post(PullRequestData.self, at: "remoteMapper") { req, data -> String in
        RemoteMappingService().mapRemote(to: data.pullRequestName)
    }
}

struct PullRequestData: Content {
    let pullRequestName: String
}
