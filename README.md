# BitcoinRate

Hi, fellow Reviewer,

This document will help you build the project and walk you through into some of the specifics of the project. I hope you’ll enjoy reviewing my code.

Cheers !

## Requirements

- Xcode 9.3+ 
- iOS 11.0+ 
- Swift 4.0+

## Building the project

This project use [Cocoapods](https://cocoapods.org). Tap the following commands in the root directory 

```
$> sudo gem install cocoapods
$> pod install
```

It will generate a file **BitcoinRate.xcworkspace**. Open the project with it (not with BitcoinRate.xcodeproj)

## Project Architecture

The architecture evolves around “Stories” where, in the future, whenever the project grows, we can separate different screen logic that represent a new story (ex: Login screens, User Settings screens).

A Story is composed of a Storyboard, ViewControllers, ViewModels and Views directories. This way, it is easy to navigate between classes that are linked inside a same story.

![GitHub Logo](documentation/doc_stories.png)

When possible, MVVM is used.

## Known issues

//TODO

## Cocoapods

One framework is used with Cocoapods:

#### StringExtensionHTML

Small helper to nicely convert html code to formatted string. (Coindesk api returns symbols' codes)

## Testing

To test different parts of the project, I use the Xcode test framework.