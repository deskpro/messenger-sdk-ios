<img align="right" alt="Deskpro" src="https://raw.githubusercontent.com/DeskproApps/bitrix24/master/docs/assets/deskpro-logo.svg" />


# messenger-sdk-ios

![Messenger SDK iOS SWIFT](https://img.shields.io/badge/Swift-5.7_5.8_5.9-Orange?style=flat-square)
![Messenger SDK iOS OS](https://img.shields.io/badge/Platforms-_iOS_-Green?style=flat-square)
![Messenger SDK iOS SPM](https://img.shields.io/badge/Swift_Package_Manager-compatible-green?style=flat-square)
![Messenger SDK iOS CI](https://github.com/deskpro/messenger-sdk-ios/actions/workflows/main.yml/badge.svg)

DeskPro iOS Messenger is a Chat/AI/Messaging product. You can embed a “widget” directly into native app, so that enables end-users to use the product. Similar implementation for [Android](https://github.com/deskpro/messenger-sdk-android).

## Requirements

- iOS 11.0+
- Swift 5.7+
- Xcode 14.0+


## Installation

- File > Swift Packages > Add Package Dependency
- Add `https://github.com/deskpro/messenger-sdk-ios`
- Select "Up to Next Major" version

## Manual installation
Although we recommend using SPM, it is also possible to clone this repository manually, and drag and drop it into the root folder of the application.

## Setup and Initialization
First, import the SDK:
```
import messenger_sdk_ios
```

Then, in your ViewController:
```
let messengerConfig = MessengerConfig(appUrl: "YOUR_APP_URL", appId: "YOUR_APP_ID")
var messenger: DeskPro?
```

Replace `YOUR_APP_URL` and `YOUR_APP_ID` with your app's URL and ID.

```
override func viewDidLoad() {
    super.viewDidLoad()    
    messenger = DeskPro(messengerConfig: messengerConfig, containingViewController: self)
}
```


To open a Messenger, paste this line example in the desired place:
```
messenger?.present().show()
```

Note: You can create multiple Messenger instances.

### Setting user info
```
messenger?.setUserInfo(user: userObject)
```
Note: User(name, firstName, lastName, email)

### Authorize user
```
messenger?.authorizeUser(jwtToken: jwtToken)
```

### Push notifications
```
messenger?.setPushRegistrationToken(token: token)
```
Prerequisite: The application should be connected to the notifications platform, enabled for receiving notifications and obtaining tokens.

## Versioning
We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/deskpro/messenger-sdk-ios/tags).

