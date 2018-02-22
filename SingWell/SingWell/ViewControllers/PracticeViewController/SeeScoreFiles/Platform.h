//
//  Platform.h
//  SeeScoreIOS/SeeScoreMac Sample Apps
//
//  You are free to copy and modify this code as you wish
//  No warranty is made as to the suitability of this for any purpose
//

#ifndef SeeScore_PLATFORM
#define SeeScore_PLATFORM

#import <Foundation/Foundation.h>

/*!
 @header	Platform.h
 @abstract	Provide a more consistent platform API between iOS and macOS
 */

//---------------------------------------------------------------- iOS
#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

typedef UIView PlatView;
typedef UIColor _PlatColor;
typedef UITextField PlatTextField;

typedef UIGestureRecognizer PlatGesRec;
typedef UIPanGestureRecognizer PlatPanGesRec;
typedef UIGestureRecognizerState PlatGesRecState;

extern const int PlatGesRecStateBegan;
extern const int PlatGesRecStateEnded;

//---------------------------------------------------------------- OSX
#elif TARGET_OS_MAC

#import <Cocoa/Cocoa.h>
#import <Appkit/Appkit.h>

typedef NSView PlatView;
typedef NSColor _PlatColor;
typedef NSTextField PlatTextField;

typedef NSGestureRecognizer PlatGesRec;
typedef NSPanGestureRecognizer PlatPanGesRec;
typedef NSGestureRecognizerState PlatGesRecState;

extern const int PlatGesRecStateBegan;
extern const int PlatGesRecStateEnded;

#endif
//----------------------------------------------------------------//


/*!
 @class PlatFunc
 @abstract misc platform-independent functions
 */
@interface PlatFunc : NSObject

#if TARGET_OS_IPHONE
+ (CGContextRef _Nullable)graphicsContext CF_RETURNS_NOT_RETAINED;
+ (CGContextRef _Nullable)bitmapGraphicsContext CF_RETURNS_NOT_RETAINED;
#elif TARGET_OS_MAC
+ (CGContextRef _Nullable)graphicsContext NS_RETURNS_INNER_POINTER;
+ (CGContextRef _Nullable)bitmapGraphicsContext NS_RETURNS_INNER_POINTER;
#endif
+ (void)endGraphicsContext:(CGContextRef _Nullable)ctx;
+ (CGFloat)screenScale;
@end

/*!
 @class PlatColor
 @abstract a platform-independent colour
 */
@interface PlatColor : NSObject
{
	CGFloat r;
	CGFloat g;
	CGFloat b;
	CGFloat a;
}
- (_Nonnull id)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (_Nonnull id)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
- (_Nonnull id)initWithWhite:(CGFloat)white alpha:(CGFloat)alpha;
- (_PlatColor* _Nonnull)c;
#if TARGET_OS_IPHONE
- (CGColorRef _Nonnull)cg CF_RETURNS_NOT_RETAINED;
#elif TARGET_OS_MAC
- (CGColorRef _Nonnull)cg NS_RETURNS_INNER_POINTER;
#endif
- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;
+ (PlatColor* _Nonnull)whiteColor;
+ (PlatColor* _Nonnull)blackColor;
+ (PlatColor* _Nonnull)grayColor;
+ (PlatColor* _Nonnull)darkGrayColor;
+ (PlatColor* _Nonnull)lightGrayColor;
+ (PlatColor* _Nonnull)redColor;
+ (PlatColor* _Nonnull)yellowColor;
+ (PlatColor* _Nonnull)greenColor;
+ (PlatColor* _Nonnull)blueColor;
+ (PlatColor* _Nonnull)orangeColor;
+ (PlatColor* _Nonnull)cyanColor;
+ (PlatColor* _Nonnull)clearColor;
@end


#endif  //SeeScore_PLATFORM


