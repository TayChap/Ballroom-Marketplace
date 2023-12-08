<h1 align="center">
  
  ![github_50](https://user-images.githubusercontent.com/12243409/163683336-f5338315-d5b5-4154-ad29-240d66feff3b.png)
  <br> Ballroom Marketplace </br>
</h1>

<p><font size="3">
<strong>Ballroom Marketplace</strong> is a C2C (customer to customer) buy and sell app that enables people to exchange used ballroom dance performance wear. App Store Link: https://apps.apple.com/us/app/ballroom-marketplace/id1619576867


<p><font size="3">
Three Technical Notes:</p>

1. The app uses MVVM architecture and UIKit to ensure proper code isolation and testability.

2. To avoid excessive reliance on completion and error handlers, we adopted the new structured concurrency model solidified in Swift 5.5: https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html

3. All APIs follow Apple's official API design guidelines outlined here: https://www.swift.org/documentation/api-design-guidelines/ - However, for simplicity I have only chosen to document private (non-standard) methods.

<h1 align="center">
<img width="974" alt="image" src="https://user-images.githubusercontent.com/12243409/177062383-ca196213-3b7c-4470-bd48-735df9348c4d.png">
</h1>
