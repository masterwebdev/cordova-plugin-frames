#import "AVFrame.h"

#import <mach/mach.h>
#import <mach/mach_host.h>

@implementation AVFrame

- (void)getframe:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* path = [command.arguments objectAtIndex:0];
    NSString* position = [command.arguments objectAtIndex:1];

    if (myarg != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end

