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

## Notes
  * In order for `Endpoint.swift` to work as intended, your project should have the a scheme for development and one for production. The reason for this is because values in `Endpoint.swift` depend on if `DEV_SERVER` is `true` or `false`. 
  * `DEV_SERVER` is `true` when you are running on a development scheme.
  * To create a scheme for development, follow the steps below:
  1. Click on `New Scheme`
  2. Create a title for your scheme, i.e. `Clicker Dev Server`.
  3. Make sure that the `Build Configuration` for the `Run` tab is `Debug Dev Server`.
  * To create a scheme for production, repeat the steps above except that the `Build Configuration` for the `Run` tab should be `Debug`.
