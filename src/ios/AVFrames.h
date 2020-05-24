#import <Cordova/CDV.h>

@interface AVFrames : CDVPlugin

- (void) getframe:(CDVInvokedUrlCommand*)command;
- (void) getframe1:(CDVInvokedUrlCommand*)command;
- (UIImage*) compressImage:(UIImage *)image;

@end
