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

#import <XCTest/XCTest.h>

#import <MDFInternationalization/MDFInternationalization.h>

@interface MDFBidiTests : XCTestCase

@end

@implementation MDFBidiTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUniqueLocaleDirectionality {
    BOOL isLTR = [NSLocale mdf_isDefaultLanguageLTR];
    BOOL isRTL = [NSLocale mdf_isDefaultLanguageRTL];
    
    XCTAssertTrue(isLTR != isRTL, @"Locale cannot be LTR and RTL at the same time");
}

- (void)testLTRStringDirection {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection MDFResult = [testString mdf_calculatedLanguageDirection];
  XCTAssertEqual(MDFResult, NSLocaleLanguageDirectionLeftToRight);
}

- (void)testPersoArabicRTLStringDirection {
  NSString *testString = @"الثعلب البني السريع يقفز فوق الكلب الكسول";
  NSLocaleLanguageDirection MDFResult = [testString mdf_calculatedLanguageDirection];
  XCTAssertEqual(MDFResult, NSLocaleLanguageDirectionRightToLeft);
}

- (void)testHebrewRTLStringDirection {
  NSString *testString = @"12 ספרים";
  NSLocaleLanguageDirection MDFResult = [testString mdf_calculatedLanguageDirection];
  XCTAssertEqual(MDFResult, NSLocaleLanguageDirectionRightToLeft);
}

- (void)testAddLTRMarkers {
  NSString *testString = @"quick brown fox";
  NSString *wrappedString =
      [testString mdf_stringWithBidiEmbedding:NSLocaleLanguageDirectionLeftToRight];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202aquick brown fox\u202c"]);
}

- (void)testAddRTLMarkers {
  NSString *testString = @"quick brown fox";
  NSString *wrappedString =
      [testString mdf_stringWithBidiEmbedding:NSLocaleLanguageDirectionRightToLeft];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202bquick brown fox\u202c"]);
}

- (void)testAddCalculatedMarkers {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSString *wrappedString =
      [testString mdf_stringWithBidiEmbedding];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202aThe quick brown fox jumps over the lazy dog.\u202c"]);
}

- (void)testStripMarkers {
  NSString *testString = @"\u202aThe quick brown fox jumps over the lazy dog.\u202c";
  NSString *strippedString = [testString mdf_stringWithBidiMarkersStripped];
  XCTAssertTrue([strippedString isEqualToString:@"The quick brown fox jumps over the lazy dog."]);
}

- (void)testLTRStereoIsolateLTR {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection stringDirection = NSLocaleLanguageDirectionLeftToRight;
  NSLocaleLanguageDirection contextDirection = NSLocaleLanguageDirectionLeftToRight;

  NSString *wrappedString =
      [testString mdf_stringWithStereoReset:stringDirection
                                    context:contextDirection];

  // ??? Since the context is the same as the string, do we need the markers
  XCTAssertTrue([wrappedString isEqualToString:@"\u202aThe quick brown fox jumps over the lazy dog.\u202c"]);
}

- (void)testLTRStereoIsolateRTL {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection stringDirection = NSLocaleLanguageDirectionLeftToRight;
  NSLocaleLanguageDirection contextDirection = NSLocaleLanguageDirectionRightToLeft;

  NSString *wrappedString =
  [testString mdf_stringWithStereoReset:stringDirection
                                context:contextDirection];

  // !!! wrappedString is "\u202b\u202aThe quick brown fox jumps over the lazy dog.\u202c\u202c
  // ??? Since the context is the same as the string, do we need the markers
  XCTAssertTrue([wrappedString isEqualToString:@"\u200f\u202aThe quick brown fox jumps over the lazy dog.\u202c\u200f"]);
}

- (void)testRTLStereoIsolateRTL {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection stringDirection = NSLocaleLanguageDirectionRightToLeft;
  NSLocaleLanguageDirection contextDirection = NSLocaleLanguageDirectionRightToLeft;

  NSString *wrappedString =
  [testString mdf_stringWithStereoReset:stringDirection
                                context:contextDirection];

  // !!! wrappedString is "\u202b\u202aThe quick brown fox jumps over the lazy dog.\u202c\u202c
  // ??? Since the context is the same as the string, do we need the markers
  XCTAssertTrue([wrappedString isEqualToString:@"\u202bThe quick brown fox jumps over the lazy dog.\u202c"]);
}

// Simple Tests

- (void)testSimpleLanguageDirectionOfPunctuationString {
  NSString *testString = @"@#%+=-^*";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionLeftToRight);
}

- (void)testSimpleLanguageDirectionOfNumericString {
  NSString *testString = @"123";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionLeftToRight);
}

- (void)testSimpleLanguageDirectionOfHebrewString {
  NSString *testString = @"!שלום";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionRightToLeft);
}

- (void)testSimpleLanguageDirectionOfEnglishString {
  NSString *testString = @"Hello!";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionLeftToRight);
}

- (void)testSimpleLanguageDirectionOfEmptyString {
  NSString *testString = @"";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionLeftToRight);
}

@end
