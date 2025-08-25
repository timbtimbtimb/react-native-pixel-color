#import "PixelColor.h"
#import <React/RCTBridgeModule.h>
#import <UIKit/UIKit.h>

@implementation PixelColor
RCT_EXPORT_MODULE()

RCT_REMAP_METHOD(getPixelColor,
                 getPixelColorWithBase64:(NSString *)base64Png
                 x:(nonnull NSNumber *)x
                 y:(nonnull NSNumber *)y
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  @try {
    // Remove data URI prefix if present
    NSString *base64Data = [base64Png containsString:@","]
      ? [[base64Png componentsSeparatedByString:@","] lastObject]
      : base64Png;

    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64Data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData:imageData];

    if (!image) {
      reject(@"PixelColorError", @"Failed to decode base64 image", nil);
      return;
    }

    NSInteger ix = [x integerValue];
    NSInteger iy = [y integerValue];

    CGImageRef cgImage = [image CGImage];
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);

    if (ix < 0 || iy < 0 || ix >= width || iy >= height) {
      reject(@"PixelColorError", @"Coordinates outside image bounds", nil);
      return;
    }

    // Create bitmap context
    unsigned char pixelData[4] = {0};
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 CGImageGetColorSpace(cgImage),
                                                 kCGImageAlphaPremultipliedLast);

    // Draw the specific pixel into context
    CGContextTranslateCTM(context, -ix, iy - height + 1);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(context);

    int red   = pixelData[0];
    int green = pixelData[1];
    int blue  = pixelData[2];
    int alpha = pixelData[3];

    resolve(@{
      @"red": @(red),
      @"green": @(green),
      @"blue": @(blue),
      @"alpha": @(alpha)
    });

  } @catch (NSException *exception) {
    reject(@"PixelColorError", exception.reason, nil);
  }
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativePixelColorSpecJSI>(params);
}

@end
