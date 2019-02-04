# AppDev iOS Networking 

This repo contains the two files used for iOS Networking in [Cornell AppDev](http://cornellappdev.com), a project team at Cornell University.

## Use
To use this in your XCode project, simply copy and paste these two files into your project. Later on, this will be made into a pod so that updates to these files can get retrieved more easily.

## Configuration
Create a `/Secrets/Keys.plist` plist file in the project directory with the following template:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>api-url</key>
	<string>example.server</string>
</dict>
</plist>
```
Replace `example.server` under `api-url` with the host of your backend server 

## Important Notes
  * In order for `Endpoint.swift` to work as intended, your project should have the a scheme for **development** and one for **production**. The reason for this is because values in `Endpoint.swift` depend on if the `DEBUG` flag is `true` or `false`. 
  * This [article](https://zeemee.engineering/how-to-set-up-multiple-schemes-configurations-in-xcode-for-your-react-native-ios-app-7da4b5237966) explains the whole process of creating a new scheme and integrating into your app really well so it is highly recommended that you check it out! This [stack overflow post](https://stackoverflow.com/questions/38813906/swift-how-to-use-preprocessor-flags-like-if-debug-to-implement-api-keys) is also good to look at if you want to understand how to add custom conditional swift compilation flags.
  * `DEBUG` is `true` when you are running on a development scheme.
  * To create a scheme for development, follow the steps below:
  1. Click on `New Scheme`

  ![screen shot 2019-01-28 at 11 37 58 pm](https://user-images.githubusercontent.com/26048121/51884811-d9d0a500-2356-11e9-954a-5e4e83fb35bb.png)

  2. Create a title for your scheme, i.e. `Clicker Debug`. Note that, as the article above describes, you can create your own custom configuration  and create a scheme just for that.
  3. Make sure that the `Build Configuration` for the `Run` tab is `Debug`. Doing this will ensure that whenever you `Run` your application from XCode, `DEBUG` will be true.
  
  ![screen shot 2019-02-03 at 1 04 23 am](https://user-images.githubusercontent.com/26048121/52173293-b1c6b480-274f-11e9-97dc-c2d73d8150cb.png)
  * To create a scheme for production, repeat the steps above except that the `Build Configuration` for the `Run` tab should be `Debug`.
