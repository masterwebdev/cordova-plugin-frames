#import <Cordova/CDV.h>

@interface AVFrames : CDVPlugin

- (void) getframe:(CDVInvokedUrlCommand*)command;
- (UIImage*) compressImage:(UIImage *)image;

@end
