#ifdef SHOULD_COMPILE_LOOKIN_SERVER
//
//  LKS_MultiplatformAdapter.m
//  
//
//  Created by nixjiang on 2024/3/12.
//

#import "LKS_MultiplatformAdapter.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#endif

@implementation LKS_MultiplatformAdapter

+ (BOOL)isiPad {
#if TARGET_OS_IPHONE
    static BOOL s_isiPad = NO;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *nsModel = [UIDevice currentDevice].model;
        s_isiPad = [nsModel hasPrefix:@"iPad"];
    });

    return s_isiPad;
#endif
    
#if TARGET_OS_OSX
    return NO;
#endif
}

+ (CGRect)mainScreenBounds {
#if TARGET_OS_VISION
    return [LKS_MultiplatformAdapter getFirstActiveWindowScene].coordinateSpace.bounds;
#elif TARGET_OS_IPHONE
    return [UIScreen mainScreen].bounds;
#elif TARGET_OS_OSX
    return [NSScreen mainScreen].frame;
#else
    return CGRectZero;
#endif
}

+ (CGFloat)mainScreenScale {
#if TARGET_OS_VISION
    return 2.f;
#elif TARGET_OS_IPHONE
    return [UIScreen mainScreen].scale;
#elif TARGET_OS_OSX
    return [NSScreen mainScreen].backingScaleFactor;
#else
    return 1.f;
#endif
}

#if TARGET_OS_VISION
+ (UIWindowScene *)getFirstActiveWindowScene {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) {
            continue;
        }
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
            return windowScene;
        }
    }
    return nil;
}
#endif

+ (LookinWindow *)keyWindow {
#if TARGET_OS_VISION
    return [self getFirstActiveWindowScene].keyWindow;
#else
    return [LookinApplication sharedApplication].keyWindow;
#endif
}

+ (NSArray<LookinWindow *> *)allWindows {
#if TARGET_OS_VISION
    NSMutableArray<UIWindow *> *windows = [NSMutableArray new];
    for (UIScene *scene in
         UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) {
            continue;
        }
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        [windows addObjectsFromArray:windowScene.windows];
        
        // 以UIModalPresentationFormSheet形式展示的页面由系统私有window承载，不出现在scene.windows，不过可以从scene.keyWindow中获取
        if (![windows containsObject:windowScene.keyWindow]) {
            if (![NSStringFromClass(windowScene.keyWindow.class) containsString:@"HUD"]) {
                [windows addObject:windowScene.keyWindow];
            }
        }
    }

    return [windows copy];
#else
    return [[LookinApplication sharedApplication].windows copy];
#endif
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */