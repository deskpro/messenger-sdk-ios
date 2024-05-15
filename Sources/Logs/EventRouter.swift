//
//  EventRouter.swift
//
//  Created by QSD BiH on 2. 2. 2024..
//

import Foundation

/// Notifies the outside subscriber if an event occured. Prints all of the events if the autologging is enabled
@objc public final class EventRouter: NSObject {
    
    /// Invoked when an event occurs
    public var handleEventCallback: ((DeskproEvent) -> Void)? = nil
    @objc public var objcHandleEventCallback: ((ObjcDeskproEventData) -> Void)? = nil
    private var enableAutologging: Bool
    
    ///  Initializes the EventRouter class
    ///
    ///- Parameter enableAutologging: If true, the EventRouter class will print all of the events that occur (during debug mode).
    ///
    @objc public init(enableAutologging: Bool = false) {
        self.enableAutologging = enableAutologging
    }
    
    /// Called when an event occurs (from [PresentCoordinator](x-source-tag://PresentCoordinator)). Logs the event if needed and invokes the callback for outside handling
    final func handleOrLogEvent(event: DeskproEvent) {
        if enableAutologging {
            dprint("[DeskproLogger]: \(event.debugDescription)")
        }
        
        handleEventCallback?(event)
    }
    
    @objc func objcHandleOrLogEvent(event: ObjcDeskproEventData) {
        if enableAutologging {
            dprint("[DeskproLogger]: \(event.debugDescription)")
        }
        
        objcHandleEventCallback?(event)
    }
}

@objc public final class ObjcDeskproEventData: NSObject {
    @objc public var event: ObjcDeskproEvent
    @objc public var data: String
    
    @objc init(event: ObjcDeskproEvent, data: String) {
        self.event = event
        self.data = data
    }
    
    @objc public override var debugDescription: String {
        "\(Date.nowString) [AppEvent] \(data)"
    }
}

@objc public enum ObjcDeskproEvent: Int {
    case newChat
    case chatEnded
    case newChatMessage
    case chatUploadRequest
    case custom
}

/// An event that occurs during a chat session. The observation of these events occurs through the EventRouter class
public enum DeskproEvent {
    /// The event prefix which is appended in front of each event for easier identification
    static let eventPrefix = "appEvent_"
    
    /// The data inside each event is stored as raw JSON in string format, which can be further transformed if needed
    case newChat(data: String)
    case chatEnded(data: String)
    case newChatMessage(data: String)
    case chatUploadRequest(data: String)
    case custom(data: String)
    
    /// The identifier for each event
    var identifier: String {
        switch self {
        case .newChat: return "chat.new"
        case .chatEnded: return "chat.ended"
        case .newChatMessage: return "chat.new-message"
        case .chatUploadRequest: return "chat.upload-request"
        case .custom(_): return "custom"
        }
    }
    
    /// If the raw JSON contains this string, the according event is instantiated
    var containedIdentifier: String {
        switch self {
        case .newChat: return "\"id\":\"chat.new\""
        case .chatEnded: return "\"id\":\"chat.ended\""
        case .newChatMessage: return "\"id\":\"chat.new-message\""
        case .chatUploadRequest: return "\"id\":\"chat.upload-request\""
        default: return ""
        }
    }
    
    var toObjcEvent: ObjcDeskproEvent {
        switch self {
        case .newChat(_): return .newChat
        case .chatEnded(_): return .chatEnded
        case .newChatMessage(_): return .newChatMessage
        case .chatUploadRequest(_): return .chatUploadRequest
        case .custom(_): return .custom
        }
    }
    
    /// Raw event JSON in string format
    public var data: String {
        switch self {
        case let .newChat(data): return data
        case let .chatEnded(data): return data
        case let .newChatMessage(data): return data
        case let .chatUploadRequest(data): return data
        case let .custom(data): return data
        }
    }
    
    /// Returns the date of the event and the raw json for printing purposes
    public var debugDescription: String {
        "\(Date.nowString) [AppEvent] \(data)"
    }
}

/// Returns the current date as String for printing purposes
private extension Date {
    static var nowString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
}

/// Prints items only if debug mode is active
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
