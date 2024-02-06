//
//  PresentBuilder.swift
//  DeskproFramework
//
//  Created by QSD BiH on 4. 1. 2024..
//

import UIKit


///  Builder class for constructing URLs and presenting content in a WebView.
///
///  This class allows the construction of URLs by chaining various methods to build a specific path.
///  The final constructed path can then be presented in a WebView using the [show](x-source-tag://show) method.
///
///- Tag: PresentBuilder
public class PresentBuilder {
    
    ///  The coordinator for easier WebView presentation handling.
    private weak var coordinator: PresentCoordinator?
    
    ///  The base URL for constructing the path.
    public var url: String
    
    ///  The application ID used for presentation.
    private var appId: String
    
    ///  Represents the constructed path for the URL.
    private var path = ""

    ///   This method is a constructor for creating Deskpro objects
    ///
    /// - Parameter url: The base URL for constructing the path.
    /// - Parameter appId: The application ID used for presentation.
    /// - Parameter coordinator: The coordinator for easier webView presentation handling
    public init(url: String, appId: String, coordinator: PresentCoordinator) {
        self.url = url
        self.appId = appId
        self.path = path.appending(url)
        self.coordinator = coordinator
    }
    
    ///   Appends the chat history path to the constructed URL path.
    ///
    /// - Parameter chatId: The identifier of the chat for which the history is requested.
    ///
    /// - Returns: The [PresentBuilder](x-source-tag://PresentBuilder) instance for method chaining.
    public func chatHistory(_ chatId: Int) -> PresentBuilder {
        path.append("/chat_history/\(chatId)")
        return self
    }

    ///   Appends the article path to the constructed URL path.
    ///
    /// - Parameter articleId: The identifier of the article to be presented.
    ///
    /// - Returns: The [PresentBuilder](x-source-tag://PresentBuilder) instance for method chaining.
    public func article(_ articleId: Int) -> PresentBuilder {
        path.append("/article/\(articleId)")
        return self
    }

    ///   Appends the comments path to the constructed URL path.
    ///
    /// - Returns: The [PresentBuilder](x-source-tag://PresentBuilder) instance for method chaining.
    public func comments() -> PresentBuilder {
        path.append("/comments")
        return self
    }

    ///   Shows the WebView with the constructed path.
    ///
    ///   If the application context is null, a message is logged, and the method returns early. Otherwise, the WebView is started with the constructed path and application ID.
    ///
    ///- Tag: show
    public func show() {
        coordinator?.present(path: path, appId: appId)
    }
}
