<img align="right" alt="Deskpro" src="https://raw.githubusercontent.com/DeskproApps/bitrix24/master/docs/assets/deskpro-logo.svg" />

 
# messenger-sdk-ios

![Messenger SDK iOS OS](https://img.shields.io/badge/Platforms-_iOS_-Green?style=flat-square)
![Messenger SDK iOS LANGUAGES](https://img.shields.io/badge/Languages-Swift_|_ObjC-orange?style=flat-square)
![Messenger SDK iOS SPM](https://img.shields.io/badge/Swift_Package_Manager-compatible-green?style=flat-square)

DeskPro iOS Messenger is a Chat/AI/Messaging product. You can embed a “widget” directly into native app, so that enables end-users to use the product. Similar implementation for [Android](https://github.com/deskpro/messenger-sdk-android).

## Requirements 

- iOS 11.0+
- Swift 5.7+
- Xcode 14.0+


## Installation

- File > Swift Packages > Add Package Dependency
- Add `https://github.com/deskpro/messenger-sdk-ios`
- Select `Up to Next Major` version

## Manual installation
Although we recommend using SPM, it is also possible to clone this repository manually, and drag and drop it into the root folder of the application.

## Initialization (Swift)
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


## Initialization (Objective-C)
First, import the SDK:
```
@import messenger_sdk_ios;
```

Then, in your ViewController.h:
```
@property (strong, nonatomic) MessengerConfig *messengerConfig;
@property (strong, nonatomic) DeskPro *messenger;
```

Then, in your ViewController.m:
```
- (void)viewDidLoad {
    [super viewDidLoad];

    self.messengerConfig = [[MessengerConfig alloc] initWithAppUrl:@"YOUR_APP_URL" appId:@"YOUR_APP_ID" appKey:@"YOUR_APP_KEY"];
    self.messenger = [[DeskPro alloc] initWithMessengerConfig:self.messengerConfig containingViewController:self enableAutologging:false];
}
```

Replace `YOUR_APP_URL` and `YOUR_APP_ID` with your app's URL and ID, and `YOUR_APP_KEY` with you app's KEY, or nil.


To open a Messenger, paste this line example in the desired place:
```
[[self.messenger present] show];
```


Note: You can create multiple Messenger instances.


### Setting user info (Swift)
```
messenger?.setUserInfo(user: userObject)
```

### Setting user info (Objective-C)
```
[self.messenger setUserInfoWithUser:userObject];
```

Note: User(name, firstName, lastName, email)

### Authorize user (Swift)
```
messenger?.authorizeUser(jwtToken: jwtToken)
```

### Authorize user (Objective-C)
```
[self.messenger authorizeUserWithUserJwt:jwtToken];
```

### Push notifications (Swift)
```
messenger?.setPushRegistrationToken(token: token)
```

### Push notifications (Objective-C)
```
[self.messenger setPushRegistrationTokenWithToken:token];
```


Prerequisite: The application should be connected to the notifications platform, enabled for receiving notifications and obtaining tokens.



## Privacy

In order to make the file upload and download fully work, make sure to add these permissions with appropriate messages in your `Info.plist` file:
- Privacy - Camera Usage Description
- Privacy - Microphone Usage Description
- Privacy - Photo Library Additions Usage Description

## Versioning
We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/deskpro/messenger-sdk-ios/tags).

