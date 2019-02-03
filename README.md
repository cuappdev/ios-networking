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
Replace `http://example.server.com` under `api-url` with the host of your backend server 

## Important Notes
  * In order for `Endpoint.swift` to work as intended, your project should have the a scheme for **development** and one for **production**. The reason for this is because values in `Endpoint.swift` depend on if `DEV_SERVER` is `true` or `false`. 
  * This [article](https://zeemee.engineering/how-to-set-up-multiple-schemes-configurations-in-xcode-for-your-react-native-ios-app-7da4b5237966) explains the whole process of creating a new scheme and integrating into your app really well so it is highly recommended that you check it out!
  * `DEBUG` is `true` when you are running on a development scheme.
  * To create a scheme for development, follow the steps below:
  1. Click on `New Scheme`
  2. Create a title for your scheme, i.e. `Clicker Debug`. Note that, as the article above describes, you can create your own custom build setting and create a scheme just for that.
  3. Make sure that the `Build Configuration` for the `Run` tab is `Debug`. Doing this will ensure that whenever you `Run` your application from XCode, `DEBUG` will be true.
  * To create a scheme for production, repeat the steps above except that the `Build Configuration` for the `Run` tab should be `Debug`.
