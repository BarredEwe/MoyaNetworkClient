import Moya

extension MoyaNetworkClient {

    @discardableResult
    public func request<Value: Codable>(_ target: BaseTargetType) -> FutureResult<Value> {
        #if canImport(Cache)
        return request(target, cachePolicy: target.cachePolicy)
        #else
        return FutureResult<Value> { completion in
            self.providerRequest(target) { (result: Result<Value>) in
                switch result {
                case let .success(value): completion(.success(value))
                case let .failure(error): completion(.failure(error))
                }
            }
        }
        #endif
    }

    #if canImport(Cache)
    @discardableResult
    public func request<Value: Codable>(_ target: BaseTargetType, cachePolicy: MoyaCachePolicy) -> FutureResult<Value> {
        guard getCache(for: target) != nil else { return request(target) }
        return FutureResult<Value> { completion in
            let resultCompletion = { (result: Result<Value>) in
                switch result {
                    case let .success(value): completion(.success(value))
                    case let .failure(error): completion(.failure(error))
                }
            }
            if self.processCache(target, cachePolicy: cachePolicy, resultCompletion) == nil {
                self.providerRequest(target, resultCompletion)
            }
        }
    }
    #endif
}

