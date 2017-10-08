<p align="center">
<img src="https://github.com/shoheiyokoyama/Assets/blob/master/SYBlinkAnimationKit/logo.png">
</p>

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)
 [![Language](https://img.shields.io/badge/language-Swift%203.0-orange.svg)](https://swift.org)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/shoheiyokoyama/SYBlinkAnimationKit/blob/master/LICENSE)

**SYBlinkAnimationKit** is a blink effect animation framework for iOS, written in **Swift** :bowtie:

## :eyes: Demo

There are 5 types of animation for component.

**border**
<p align="left">
<img src="https://github.com/shoheiyokoyama/Assets/blob/master/SYBlinkAnimationKit/Border.gif" width="300" height="55">
</p>

**borderWithShadow**
<p align="left">
<img src="https://github.com/shoheiyokoyama/Assets/blob/master/SYBlinkAnimationKit/BorderWithShadow.gif" width="300" height="70">
</p>

**background**
<p align="left">
<img src="https://github.com/shoheiyokoyama/Assets/blob/master/SYBlinkAnimationKit/Background.gif" width="300" height="70">
</p>

**ripple**
<p align="left">
<img src="https://github.com/shoheiyokoyama/Assets/blob/master/SYBlinkAnimationKit/RippleEffect.gif" width="303" height="45">
</p>

**text**
<p align="left">
<img src="https://github.com/shoheiyokoyama/Assets/blob/master/SYBlinkAnimationKit/Text.gif" width="300" height="70">
</p>

## :octocat: Features
- Animation like blink effect for `UIKit`
- The 5 types of animation : `border`,  `borderWithShadow`,  `background`, `ripple`, `text`
- Easily usable :stuck_out_tongue_closed_eyes:
- Customizable in any properties for animation
- [x] Support Swift 3.0 :tada:
- [x] Support `@IBDesignable` and `@IBInspectable`.
you can change properties in Interface Builder(IB) inspector. then IB update your custom objects automatically.
- [x] Compatible with ***Carthage***

- [x] [SYButton](https://github.com/shoheiyokoyama/SYBlinkAnimationKit/blob/master/Source/SYButton.swift)
- [x] [SYLabel](https://github.com/shoheiyokoyama/SYBlinkAnimationKit/blob/master/Source/SYLabel.swift)
- [x] [SYTextField](https://github.com/shoheiyokoyama/SYBlinkAnimationKit/blob/master/Source/SYTextField.swift)
- [x] [SYView](https://github.com/shoheiyokoyama/SYBlinkAnimationKit/blob/master/Source/SYView.swift)
- [x] [SYTableViewCell](https://github.com/shoheiyokoyama/SYBlinkAnimationKit/blob/master/Source/SYTableViewCell.swift)
- [x] [SYCollectionViewCell](https://github.com/shoheiyokoyama/SYBlinkAnimationKit/blob/master/Source/SYCollectionViewCell.swift)

***Coming Soon***
- [ ] SYTextView
- [ ] SYImageView

## Demo App
Open `Example/SYBlinkAnimationKit.xcworkspace` and run `SYBlinkAnimationKit-Example` to see a simple demonstration.

To run the example project, run `pod install` from the Example directory first.

## :large_orange_diamond: Usage
First, Import **SYBlinkAnimationKit** in class.
```swift
   import SYBlinkAnimationKit
```

**SYBlinkAnimationKit** is designed to be easy to use.

1. Call the SYClass. for example,` SYButton`, `SYLabel`, `SYTextField`, etc.
2. If you use custom animation, call animation method ` startAnimating()`, ` stopAnimating()`

### [SYButton](https://github.com/shoheiyokoyama/SYBlinkAnimationKit/blob/master/Source/SYButton.swift)

<p align="center">
<img src="https://github.com/shoheiyokoyama/Assets/blob/master/SYBlinkAnimationKit/ExampleButton.gif">
</p>

```swift
   let button = SYButton(frame: CGRect(x: 40, y: 50, width: 300, height: 50 ))
   button.setTitle("Border Animation", forState: .normal)
   button.animationType = .border
   view.addSubview(button)

  //Run Animation
  syButton.startAnimating()
  //End Animation
  syButton.stopAnimating()
```

#### Text Animation

Available ***Text Animation*** because of handleable text.

If you change text font size, name, you are supposed to call the `setFont()

```swift
    button
        .setFont(name: "ArialHebew", ofSize: 21)
        .startAnimating()
```

### [SYLabel](https://github.com/shoheiyokoyama/SYBlinkAnimationKit/blob/master/Source/SYLabel.swift)

```swift
   let label = SYLabel(frame: CGRect(x: 40, y: 50, width: 300, height: 50 ))
   label.text = "Text Animation"
   label.labelTextColor =  .darkGray
   label.animationType = .text
   view.addSubview(label)
```

#### Text Animation

`SYLabel` Available ***Text Animation*** because of handleable text.

If you set text color, you are supposed to set the ` labelTextColor` property.
To change text font, use font method as with `SYButton`.

```swift
    label
        .setFont(name: "ArialHebew", ofSize: 21)
        .startAnimating()
```

### [SYTableViewCell](https://github.com/shoheiyokoyama/SYBlinkAnimationKit/blob/master/Source/SYTableViewCell.swift)

<p align="center">
<img src="https://github.com/shoheiyokoyama/Assets/blob/master/SYBlinkAnimationKit/ExampleTableViewCell.gif">
</p>

Inherit `SYTableViewCell`. customize your `TableViewCell` in `UITableViewDataSource`.

```swift
class YourCell: SYTableViewCell {
    ...
```

```swift
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("YourCell", forIndexPath: indexPath) as! YourCell
        cell.animationType = .background
        cell.startAnimating()
        return cell
    }
```

### [SYCollectionViewCell](https://github.com/shoheiyokoyama/SYBlinkAnimationKit/blob/master/Source/SYCollectionViewCell.swift)

Inherit `SYCollectionViewCell`. customize your `CollectionViewCell` in `UICollectionViewDataSource`.

```swift
class YourCell: SYCollectionViewCell {
    ...
```

```swift
func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YourCell", forIndexPath: indexPath) as! YourCell
        cell.animationType = .background
        cell.startAnimating()
        return cell
    }
```

### [SYTextField](https://github.com/shoheiyokoyama/SYBlinkAnimationKit/blob/master/Source/SYTextField.swift)
SYTextField stop animation. when a touch.
but you can control this behavior.
```swift
   //The animation stop. when a touch. default is true
   syTextField.stopAnimationWithTouch = true
```

<p align="center">
<img src="https://github.com/shoheiyokoyama/Assets/blob/master/SYBlinkAnimationKit/SYTextFieldSample.gif" width="350" height="350">
</p>

## :wrench: Customize animation properties

### Animation Type

If you just want to change the types of animation, you can customize `animationType`.

```swift
   // default is border
   var animationType: AnimationType

   // Support 5 types of animation
   enum AnimationType: Int {
        case border
        case borderWithShadow
        case background
        case ripple
        case text
    }
```

#### *inspectable*

Set `animationAdapter` (with Integer) in place of `animationType` in `IB`.

- `border`: 0
- `borderWithShadow`: 1
- `background`: 2
- `ripple`: 3
- `text`: 4

### Animation Color

You can customize the properties of the color.
These properties are *inspectable*.

```swift
   var animationBorderColor: UIColor
```
```swift
   var animationBackgroundColor: UIColor
```
```swift
   var animationTextColor: UIColor
```
```swift
   var animationRippleColor: UIColor
```

### Animation Duration, Timing

You can customize `animationTimingFunction`, `animationDuration`.


```swift
   //default is linear
   var animationTimingFunction: SYMediaTimingFunction

   enum SYMediaTimingFunction: Int {
        case linear
        case easeIn
        case easeOut
        case easeInEaseOut
   }

```

```swift
   //default is 1.5
   public var animationDuration: CGFloat
```

#### *inspectable*

Set `animationTimingAdapter` (with Integer) in place of `animationTimingFunction` in `IB`.

- `linear`: 0
- `easeIn`: 1
- `easeOut`: 2
- `easeInEaseOut`: 3

### Customize Animatable Text

You can customize Animatable Text alignment.
Support 9 types of alignment.
Available `SYButton`, `SYLabel` now.

````swift
    var textAlignmentMode: TextAlignmentMode

    enum TextAlignmentMode {
        case topLeft, topCenter, topRight
        case left, center, right
        case bottomLeft, bottomCenter, bottomRight
    }
````

### Whether animating or not

If SYClass is in middle of animation, this property is `true`
```swift
   public var isAnimating: Bool
```

## :computer: Installation

### CocoaPods

***SYBlinkAnimationKit*** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SYBlinkAnimationKit"
```


### Carthage

Add the following line to your `Cartfile`:

```ruby
github "shoheiyokoyama/SYBlinkAnimationKit"
```

## :pencil: Requirements
- iOS 8.3+
- Xcode 9.0+
- Swift 3.2+

## :coffee: Author

Shohei Yokoyama, shohei.yok0602@gmail.com

## :unlock: License

***SYBlinkAnimationKit*** is available under the MIT license. See the [LICENSE file](https://github.com/shoheiyokoyama/SYBlinkAnimationKit/blob/master/LICENSE) for more info.
