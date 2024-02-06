//
//  EventRouter.swift
//  DeskproFramework
//
//  Created by QSD BiH on 2. 2. 2024..
//

import Foundation

public final class EventRouter {
    
    public var handleEventCallback: ((DeskproEvent) -> Void)? = nil
    
    private var enableAutologging: Bool
    
    init(enableAutologging: Bool = false) {
        self.enableAutologging = enableAutologging
    }
    
    final func handleOrLogEvent(event: DeskproEvent) {
        if enableAutologging {
            dprint("[DeskproLogger]: \(event.debugDescription)")
        }
        handleEventCallback?(event)
    }
}

public enum DeskproEvent {
    static let eventPrefix = "appEvent_"
    
    case newChat(data: String)
    case chatEnded(data: String)
    case newChatMessage(data: String)
    case chatUploadRequest(data: String)
    case custom(data: String)
    
    var identifier: String {
        switch self {
        case .newChat: return "chat.new"
        case .chatEnded: return "chat.ended"
        case .newChatMessage: return "chat.new-message"
        case .chatUploadRequest: return "chat.upload-request"
        case .custom(_): return "custom"
        }
    }
    
    var containedIdentifier: String {
        switch self {
        case .newChat: return "\"id\":\"chat.new\""
        case .chatEnded: return "\"id\":\"chat.ended\""
        case .newChatMessage: return "\"id\":\"chat.new-message\""
        case .chatUploadRequest: return "\"id\":\"chat.upload-request\""
        default: return ""
        }
    }
    
    public var data: String {
        switch self {
        case let .newChat(data): return data
        case let .chatEnded(data): return data
        case let .newChatMessage(data): return data
        case let .chatUploadRequest(data): return data
        case let .custom(data): return data
        }
    }
    
    public var debugDescription: String {
        "\(Date.nowString) [AppEvent] \(data)"
    }
}

private extension Date {
    static var nowString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
}

func dprint(_ object: Any...) {
#if DEBUG
    for item in object {
        print(item)
    }
#endif
}
func dprint(_ object: Any) {
#if DEBUG
    print(object)
#endif
}
