# MTSandBoxBrowser

[![CI Status](https://img.shields.io/travis/sqzxcv/MTSandBoxBrowser.svg?style=flat)](https://travis-ci.org/sqzxcv/MTSandBoxBrowser)
[![Version](https://img.shields.io/cocoapods/v/MTSandBoxBrowser.svg?style=flat)](https://cocoapods.org/pods/MTSandBoxBrowser)
[![License](https://img.shields.io/cocoapods/l/MTSandBoxBrowser.svg?style=flat)](https://cocoapods.org/pods/MTSandBoxBrowser)
[![Platform](https://img.shields.io/cocoapods/p/MTSandBoxBrowser.svg?style=flat)](https://cocoapods.org/pods/MTSandBoxBrowser)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MTSandBoxBrowser is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MTSandBoxBrowser'
```

## Usage

##### swift code
`import MTSandBoxBrowser`
```javascript
let vc = MTSandBoxBrowserViewController()
let nav = UINavigationController(rootViewController: vc)
self.present(nav, animated: true, completion: nil)
```
##### OC   code:
`#import <MTSandBoxBrowser/MTSandBoxBrowser-Swift.h>`  , `#import "Hey-Swift.h"`
```
- (void)goToReadLocalLogController {
MTSandBoxBrowserViewController *vc = [MTSandBoxBrowserViewController new];
vc.savePath = [NSString stringWithFormat:@"%@/Library/Caches/MTLogs/",NSHomeDirectory()];
UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
[self presentViewController:nav animated:YES completion:nil];
}
```

## Author

sqzxcv, sqzxcv@gmail.com
  
hebing, 1101918842@qq.com

## License

MTSandBoxBrowser is available under the MIT license. See the LICENSE file for more info...


###### [See More MTSandBoxBrowser  Usage For Chinese](https://www.jianshu.com/p/18fd91f3feb7 "See More MTSandBoxBrowser  Usage For Chinese")
