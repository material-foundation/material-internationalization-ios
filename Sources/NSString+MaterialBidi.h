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

#import <Foundation/Foundation.h>

@interface NSString (MaterialBidi)

/**
 Uses CFStringTokenizerCopyBestStringLanguage to determine string's language direction.
 If the language direction is unknown or vertical returns left-to-right.

 As CFStringTokenizerCopyBestStringLanguage is Apple's API, its result may change if
 Apple improves or modifies the implementation.

 @return the direction of the string
 */
- (NSLocaleLanguageDirection)mdf_calculatedLanguageDirection;

/**
 Initializes a copy of the string tagged with the given language direction. This
 formatting adds the appropriate Unicode markers at the beginning and end of the string.

 Only NSLocaleLanguageDirectionLeftToRight and NSLocaleLanguageDirectionRightToLeft
 language directions are supported. Other values of NSLocalLanguageDirection will
 return a copy of self.

 Returns a string wrapped with Unicode bidi formatting characters by inserting these characters
 around the string:
 RLE+|string|+PDF for RTL text, or LRE+|string|+PDF for LTR text.

 @returns the new string.
 */
- (nonnull NSString *)mdf_stringWithBidiMarkers:(NSLocaleLanguageDirection)languageDirection;

/**
 Returns a copy of the string explicitly tagged with a language direction.

 Uses mdf_calculatedLanguageDirection to determine string's language direction then invokes
 mdf_stringWithBiDiMarkers:.

 @return the new string.
 */
- (nonnull NSString *)mdf_stringWithBidiMarkers NS_SWIFT_NAME(stringWithBidi());

/**
 This method will always isolate the string by adding LRM and RLM marks before and after the
 string to prevent it from garbling the content around it. Use this method when inserting output
 string into another format string.

 |direction| can be NSLocaleLanguageDirectionLeftToRight, NSLocaleLanguageDirectionRightToLeft, or
 NSLocaleLanguageDirectionUnknown.

 |contextDirection| must be specificed and cannot be unknown. Only
 NSLocaleLanguageDirectionLeftToRight and NSLocaleLanguageDirectionRightToLeft language directions
 are supported. Use mdf_calculatedLanguageDirection to estimate the string if directionality is
 unknown.

 @returns the new string.
 */
- (nonnull NSString *)mdf_stringWithStereoIsolate:(NSLocaleLanguageDirection)direction
                                          context:(NSLocaleLanguageDirection)contextDirection;

/**
 Returns a new string in which all occurrences of Unicode bidirectional format markers are removed.

 @returns the new string.
 */
- (nonnull NSString *)mdf_stringWithBidiMarkersStripped;

@end
