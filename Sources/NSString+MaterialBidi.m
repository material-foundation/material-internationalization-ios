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

#import "NSString+MaterialBidi.h"

#import <CoreFoundation/CoreFoundation.h>

@implementation NSString (MaterialBidi)

// https://www.w3.org/International/questions/qa-bidi-unicode-controls
// TODO : Reach out to AAA about the utility of the Isolate markers
// ??? Do we want Embedding or Isolate markers? w3 recommends isolate?
// Add reference : Unicode® Standard Annex #9 UNICODE BIDIRECTIONAL ALGORITHM
// go/android-bidiformatter
// http://unicode.org/reports/tr9/
static NSString *kMDFLTREmbedding = @"\u202a";  // left-to-right embedding
static NSString *kMDFRTLEmbedding = @"\u202b";  // right-to-left embedding
static NSString *kMDFBidiPopEmbedding = @"\u202c";  // pop directional embedding

static NSString *kMDFLTRMark = @"\u200e";  // left-to-right mark
static NSString *kMDFRTLMark = @"\u200f";  // right-to-left mark

// The following only work on iOS 10+
static NSString *kMDFLTRIsolate = @"\u2066";  // left-to-right isolate
static NSString *kMDFRTLIsolate = @"\u2067";  // right-to-left isolate
static NSString *kMDFFirstStrongIsolate = @"\u2068";  // first strong isolate
static NSString *kMDFPopIsolate = @"\u2069";  // pop directional isolate


- (NSLocaleLanguageDirection)mdf_calculatedLanguageDirection {
  // Attempt to determine language of string.
  CFStringRef text = (__bridge CFStringRef)self;
  CFRange range = CFRangeMake(0, [self length]);
  NSString *languageCode =
      (NSString *)CFBridgingRelease(CFStringTokenizerCopyBestStringLanguage(text, range));

  NSLocaleLanguageDirection languageDirection;
  if (languageCode) {
    // If we identified a language, explicitly set the string direction based on that
    languageDirection = [NSLocale characterDirectionForLanguage:languageCode];
  } else {
    languageDirection = NSLocaleLanguageDirectionUnknown;
  }

  // If the result is not LTR or RTL, fallback to LTR
  // ??? Should I be defaulting to NSLocale.NSLocaleLanguageCode.characterDiretion?
  if (languageDirection != NSLocaleLanguageDirectionLeftToRight &&
      languageDirection != NSLocaleLanguageDirectionRightToLeft) {
    languageDirection = NSLocaleLanguageDirectionLeftToRight;
  }

  return languageDirection;
}

- (NSString *)mdf_stringWithBidiMarkers {
  NSLocaleLanguageDirection languageDirection = [self mdf_calculatedLanguageDirection];

  return [self mdf_stringWithBidiMarkers:languageDirection];
}

- (NSString *)mdf_stringWithBidiMarkers:(NSLocaleLanguageDirection)languageDirection {
  if (languageDirection == NSLocaleLanguageDirectionRightToLeft) {
    // ??? Should we check for existing markers - MAYBE, must be exact requested markers
    // ??? AAA: why / why not?  Would you ever want to double wrap?  What other optimizations
    // might present themselves
    // TODO If so only check the first and last character
    // TODO Here and below
    if ([self rangeOfString:kMDFRTLEmbedding options:0 range:NSMakeRange(0, 1)].location == NSNotFound ||
        [self rangeOfString:kMDFBidiPopEmbedding options:NSBackwardsSearch].location == NSNotFound) {
      NSString *directionString =
          [NSString stringWithFormat:@"%@%@%@", kMDFRTLEmbedding, self, kMDFBidiPopEmbedding];
      return directionString;
    } else {
      return [self copy];
    }
  } else if (languageDirection == NSLocaleLanguageDirectionLeftToRight) {
    //TODO Check for existing markers
    NSString *directionString =
        [NSString stringWithFormat:@"%@%@%@", kMDFLTREmbedding, self, kMDFBidiPopEmbedding];
    return directionString;
  } else {
    // ??? Originally this just returned self.  Do we want to return a copy?
    // Return a copy original string if an unsupported direction is passed in.
    return [self copy];
  }
}

- (nonnull NSString *)mdf_stringWithStereoIsolate:(NSLocaleLanguageDirection)direction
                                          context:(NSLocaleLanguageDirection)contextDirection {
  // ??? Assert or exception - Assert!!!!
#if DEBUG
  // Disable in release, as a pre-caution in case not everyone defines NS_BLOCK_ASSERTION.
  NSCAssert((contextDirection != NSLocaleLanguageDirectionLeftToRight ||
             contextDirection != NSLocaleLanguageDirectionRightToLeft),
            @"contextStringDirection must be passed in and set to either"
            "NSLocaleLanguageDirectionLeftToRight or NSLocaleLanguageDirectionRightToLeft.");

  NSCAssert((direction != NSLocaleLanguageDirectionLeftToRight ||
             direction != NSLocaleLanguageDirectionRightToLeft ||
             direction != NSLocaleLanguageDirectionUnknown),
            @"stringToBeInsertedDirection must be set to either NSLocaleLanguageDirectionUnknown,"
            "NSLocaleLanguageDirectionLeftToRight, or NSLocaleLanguageDirectionRightToLeft.");
#endif
  //TODO Add proper error handling

  if (self.length == 0) {
    return [self copy];
  }

  if (direction != NSLocaleLanguageDirectionLeftToRight &&
      direction != NSLocaleLanguageDirectionRightToLeft) {
    direction = [self mdf_calculatedLanguageDirection];
  }

  NSString *wrappedString = [self mdf_stringWithBidiMarkers:direction];

  if (direction != contextDirection) {
    if (contextDirection == NSLocaleLanguageDirectionRightToLeft) {
      return [NSString stringWithFormat:@"%@%@%@", kMDFRTLMark, wrappedString, kMDFRTLMark];
    } else {
      return [NSString stringWithFormat:@"%@%@%@", kMDFLTRMark, wrappedString, kMDFLTRMark];
    }
  } else {
    return wrappedString;
  }
}

- (NSString *)mdf_stringWithBidiMarkersStripped {
  NSString *strippedString = self;
  NSArray <NSString *>*directionalMarkers = @[ kMDFRTLEmbedding,
                                               kMDFLTREmbedding,
                                               kMDFBidiPopEmbedding,
                                               kMDFLTRIsolate,
                                               kMDFRTLIsolate,
                                               kMDFPopIsolate,
                                               kMDFLTRMark,
                                               kMDFRTLMark ];
  for (NSString *markerString in directionalMarkers) {
    strippedString =
        [strippedString stringByReplacingOccurrencesOfString:markerString withString:@""];
  }
  return strippedString;
}

@end
