#import "PixelColor.h"
#import <UIKit/UIKit.h>

@implementation PixelColor
RCT_EXPORT_MODULE()

- (void)getPixelColor:(NSString *)base64Png
                    x:(double)x
                    y:(double)y
             resolve:(RCTPromiseResolveBlock)resolve
             reject:(RCTPromiseRejectBlock)reject
{
    @try {
        NSArray *parts = [base64Png componentsSeparatedByString:@","];
        NSString *pureBase64 = (parts.count > 1) ? parts.lastObject : base64Png;

        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:pureBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        if (!imageData) {
            reject(@"decode_error", @"Failed to decode base64 image", nil);
            return;
        }

        UIImage *image = [UIImage imageWithData:imageData];
        if (!image) {
            reject(@"image_error", @"Failed to create UIImage from data", nil);
            return;
        }

        CGImageRef cgImage = [image CGImage];
        NSUInteger width = CGImageGetWidth(cgImage);
        NSUInteger height = CGImageGetHeight(cgImage);

        if (x < 0 || y < 0 || x >= width || y >= height) {
            reject(@"bounds_error", @"Coordinates out of image bounds", nil);
            return;
        }

        unsigned char pixelData[4] = {0};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(pixelData,
                                                     1,
                                                     1,
                                                     8,
                                                     4,
                                                     colorSpace,
                                                     kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);

        if (!context) {
            CGColorSpaceRelease(colorSpace);
            reject(@"context_error", @"Failed to create bitmap context", nil);
            return;
        }

        CGContextDrawImage(context, CGRectMake(-x, y - height + 1, width, height), cgImage);

        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);

        NSDictionary *result = @{
            @"red": @(pixelData[0]),
            @"green": @(pixelData[1]),
            @"blue": @(pixelData[2]),
            @"alpha": @(pixelData[3])
        };
        resolve(result);
    }
    @catch (NSException *exception) {
        reject(@"exception", exception.reason, nil);
    }
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativePixelColorSpecJSI>(params);
}

@end