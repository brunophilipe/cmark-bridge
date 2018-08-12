#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "cmark.h"
#import "cmark_export.h"
#import "cmark_version.h"

FOUNDATION_EXPORT double cmark_bridgeVersionNumber;
FOUNDATION_EXPORT const unsigned char cmark_bridgeVersionString[];

