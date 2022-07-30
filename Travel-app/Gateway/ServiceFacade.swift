import Swinject
import NeoNetworking
extension Container {
    static var `default` = Container()
}
class ServiceFacade {
    static let applicationService: ApplicationConfigurable = ApplicationDevelopmentConfiguration()
    static let theme: Themeable = DefaultTheme()
    static private let apiService: NeoNetworkProviable = NeoNetworkProvider(with: APIConfigableSample())
    static let languageKeeper: LanguageKeepable = LanguageKeeper()
    static let persistentUserDefault: PersistentDataSaveable = UserDefaultsDataSaver()
    static func registerDefaultService(from windown: UIWindow) {
        ServiceFacade.initializeService(from: windown)
    }
    static func getService<T>(_ type: T.Type) -> T? {
        return Container.default.resolve(type)
    }
    static private func initializeService(from window: UIWindow) {
        applicationService.setupSpecificConfig()
        Container.default.register(NeoNetworkProviable.self) { (_) in
            return ServiceFacade.apiService
        }
        Container.default.register(LanguageKeepable.self) { (_) -> LanguageKeepable in
            return ServiceFacade.languageKeeper
        }
        Container.default.register(PersistentDataSaveable.self) { (_) -> PersistentDataSaveable in
            return ServiceFacade.persistentUserDefault
        }
    }
    static func shutDownAllService() {
        applicationService.shutDown()
    }
}
