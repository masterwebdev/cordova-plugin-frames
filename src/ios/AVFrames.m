#import "AVFrames.h"

#import <AVFoundation/AVAsset.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>


#import "CDVJpegHeaderWriter.h"
#import "UIImage+CropScaleOrientation.h"
#import <ImageIO/CGImageProperties.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>
#import <ImageIO/CGImageDestination.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <objc/message.h>

#ifndef __CORDOVA_4_0_0
#import <Cordova/NSData+Base64.h>
#endif

@implementation AVFrames

int fcnt;

- (void)getframe:(CDVInvokedUrlCommand*)command
{

    //[self.commandDelegate runInBackground:^{
        //CDVPluginResult* pluginResult = nil;
        NSString* path = [command.arguments objectAtIndex:0];
        //NSString* position = [command.arguments objectAtIndex:1];
        NSArray* position = [command.arguments objectAtIndex:1];
    
        NSMutableArray* results = [NSMutableArray array];
    int cnt = 0;
    
    fcnt=0;
    
        NSURL *url = [NSURL fileURLWithPath:path];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    CGSize maxSize = CGSizeMake(153, 115);
    generator.maximumSize = maxSize;
    
    NSMutableArray *times = [NSMutableArray array];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    for (id p in position) {
        int pos=[p intValue];
        CMTime time = CMTimeMake(pos, 1000);
        NSValue *timeValue = [NSValue valueWithCMTime:time];
        [times addObject:timeValue];
        cnt++;
    }
    
    NSString *tmpDirectory = NSTemporaryDirectory();
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        fcnt=fcnt+1;
        NSLog(@"Frames count %d", fcnt);
        
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        
        UIImage *frameImage = [UIImage imageWithCGImage:im];

        NSString *uuid = [[NSUUID UUID] UUIDString];
        NSString *fpath = [tmpDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", uuid]];
        [UIImageJPEGRepresentation(frameImage, 0.85) writeToFile:fpath atomically:YES];
        
        [results addObject:fpath];
        
        frameImage=nil;
        //image=nil;
        
        //CGImageRelease(finalCImage);
        
        if(cnt == [results count]){
        
        CDVPluginResult* cresult = [CDVPluginResult
                                    resultWithStatus:CDVCommandStatus_OK
                                    messageAsArray:results];
        
        [self.commandDelegate sendPluginResult:cresult callbackId:command.callbackId];
            
        }
        //CGImageRelease(im);
        
    };
    
    [generator generateCGImagesAsynchronouslyForTimes:times completionHandler:handler];
    
}

- (void)getframe2:(CDVInvokedUrlCommand*)command
{
    
    //CDVPluginResult* pluginResult = nil;
    NSString* path = [command.arguments objectAtIndex:0];
    NSString* position = [command.arguments objectAtIndex:1];
    
    int pos=[position intValue];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]){
        NSLog(@"Exists: %@", path);
    }
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    
    CMTime time = CMTimeMake(pos, 1000);
    
    NSMutableArray *times = [NSMutableArray array];
    NSValue *timeValue = [NSValue valueWithCMTime:time];
    [times addObject:timeValue];
    
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    //generator.requestedTimeToleranceAfter = kCMTimeZero;
    //generator.requestedTimeToleranceBefore = kCMTimeZero;
    CGSize maxSize = CGSizeMake(204, 115);
    generator.maximumSize = maxSize;
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        
        UIImage *frameImage = [UIImage imageWithCGImage:im];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *uuid = [[NSUUID UUID] UUIDString];
        NSString *fpath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", uuid]];
        [UIImageJPEGRepresentation(frameImage, 1.0) writeToFile:fpath atomically:YES];
        
        CDVPluginResult* cresult = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsString:fpath];
        
        //CGImageRelease(im);
        
        [self.commandDelegate sendPluginResult:cresult callbackId:command.callbackId];
        
        /*dispatch_async(dispatch_get_main_queue(), ^{
            NSData *imageData = UIImageJPEGRepresentation(frameImage, 1.0);
            
            //NSLog(@"%@", imageData);
            
            NSString *base64String = [imageData base64EncodedStringWithOptions:0];
            //NSLog(@"BASE64: %@", base64String);
            
            CDVPluginResult* result = [CDVPluginResult
                                       resultWithStatus:CDVCommandStatus_OK
                                       messageAsString:base64String];
            
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        });*/
    };
    [generator generateCGImagesAsynchronouslyForTimes:times completionHandler:handler];
    
}

- (void)getframe1:(CDVInvokedUrlCommand*)command
{
    
    CDVPluginResult* pluginResult = nil;
    NSString* path = [command.arguments objectAtIndex:0];
    NSString* position = [command.arguments objectAtIndex:1];
    
    int pos=[position intValue];
    
    
    NSLog(@"Path: %@", path);
    
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]){
        NSLog(@"Exists: %@", path);
    }
    
    
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSLog(@"Position: %d", pos);
    
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    //////[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:path] options:nil];
    AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *error = NULL;
    CMTime time = CMTimeMake(pos, 1000);
    CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
    NSLog(@"error==%@, Refimage==%@", error, refImg);
    
    UIImage *FrameImage= [[UIImage alloc] initWithCGImage:refImg];
     
    CFRelease(refImg);
    
    UIImage *thumb = [self compressImage:FrameImage];
            
            NSData *imageData = UIImageJPEGRepresentation(thumb, 1.0);
            
            //NSLog(@"%@", imageData);
            
            NSString *base64String = [imageData base64EncodedStringWithOptions:0];
            //NSLog(@"BASE64: %@", base64String);
            
            CDVPluginResult* result = [CDVPluginResult
                                       resultWithStatus:CDVCommandStatus_OK
                                       messageAsString:base64String];
            
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    
    
}


-(UIImage *)compressImage:(UIImage *)image{
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1); //1 it represents the quality of the image.
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imgData length]);
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 115.0;
    float maxWidth = 204.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imageData length]);
    
    return [UIImage imageWithData:imageData];
}


- (void)getframe3:(CDVInvokedUrlCommand*)command
{
    
    //[self.commandDelegate runInBackground:^{
    //CDVPluginResult* pluginResult = nil;
    NSString* path = [command.arguments objectAtIndex:0];
    //NSString* position = [command.arguments objectAtIndex:1];
    NSArray* position = [command.arguments objectAtIndex:1];
    
    NSMutableArray* results = [NSMutableArray array];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    
    CGSize newSize=CGSizeMake(153, 115);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    for (id p in position) {
        int pos=[p intValue];
        CMTime time = CMTimeMake(pos, 1000);
        
        CGImageRef finalCImage=[generator copyCGImageAtTime:time actualTime:nil error:nil];
        UIImage* image = [UIImage imageWithCGImage:finalCImage];
        
        UIGraphicsBeginImageContextWithOptions(newSize, YES, image.scale);
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* frameImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSString *uuid = [[NSUUID UUID] UUIDString];
        NSString *fpath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", uuid]];
        [UIImageJPEGRepresentation(frameImage, 0.85) writeToFile:fpath atomically:YES];
        
        [results addObject:fpath];
        
        frameImage=nil;
        image=nil;
        
        CGImageRelease(finalCImage);
    }
    
    CDVPluginResult* cresult = [CDVPluginResult
                                resultWithStatus:CDVCommandStatus_OK
                                messageAsArray:results];
    
    [self.commandDelegate sendPluginResult:cresult callbackId:command.callbackId];
    //}];
    
}

@end

