#import <Foundation/Foundation.h>

//KM

/**
 Bidirectional utility methods. Please see go/ios-rtl.
 */

#if defined __cplusplus
extern "C" {
#endif  // __cplusplus

  /** Returns YES if the device's region language direction is right-to-left. */
  BOOL GOOIsRegionLanguageDirectionRTL(void);

  /**
   Uses CFStringTokenizerCopyBestStringLanguage to determine string's language direction.
   Assumes left-to-right if the language direction cannot be determined from the
   string content.

   @param string The string to analyze for locale language direction.
   @return @c NSLocaleLanguageDirectionUnknown if @c string is nil,
   @c NSLocaleLanguageDirectionLeftToRight if the contents are ambiguous,
   else the locale language direction of the contents of @c string.
   */
  NSLocaleLanguageDirection GOOLanguageDirectionOfString(NSString *string);

  /**
   Formats a given string of unknown directionality.

   Uses CFStringTokenizerCopyBestStringLanguage to determine string's language direction.
   Assumes left-to-right if the language direction is unknown.

   Returns a string wrapped with Unicode bidi formatting characters by inserting these characters
   around the string:
   RLE+|string|+PDF for RTL text, or LRE+|string|+PDF for LTR text.
   */
  NSString *GOOBidiUnicodeWrap(NSString *string);

  /**
   Returns a string formatted with the given language direction.

   Only NSLocaleLanguageDirectionLeftToRight and NSLocaleLanguageDirectionRightToLeft
   language directions are supported.

   See GOOBidiUnicodeWrap() for more details.
   */
  NSString *GOOBidiUnicodeWrapWithLanguageDirection(NSString *string,
                                                    NSLocaleLanguageDirection languageDirection);

  /**
   This method will always "isolate" the string by adding LRM and RLM marks before and after the
   string to prevent it from garbling the content around it. Use this method when inserting output
   string into another format string.

   |stringToBeInsertedDirection| can be NSLocaleLanguageDirectionUnknown.

   |contextStringDirection| must be specificed and cannot be unknown. Only
   NSLocaleLanguageDirectionLeftToRight and NSLocaleLanguageDirectionRightToLeft language directions
   are supported. Use GOOLanguageDirectionOfString to estimate the string if directionality is
   unknown.
   */
  NSString *GOOBidiUnicodeWrapWithStereoReset(NSString *stringToBeInserted,
                                              NSLocaleLanguageDirection stringToBeInsertedDirection,
                                              NSLocaleLanguageDirection contextStringDirection);

  /** Removes Unicode bidirectional format markers from the string. */
  NSString *GOOStripBidiUnicodeCharacters(NSString *string);

#if defined __cplusplus
}  // extern "C"
#endif  // __cplusplus
