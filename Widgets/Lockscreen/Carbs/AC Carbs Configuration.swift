import AppIntents

struct ActionOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [IntentAction] {
        IntentAction.allCases
    }
}

struct ACCarbsConfiguration: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")
    
    @Parameter(title: "Show Date", default: true)
    var showDate: Bool
    
    @Parameter(title: "Show Unit", default: true)
    var showUnit: Bool
    
    @Parameter(title: "Action after opening the app", optionsProvider: ActionOptionsProvider())
    var action: IntentAction
    
    init() {
        self.action = .newRecord
    }
    
    init(action: IntentAction) {
        self.action = action
    }
}

enum IntentAction: String, CaseIterable, AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(name: "Action")
    
    case nfc =       "action/nfc",
         newRecord = "action/new_record"
    
    var displayRepresentation: DisplayRepresentation {
        switch self {
        case .nfc:       .init(title: "NFC")
        case .newRecord: .init(title: "New Record")
        }
    }
    
    static var caseDisplayRepresentations: [IntentAction: DisplayRepresentation] = [
        .nfc:       .init(stringLiteral: "NFC"),
        .newRecord: .init(stringLiteral: "New Record")
    ]
    
    var title: String {
        switch self {
        case .nfc:       "NFC"
        case .newRecord: "New Record"
        }
    }
}