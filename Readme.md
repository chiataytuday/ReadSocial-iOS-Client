ReadSocial Objective-C Library
==============================

[ReadSocial](http://readsocial.net) is a service that adds social features to your content quickly and easily. [Learn more](https://www.readsocial.net/about/team)

The Objective-C library takes care of the common tasks required to enable social reading within your iOS application. This is project includes the code library, the UI, and shows its implementation in a sample app.

Getting Started
---------------
If you just want to see ReadSocial in action, simply download and build the sample project (requires iOS 5). It will demo the ReadSocial API Objective-C library using the article *As We May Think*, by Vannevar Bush. We encourage you to use the [web demo](https://api.readsocial.net/vbush.html?rid=8) at the same time so you can get a feel for how different clients on different platforms can interct with the ReadSocial platform.

Adding ReadSocial to a new app
------------------------------
There are two parts to the library: the API--which handles communication and data between the app and the server, and the UI--which allows the user to interact with the service. You'll need to copy both sections of code into your app.

### 1. Initialize ReadSocial.
In your AppDelegate, initialize ReadSocial with the settings you want, including:

* Network ID
* Default group
* UI library to use

For example:

    #import "ReadSocialAPI.h"
    #import "ReadSocialUI.h"
    
    [ReadSocial initializeWithNetworkID : [NSNumber numberWithInt:8]
                defaultGroup            : @"partner-testing-channel" 
                andUILibrary            : [ReadSocialUI library]
                ];

### 2. Add ReadSocial actions to a "page" of content.
Although your content may not conform to a typical "page" as most users may think of, a "page" in this case simply refers to a collection of paragraphs. It may be one screen full, one chapter full, or literally one page full. It's up to you!

For example:

    [ReadSocial setCurrentPageAndDelegate:self];

(where `self` is a UIViewController).

### 3. Conform your UIViewController to ReadSocialDataSource.
ReadSocial needs to know where how to get the content your user is interacting with. You do that by implementing the `ReadSocialDataSource` protocol and defining the following methods:

* `- (NSInteger) numberOfParagraphsOnPage;`
* `- (NSString *) paragraphAtIndex: (NSInteger)index;`
* `- (CGRect) rectForParagraphAtIndex: (NSInteger)index;`
* `- (NSInteger) paragraphIndexAtSelection;`
* `- (NSString *) selectedText;`

See ViewController.m for an example of how to implement these methods.

### 4. Enable ReadSocial actions
The final step you need to do is trigger ReadSocial to open at different points. We recommend implementing a custom UIMenuItem to appear when a user selects text. Again, take a look at ViewController.m to see an example of how this could be done.

Current Limitations/Issues
-----------
ReadSocial uses Core Data to organize and store data from the service and from the user. Currently, it requires that the implementing app start with the Core Data Xcode template. We're working to remove this requirement very soon.