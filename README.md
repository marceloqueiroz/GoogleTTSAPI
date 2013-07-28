GoogleTTSAPI
============

Google Text to Speech API is an iOS drop-in class that adds text to speech functionality to your app.
The API was developed using an undocumented Google APIs.

## Requirements

GoogleTTSAPI works on any iOS version and is compatible with both ARC projects. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* Foundation.framework
* UIKit.framework

## Usage

GoogleTTSAPI provides two methods that can be used to convert your text. Both of them are executed on background.

```objective-c
NSString *text = @"Hello world";
NSString *language = @"en";
[GoogleTTSAPI textToSpeechWithText:text andLanguage:language success:^(NSData *data) {
	// Handle the returned NSData. Typically write it to a file and then play it
} failure:^(NSError *error) {
	// Handler error here
}];
```

When the language is not provided, the GoogleTTSAPI uses the device's current locale.
```objective-c
NSString *text = @"Hello world";
[GoogleTTSAPI textToSpeechWithText:text success:^(NSData *data) {
	// Handle the returned NSData. Typically write it to a file and then play it
} failure:^(NSError *error) {
	// Handler error here
}];
```

For more details, take a look at the bundled demo project.


## License

This code is distributed under the terms and conditions of the [Apache v2 License](LICENSE). 

## Change-log

A brief summary of each GoogleTTSAPI release can be found on the [wiki](https://github.com/marceloqueiroz/GoogleTTSAPI/wiki/Change-log)

