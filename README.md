<h1 align="center">
  
  ![github_50](https://user-images.githubusercontent.com/12243409/163683336-f5338315-d5b5-4154-ad29-240d66feff3b.png)
  <br> Ballroom Marketplace </br>
</h1>
<p><font size="3">
<strong>Ballroom Marketplace</strong> is a C2C (customer to customer) buy and sell app that enables people to exchange used ballroom dance performance wear. App Store Link: https://apps.apple.com/us/app/ballroom-marketplace/id1619576867

<h1 align="center">
<img width="974" alt="image" src="https://user-images.githubusercontent.com/12243409/177062383-ca196213-3b7c-4470-bd48-735df9348c4d.png">
</h1>

<p><font size="3">
Two things that make this app special are (1) JSON driven templates for clothing items and (2) options for both standard sizes and specific measurements.</p>
  
<p><font size="3">
(1) Our JSON driven template system allows a <strong>non-technical</strong> person with no coding experience to add a new item type to the application. Since these screens are driven by JSON stored on the web server, templates can also be added/edited without a new app release. Furthermore, all images are stored on the server, so they too can be changed without a new app release.</p>
  
<h1 align="center">
  <img width="600" alt="image" src="https://user-images.githubusercontent.com/12243409/177051762-f9da2632-3ffd-47a1-9f74-a386edafa11b.png">
</h1>
  
<p><font size="3">
(2) A general issue in the fashion and e-commerce space is that standard sizes aren't really standard. An XS in Taiwan is not the same as an XS in Canada. Also, standard sizing is incompatible with so-called 'non-standard' body proportions; after all, most people don't fit a simple formula where their height and waist circumfrence are enough to determine measurements like inseam and sleeve length. See this screenshot for an example:

<h1 align="center">
<img width="250" alt="image" src="https://user-images.githubusercontent.com/12243409/177071544-a1a5977f-2556-4b41-9b6c-fae3d88a5c1b.png">
</h1>

So, in this app, the users are encouraged to enter specific measurements rather than standard sizes; however, our algorithm also allows for estimated conversion between these two sizing methods.</p>
  
<p><font size="3">
Three Technical Notes</p>

1. The app uses MVVM architecture and UIKit to ensure proper code isolation and testability. It would have also been appropriate (and likely better) to use SwiftUI; however, at the time of initial development I was not familiar with it.

2. To avoid excessive reliance on completion and error handlers, we adopted the new structured concurrency model solidified in Swift 5.5.

3. All APIs follow Apple's official API design guidelines outlined here: https://www.swift.org/documentation/api-design-guidelines/ - However, for simplicity I have only chosen to document private (non-standard) methods
