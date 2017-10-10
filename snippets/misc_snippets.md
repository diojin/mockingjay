# 		Snippets of miscellaneous techniques
---

## Indexes

* [QueryDSL](#querydsl)
    - [Misc](#querydsl-misc)
        + [QueryDSL Code Examples](#querydsl-code-examples)
* [Handlebar](#handlebar)
    - [Misc](#handlebar-misc)
        + [Handlerbar Code Examples](#handlerbar-code-examples)
* [Android](#android)
    - [Genymotion](#genymotion)
        + [Installation](#installation)
            * [Issues](#genymotion-installation-issue)
    - [Misc](#android-misc)
        + [WebView](#webview)
* [Miscellaneous](#miscellaneous)
    - [Lombok](#lombok)
        + [Examples](#lombok-examples)


## QueryDSL
### QueryDSL Misc
#### QueryDSL Code Examples
[Back To Indexes](#indexes)  
* native query example
```java
@Modifying 
@Query("delete from ZombieCustomerTrace a where a.processGroup is null ") 
void clearHistory(); 
```

* use group to convert result
```java
public Map<Long /*VendorItemId*/,List<BmTransitionAlternativeVendorItem>> findActivatedMapBySkuId(Long skuId){
    Map<Long, List<BmTransitionAlternativeVendorItem>> resultMap = 
    from(qBmTransition, qBmTransitionAlternativeVendorItem)
        .where(qBmTransition.bmTransitionId.eq(qBmTransitionAlternativeVendorItem.bmTransitionId))
        .where(qBmTransitionAlternativeVendorItem.valid.isTrue())
        .transform(groupBy(qBmTransition.vendorItemId).as(list(qBmTransitionAlternativeVendorItem)));
    return Optional.fromNullable(resultMap).or(Maps.<Long, List<BmTransitionAlternativeVendorItem>>newHashMap());
}
```

## Handlebar
[Back To Indexes](#indexes)  
### Handlebar Misc
#### Handlerbar Code Examples
```javascript
{{#each messages}}
  <li style="color:red">
    {{this}}
  </li>
{{/each}}

{{#assign "subsItemIdImgUrl"}}{{this.itemPictureUri}}{{/assign}}
<img src="{{subsItemIdImgUrl}}" height="130px" width="130px"/>

<li {{#when searchCondtion.searchType "equalsAsString" "BMREQUESTED"}}{{else}}class="active"{{/when}}>
    <a id="oosreporttab" data-toggle="tab" href="#oosReportDashboard">OOS Report</a>
</li>
```

## Android
### Genymotion
[Back To Indexes](#indexes)  
#### Installation
##### Genymotion Installation Issue
* Can't download image
find from genymotion.log the actually download link and put it under image path. Something like  
```json
>12月 28 17:14:43 [Genymotion] [debug] Downloading file  "http://dl.genymotion.com/dists/6.0.0/ova/genymotion_vbox86p_6.0_160825_141918.ova"
```

Configuration {HOME} for genymotion:   
Windows:    C:\Users\{username}\AppData\Local\Genymobile  
Mac OS:     /Users/diojin/.Genymobile  

log path:   ${HOME}/genymotion.log  
image path: ${HOME}/Genymotion/ova  

* Can't upgrade virtual device after upgration of Genymotion  
due to non license, need to re-config a new virtual device

### Android Misc
#####WebView
* The WebView Strategy for Creating Mobile Apps
[***The WebView Strategy for Creating Mobile Apps***][webview_strategy]

__THE CHALLENGE__

Both Android and iPhone (iOS) development are separate beasts. For example, if you create an Android app, you must rewrite it as a port to iPhone. `All that hard work x2`. It isn’t ideal, but we do what we have to do to work around the limitations imposed on what we can develop.


__AN 80% SOLUTION__

However, there is hope. There is a way to reuse 80% of our application code for BOTH iOS and Android development. The strategy to do this is to write your app using web technologies: `CSS, HTML, and JavaScript`, then configure a WebView (a container for web pages) in your native phone app to render your app pages (saving user preferences, dynamic content, graphics, etc…). HTML5, CSS, and JavaScript should be sufficient to do all of these things INSIDE the WebView of whatever device has WebView support.


__WEBVIEW STRATEGY__

A WebView app is composed primarily of `Javascript, CSS, and HTML files`. Basically, your app is one or more web pages. These web pages make up your frontend interface. The “WebView” is the window through which your device displays these web pages.

Normally, when a user views web pages, they use a browser. However, a WebView replaces a “browser.” Instead of allowing users to change web pages, the WebView only displays pages related to your app.

Mechanically, your app is a bunch of web pages. `However, aesthetically, it appears to be a normal app`. This is the WebView strategy.

__WHERE DO YOUR WEB FILES LIVE?__

>Distributed Code vs Centralized Hosting

`Web app packaged with the phone app`:
`Primary Benefits`:

* Works Offline. No internet connection is required for devices accessing the app, unless some of your app content depends on external data.
* Initial Load Time. The app is loaded locally on the device, so theoretically, initial load time should be faster.

`Primary Drawbacks`:

* Deploying updates. Any change to the app code, must be rolled out to the app store where your app is hosted (before the update can make it out to user devices).

* App size. Your app must host more local code/data on the device. So the distributed app will be a larger size.

`Web app stored in a central location`:

`Primary Benefits`:

* Deploying updates. Any update you make to your centralized code will immediately take affect on all devices that access this centralized code. Users don’t even need to update your app for your changes to take affect.
* App size. Since most of your code is stored in a single location, the downloadable app is very light-weight. Phones that run the app don’t have to store very many files or data.

`Primary Drawbacks`:

* Online required. An internet connection is required to access the app. If a device tries to use your app in airplane mode, for example, then the user should get some sort of “no connection” message.
* Initial load time. Devices access your codebase remotely. This may add additional front-loading time.
Front-loading speed will depend on the quality of the user’s connection to the internet.

`Disclaimer`: This list of pros and cons are not all inclusive. For example, you should also consider what should happen if your centralized host crashes. Instead of having devices trying to access a broken server, you could design a backup procedure where devices fall back to locally cached data. But such additional considerations are beyond the scope of this article. Let’s just keep things simple for now. Where should your app live? This is up to you.

__THE OTHER 20%__

`PLATFORM-SPECIFIC EXAMPLES`

What mechanics of your app cannot be written in web languages, like Javascript, HTML, and CSS? Here are some of the mechanics that I had to tackle (for each platform) when building a dual-platform WebView app.

These are some examples of development considerations that may comprise the remaining 20% of development; stuff that Javascript, HTML, and CSS may not be able to handle in an app.
Only platform-specific code may be able to handle these things:

This is a job for Objective-C, IOS / Java, Android…

* App start. You need code to tell your app what to do when it starts. Is there a splash screen? What URL will your WebView open? Will you need to display a loading icon until the URL fully loads inside your WebView?
* Title bars. By default, your app may display a title bar. But if you are using the WebView strategy, you may want to write platform code to hide the title bar. A title bar may be written inside of the WebView with HTML and CSS, instead.
* Back button. On Android, you may have to write a little Java to tell the WebView how to handle back button presses. Otherwise, the default back button behavior may simply close your app instead of going to a previous view.
* Remove letter-boxing. iPhones may “letter-box” your app… until you add a splash screen. The app looks at the splash screen image to determine app dimensions (without letter-boxing).
* Orientation changes. On Android, your WebView may reload when the orientation changes. In most cases, you want to prevent this by writing some custom Java code.
* External links. Are there any external links in your app? When the user presses one, what should happen? Should it open a separate browser app, or should the external link appear inside your app?
* No internet connection. If your WebView connects with an external host, what happens if the device is NOT connected when the user opens the app? You may need to write a little extra code to detect this error and display a message.

__PHONEGAP CAN FILL IN THE OTHER 20% (ONE ALTERNATIVE)__

[PhoneGap] will try to minimize the amount of platform-specific code you have to write by providing pre-packaged “boiler-plates”. PhoneGap intends on handling the mechanics of your WebView on different platforms. You can focus on developing web content to fill PhoneGap’s pre-written WebView.

PhoneGap is great for pre-packaged functionality. However, it will make it more difficult for you to fine-tune the mechanics of your app… unless the mechanics, that you want, are already pre-packaged.



## Miscellaneous
[Back To Indexes](#indexes)  
### Lombok
[Back To Indexes](#indexes)  
#### Lombok Examples
```java
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@ToString
@EqualsAndHashCode
@Data               // ps; to generate a mutable class
@Value              // ps: to generate a immutable class
```

---