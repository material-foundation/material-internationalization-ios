//KM

#import "GOOBidi.h"

#import <CoreFoundation/CoreFoundation.h>

// A string literal that requires bidi embedding can be surrounded by these macro-defined string
// literals and the compiler will automatically concatenate them.
#define kGOOLTREmbedding @"\u202a"  // left-to-right override
#define kGOORTLEmbedding @"\u202b"  // right-to-left override
#define kGOOBidiPopEmbedding @"\u202c"  // pop directional formatting
#define kGOOLRMark @"\u200e"  // left-to-right mark
#define kGOORLMark @"\u200f"  // right-to-left mark

//BOOL GOOIsRegionLanguageDirectionRTL(void) {
//  NSString *languageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
//  NSLocaleLanguageDirection characterDirection =
//  [NSLocale characterDirectionForLanguage:languageCode];
//  BOOL regionLanguageDirectionIsRTL =
//  (characterDirection == NSLocaleLanguageDirectionRightToLeft);
//  return regionLanguageDirectionIsRTL;
//}

NSLocaleLanguageDirection GOOLanguageDirectionOfString(NSString *string) {
  if (!string) return NSLocaleLanguageDirectionUnknown;

  // Determine language of string.
  CFStringRef text = (__bridge CFStringRef)string;
  CFRange range = CFRangeMake(0, [string length]);
  NSString *languageCode =
  (NSString *)CFBridgingRelease(CFStringTokenizerCopyBestStringLanguage(text, range));

  // If you can't derive languageCode, assume LTR.
  NSLocaleLanguageDirection languageDirection = NSLocaleLanguageDirectionLeftToRight;

  // Determine line directionality of string based on derived language.
  if (languageCode) {
    languageDirection = [NSLocale characterDirectionForLanguage:languageCode];
  }
  return languageDirection;
}

static NSString *GOOBidiWrapWithDirectionMarks(NSString *stringToBeInserted,
                                               NSLocaleLanguageDirection contextStringDirection,
                                               NSLocaleLanguageDirection stringToBeInsertedDirection) {
  // Only isolate if string directionality differs from context directionality.
  if (stringToBeInsertedDirection == contextStringDirection) {
    return stringToBeInserted;
  }

  NSString *explicitDirectionFormat;
  if (contextStringDirection == NSLocaleLanguageDirectionRightToLeft) {
    explicitDirectionFormat = kGOORLMark @"%@" kGOORLMark;
  } else if (contextStringDirection == NSLocaleLanguageDirectionLeftToRight) {
    explicitDirectionFormat = kGOOLRMark @"%@" kGOOLRMark;
  } else {
    return stringToBeInserted;
  }

  NSString *directionString =
  [NSString stringWithFormat:explicitDirectionFormat, stringToBeInserted];

  return directionString;
}

NSString *GOOBidiUnicodeWrapWithStereoReset(NSString *stringToBeInserted,
                                            NSLocaleLanguageDirection stringToBeInsertedDirection,
                                            NSLocaleLanguageDirection contextStringDirection) {
#if DEBUG
  // Disable in release, as a pre-caution in case not everyone defines NS_BLOCK_ASSERTION.
  NSCAssert((contextStringDirection != NSLocaleLanguageDirectionLeftToRight ||
             contextStringDirection != NSLocaleLanguageDirectionRightToLeft),
            @"contextStringDirection must be passed in and set to either"
            "NSLocaleLanguageDirectionLeftToRight or NSLocaleLanguageDirectionRightToLeft.");

  NSCAssert((stringToBeInsertedDirection != NSLocaleLanguageDirectionLeftToRight ||
             stringToBeInsertedDirection != NSLocaleLanguageDirectionRightToLeft ||
             stringToBeInsertedDirection != NSLocaleLanguageDirectionUnknown),
            @"stringToBeInsertedDirection must be set to either NSLocaleLanguageDirectionUnknown,"
            "NSLocaleLanguageDirectionLeftToRight, or NSLocaleLanguageDirectionRightToLeft.");
#endif

  if (!stringToBeInserted || stringToBeInserted.length <= 0) return stringToBeInserted;

  if (stringToBeInsertedDirection == NSLocaleLanguageDirectionUnknown) {
    stringToBeInsertedDirection = GOOLanguageDirectionOfString(stringToBeInserted);
  }

  NSString *wrappedString = GOOBidiUnicodeWrapWithLanguageDirection(stringToBeInserted,
                                                                    stringToBeInsertedDirection);

  return GOOBidiWrapWithDirectionMarks(wrappedString,
                                       contextStringDirection,
                                       stringToBeInsertedDirection);
}

NSString *GOOBidiUnicodeWrap(NSString *string) {
  if (!string) return string;

  NSLocaleLanguageDirection languageDirection = GOOLanguageDirectionOfString(string);

  return GOOBidiUnicodeWrapWithLanguageDirection(string, languageDirection);
}

NSString *GOOBidiUnicodeWrapWithLanguageDirection(NSString *string,
                                                  NSLocaleLanguageDirection languageDirection) {
  if (!string) return string;

  NSString *explicitDirectionFormat;
  if (languageDirection == NSLocaleLanguageDirectionRightToLeft) {
    explicitDirectionFormat = kGOORTLEmbedding @"%@" kGOOBidiPopEmbedding;
  } else if (languageDirection == NSLocaleLanguageDirectionLeftToRight) {
    explicitDirectionFormat = kGOOLTREmbedding @"%@" kGOOBidiPopEmbedding;
  } else {
    // Return original string if wrong direction is passed in.
    return string;
  }
  NSString *directionString = [NSString stringWithFormat:explicitDirectionFormat, string];
  return directionString;
}

NSString *GOOStripBidiUnicodeCharacters(NSString *string) {
  NSArray *directionalMarkers = @[ kGOORTLEmbedding,
                                   kGOOLTREmbedding,
                                   kGOOBidiPopEmbedding,
                                   kGOOLRMark,
                                   kGOORLMark ];
  for (NSString *markerString in directionalMarkers) {
    string = [string stringByReplacingOccurrencesOfString:markerString withString:@""];
  }
  return string;
}
