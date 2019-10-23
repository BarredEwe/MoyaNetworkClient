import Moya
#if !COCOAPODS
    import MoyaNC
#endif

extension MoyaNC {

    @discardableResult
    public func request<Value: Codable>(_ target: BaseTargetType) -> FutureResult<Value> {
        #if canImport(Cache)
        return request(target, cachePolicy: target.cachePolicy)
        #else
        return FutureResult<Value> { completion in
            self.request(target) { (result: Result<Value>) in
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
        guard getCache(for: target) != nil else {
            return FutureResult<Value> { completion in
                self.providerRequest(target, cachePolicy: cachePolicy) { (result: Result<Value>) in
                    switch result {
                    case let .success(value): completion(.success(value))
                    case let .failure(error): completion(.failure(error))
                    }
                }
            }
        }
        return FutureResult<Value> { completion in
            let resultCompletion = { (result: Result<Value>) in
                switch result {
                case let .success(value): completion(.success(value))
                case let .failure(error): completion(.failure(error))
                }
            }
            guard self.processCache(target, cachePolicy: cachePolicy, resultCompletion) == nil else { return }
            self.providerRequest(target, resultCompletion)
        }
    }
    #endif
}
