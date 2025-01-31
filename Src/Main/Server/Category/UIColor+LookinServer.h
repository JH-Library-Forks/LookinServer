#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UIColor+LookinServer.h
//  LookinServer
//
//  Created by Li Kai on 2019/6/5.
//  https://lookin.work
//

#import "LookinDefines.h"

@interface LookinColor (LookinServer)

- (NSArray<NSNumber *> *)lks_rgbaComponents;
+ (instancetype)lks_colorFromRGBAComponents:(NSArray<NSNumber *> *)components;

- (NSString *)lks_rgbaString;
- (NSString *)lks_hexString;

/// will check if the argument is a real CGColor
+ (LookinColor *)lks_colorWithCGColor:(CGColorRef)cgColor;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
