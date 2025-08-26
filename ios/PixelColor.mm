#import "PixelColor.h"

@implementation PixelColor
RCT_EXPORT_MODULE()

- (void)getPixelColor:(NSString *)base64Png
                    x:(double)x
                    y:(double)y
             resolve:(RCTPromiseResolveBlock)resolve
             reject:(RCTPromiseRejectBlock)reject
{
    NSDictionary *result = @{
        @"red": @0,
        @"green": @0,
        @"blue": @0,
        @"alpha": @0
    };
    resolve(result);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativePixelColorSpecJSI>(params);
}

@end