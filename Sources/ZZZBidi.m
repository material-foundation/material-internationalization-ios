/*
 Copyright 2018-present Google Inc. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "ZZZBidi.h"

#import <CoreFoundation/CoreFoundation.h>

// A string literal that requires bidi embedding can be surrounded by these macro-defined string
// literals and the compiler will automatically concatenate them.
#define kZZZLTREmbedding @"\u202a"  // left-to-right override
#define kZZZRTLEmbedding @"\u202b"  // right-to-left override
#define kZZZBidiPopEmbedding @"\u202c"  // pop directional formatting
#define kZZZLRMark @"\u200e"  // left-to-right mark
#define kZZZRLMark @"\u200f"  // right-to-left mark

BOOL ZZZIsRegionLanguageDirectionRTL(void) {
  NSString *languageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
  NSLocaleLanguageDirection characterDirection =
  [NSLocale characterDirectionForLanguage:languageCode];
  BOOL regionLanguageDirectionIsRTL =
  (characterDirection == NSLocaleLanguageDirectionRightToLeft);
  return regionLanguageDirectionIsRTL;
}

NSLocaleLanguageDirection ZZZLanguageDirectionOfString(NSString *string) {
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

static NSString *ZZZBidiWrapWithDirectionMarks(NSString *stringToBeInserted,
                                               NSLocaleLanguageDirection contextStringDirection,
                                               NSLocaleLanguageDirection stringToBeInsertedDirection) {
  // Only isolate if string directionality differs from context directionality.
  if (stringToBeInsertedDirection == contextStringDirection) {
    return stringToBeInserted;
  }

  NSString *explicitDirectionFormat;
  if (contextStringDirection == NSLocaleLanguageDirectionRightToLeft) {
    explicitDirectionFormat = kZZZRLMark @"%@" kZZZRLMark;
  } else if (contextStringDirection == NSLocaleLanguageDirectionLeftToRight) {
    explicitDirectionFormat = kZZZLRMark @"%@" kZZZLRMark;
  } else {
    return stringToBeInserted;
  }

  NSString *directionString =
  [NSString stringWithFormat:explicitDirectionFormat, stringToBeInserted];

  return directionString;
}

NSString *ZZZBidiUnicodeWrapWithStereoReset(NSString *stringToBeInserted,
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
    stringToBeInsertedDirection = ZZZLanguageDirectionOfString(stringToBeInserted);
  }

  NSString *wrappedString = ZZZBidiUnicodeWrapWithLanguageDirection(stringToBeInserted,
                                                                    stringToBeInsertedDirection);

  return ZZZBidiWrapWithDirectionMarks(wrappedString,
                                       contextStringDirection,
                                       stringToBeInsertedDirection);
}

NSString *ZZZBidiUnicodeWrap(NSString *string) {
  if (!string) return string;

  NSLocaleLanguageDirection languageDirection = ZZZLanguageDirectionOfString(string);

  return ZZZBidiUnicodeWrapWithLanguageDirection(string, languageDirection);
}

NSString *ZZZBidiUnicodeWrapWithLanguageDirection(NSString *string,
                                                  NSLocaleLanguageDirection languageDirection) {
  if (!string) return string;

  NSString *explicitDirectionFormat;
  if (languageDirection == NSLocaleLanguageDirectionRightToLeft) {
    explicitDirectionFormat = kZZZRTLEmbedding @"%@" kZZZBidiPopEmbedding;
  } else if (languageDirection == NSLocaleLanguageDirectionLeftToRight) {
    explicitDirectionFormat = kZZZLTREmbedding @"%@" kZZZBidiPopEmbedding;
  } else {
    // Return original string if wrong direction is passed in.
    return string;
  }
  NSString *directionString = [NSString stringWithFormat:explicitDirectionFormat, string];
  return directionString;
}

NSString *ZZZStripBidiUnicodeCharacters(NSString *string) {
  NSArray *directionalMarkers = @[ kZZZRTLEmbedding,
                                   kZZZLTREmbedding,
                                   kZZZBidiPopEmbedding,
                                   kZZZLRMark,
                                   kZZZRLMark ];
  for (NSString *markerString in directionalMarkers) {
    string = [string stringByReplacingOccurrencesOfString:markerString withString:@""];
  }
  return string;
}
