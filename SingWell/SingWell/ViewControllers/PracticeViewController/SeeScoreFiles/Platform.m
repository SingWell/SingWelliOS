//
//  Platform.m
//  SeeScoreIOS/SeeScoreMac Sample Apps
//
//  You are free to copy and modify this code as you wish
//  No warranty is made as to the suitability of this for any purpose
//

#import "Platform.h"

//---------------------------------------------------------------- iOS
#if TARGET_OS_IPHONE

const int PlatGesRecStateBegan = UIGestureRecognizerStateBegan;
const int PlatGesRecStateEnded = UIGestureRecognizerStateEnded;

//---------------------------------------------------------------- OSX
#elif TARGET_OS_MAC

const int PlatGesRecStateBegan = NSGestureRecognizerStateBegan;
const int PlatGesRecStateEnded = NSGestureRecognizerStateEnded;

#endif

//----------------------------------------------------------------//

// class implementations

//================================================================ PlatFunc

@implementation PlatFunc

+ (CGContextRef)graphicsContext
{
#if TARGET_OS_IPHONE
	return UIGraphicsGetCurrentContext();
#elif TARGET_OS_MAC
	NSGraphicsContext* context = [NSGraphicsContext currentContext];
	return (CGContextRef)context.CGContext;
#endif
}

+ (CGContextRef)bitmapGraphicsContext
{
#if TARGET_OS_IPHONE
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(10, 10), true,  /*opaque*/ 0.0);
	return UIGraphicsGetCurrentContext();
#elif TARGET_OS_MAC
	static const int kBitmapWidth = 10;
	static const int kBitmapHeight = 10;
	static const int kBitmapBytesPerRow  = (kBitmapWidth * 4);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGContextRef ctx = CGBitmapContextCreate (NULL,
											  kBitmapWidth,
											  kBitmapHeight,
											  8,      // bits per component
											  kBitmapBytesPerRow,
											  colorSpace,
											  // the compiler says wrong enum type but this is copied from the documentation
											  kCGImageAlphaPremultipliedLast);
	assert(ctx);
	CGColorSpaceRelease( colorSpace );
	return ctx;
#endif
}

+ (void)endGraphicsContext:(CGContextRef _Nullable)ctx;
{
#if TARGET_OS_IPHONE
	UIGraphicsEndImageContext();
#elif TARGET_OS_MAC
	CGContextRelease(ctx);
#endif
}

+ (CGFloat)screenScale
{
#if TARGET_OS_IPHONE
	return [UIScreen mainScreen].scale;
#elif TARGET_OS_MAC
	return [[NSScreen mainScreen] backingScaleFactor];
#endif
}

@end

//================================================================ PlatColor

@implementation PlatColor
- (_Nonnull id)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
	r = red;
	g = green;
	b = blue;
	a = alpha;
	return self;
}

- (_Nonnull id)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
	return [self initWithRed:red green:green blue:blue alpha:1.0];
}

- (_Nonnull id)initWithWhite:(CGFloat)white alpha:(CGFloat)alpha
{
	return [self initWithRed:white green:white blue:white alpha:alpha];
}

- (_PlatColor* _Nonnull)c
{
#if TARGET_OS_IPHONE
	return [_PlatColor colorWithRed:r green:g blue:b alpha:a];
#elif TARGET_OS_MAC
	return [_PlatColor colorWithCalibratedRed:r green:g blue:b alpha:a];
#endif
}

- (CGColorRef _Nonnull)cg
{
#if TARGET_OS_IPHONE
	return [_PlatColor colorWithRed:r green:g blue:b alpha:a].CGColor;
#elif TARGET_OS_MAC
	return [_PlatColor colorWithCalibratedRed:r green:g blue:b alpha:a].CGColor;
#endif
}

- (CGFloat)red
{
	return r;
}

- (CGFloat)green
{
	return g;
	
}

- (CGFloat)blue
{
	return b;
}

- (CGFloat)alpha
{
	return a;
}

+ (PlatColor*)whiteColor
{
	return [[PlatColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
}

+ (PlatColor*)blackColor
{
	return [[PlatColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
}

+ (PlatColor*)grayColor
{
	return [[PlatColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
}

+ (PlatColor*)darkGrayColor
{
	return [[PlatColor alloc] initWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
}

+ (PlatColor*)lightGrayColor
{
	return [[PlatColor alloc] initWithRed:0.75 green:0.75 blue:0.75 alpha:1.0];
}

+ (PlatColor*)redColor
{
	return [[PlatColor alloc] initWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
}

+ (PlatColor*)greenColor
{
	return [[PlatColor alloc] initWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
}

+ (PlatColor*)yellowColor
{
	return [[PlatColor alloc] initWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
}

+ (PlatColor*)blueColor
{
	return [[PlatColor alloc] initWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
}

+ (PlatColor*)orangeColor
{
	return [[PlatColor alloc] initWithRed:1.0 green:0.5 blue:0 alpha:1.0];
}

+ (PlatColor*)cyanColor
{
	return [[PlatColor alloc] initWithRed:0 green:1 blue:1 alpha:1.0];
}

+ (PlatColor*)clearColor
{
	return [[PlatColor alloc] initWithRed:1 green:1 blue:1 alpha:0];
}

@end
