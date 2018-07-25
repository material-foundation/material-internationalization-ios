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

//TODO: Remove any ZZZ tests

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

- (void)testZZZLTRStringDirection {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection MDFResult = [testString mdf_calculatedLanguageDirection];
  XCTAssertEqual(MDFResult, NSLocaleLanguageDirectionLeftToRight);

  //KM
  NSLocaleLanguageDirection ZZZResult = ZZZLanguageDirectionOfString(testString);
  XCTAssertEqual(MDFResult, ZZZResult);
}

- (void)testRTLStringDirection {
  NSString *testString = @"الثعلب البني السريع يقفز فوق الكلب الكسول";
  NSLocaleLanguageDirection MDFResult = [testString mdf_calculatedLanguageDirection];
  XCTAssertEqual(MDFResult, NSLocaleLanguageDirectionRightToLeft);
}

- (void)testZZZRTLStringDirection {
  NSString *testString = @"الثعلب البني السريع يقفز فوق الكلب الكسول";
  NSLocaleLanguageDirection MDFResult = [testString mdf_calculatedLanguageDirection];
  XCTAssertEqual(MDFResult, NSLocaleLanguageDirectionRightToLeft);

  //KM
  NSLocaleLanguageDirection ZZZResult = ZZZLanguageDirectionOfString(testString);
  XCTAssertEqual(MDFResult, ZZZResult);
}

- (void)testAddLTRMarkers {
  NSString *testString = @"quick brown fox";
  NSString *wrappedString =
      [testString mdf_stringWithBidiMarkers:NSLocaleLanguageDirectionLeftToRight];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202aquick brown fox\u202c"]);
}

- (void)testZZZAddLTRMarkers {
  NSString *testString = @"quick brown fox";
  NSString *wrappedString =
  [testString mdf_stringWithBidiMarkers:NSLocaleLanguageDirectionLeftToRight];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202aquick brown fox\u202c"]);

  // KM
  NSString *testZZZString =
  ZZZBidiUnicodeWrapWithLanguageDirection(testString, NSLocaleLanguageDirectionLeftToRight);
  XCTAssertTrue([wrappedString isEqualToString:testZZZString]);
}

- (void)testAddRTLMarkers {
  NSString *testString = @"quick brown fox";
  NSString *wrappedString =
      [testString mdf_stringWithBidiMarkers:NSLocaleLanguageDirectionRightToLeft];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202bquick brown fox\u202c"]);
}

- (void)testZZZAddRTLMarkers {
  NSString *testString = @"quick brown fox";
  NSString *wrappedString =
  [testString mdf_stringWithBidiMarkers:NSLocaleLanguageDirectionRightToLeft];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202bquick brown fox\u202c"]);

  // KM
  NSString *testZZZString =
  ZZZBidiUnicodeWrapWithLanguageDirection(testString, NSLocaleLanguageDirectionRightToLeft);
  XCTAssertTrue([wrappedString isEqualToString:testZZZString]);
}

- (void)testAddRTLRTLMarkers {
  NSString *testString = @"quick brown fox";
  NSString *wrappedString =
      [testString mdf_stringWithBidiMarkers:NSLocaleLanguageDirectionRightToLeft];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202bquick brown fox\u202c"]);

  NSString *doubleWrappedString =
      [wrappedString mdf_stringWithBidiMarkers:NSLocaleLanguageDirectionRightToLeft];
  XCTAssertTrue([doubleWrappedString isEqualToString:@"\u202bquick brown fox\u202c"]);
}


- (void)testAddCalculatedMarkers {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSString *wrappedString =
      [testString mdf_stringWithBidiMarkers];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202aThe quick brown fox jumps over the lazy dog.\u202c"]);
}

- (void)testZZZAddCalculatedMarkers {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSString *wrappedString =
  [testString mdf_stringWithBidiMarkers];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202aThe quick brown fox jumps over the lazy dog.\u202c"]);

  // KM
  NSString *testZZZString =
  ZZZBidiUnicodeWrap(testString);
  XCTAssertTrue([wrappedString isEqualToString:testZZZString]);
}

- (void)testStripMarkers {
  NSString *testString = @"\u202aThe quick brown fox jumps over the lazy dog.\u202c";
  NSString *strippedString = [testString mdf_stringWithBidiMarkersStripped];
  XCTAssertTrue([strippedString isEqualToString:@"The quick brown fox jumps over the lazy dog."]);
}

- (void)testZZZStripMarkers {
  NSString *testString = @"\u202aThe quick brown fox jumps over the lazy dog.\u202c";
  NSString *strippedString = [testString mdf_stringWithBidiMarkersStripped];
  XCTAssertTrue([strippedString isEqualToString:@"The quick brown fox jumps over the lazy dog."]);

  //KM
  NSString *testZZZString = ZZZStripBidiUnicodeCharacters(testString);
  XCTAssertTrue([strippedString isEqualToString:testZZZString]);
}

- (void)testLTRStereoIsolateLTR {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection stringDirection = NSLocaleLanguageDirectionLeftToRight;
  NSLocaleLanguageDirection contextDirection = NSLocaleLanguageDirectionLeftToRight;

  NSString *wrappedString =
      [testString mdf_stringWithStereoIsolate:stringDirection
                                        context:contextDirection];

  // ??? Since the context is the same as the string, do we need the markers
  XCTAssertTrue([wrappedString isEqualToString:@"\u202aThe quick brown fox jumps over the lazy dog.\u202c"]);
}

- (void)testZZZLTRStereoIsolateLTR {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection stringDirection = NSLocaleLanguageDirectionLeftToRight;
  NSLocaleLanguageDirection contextDirection = NSLocaleLanguageDirectionLeftToRight;

  NSString *wrappedString =
      [testString mdf_stringWithStereoIsolate:stringDirection
                                      context:contextDirection];

  NSString *testZZZString = ZZZBidiUnicodeWrapWithStereoReset(testString, stringDirection, contextDirection);
  XCTAssertTrue([wrappedString isEqualToString:testZZZString]);
}

- (void)testLTRStereoIsolateRTL {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection stringDirection = NSLocaleLanguageDirectionLeftToRight;
  NSLocaleLanguageDirection contextDirection = NSLocaleLanguageDirectionRightToLeft;

  NSString *wrappedString =
  [testString mdf_stringWithStereoIsolate:stringDirection
                                  context:contextDirection];

  // !!! wrappedString is "\u202b\u202aThe quick brown fox jumps over the lazy dog.\u202c\u202c
  // ??? Since the context is the same as the string, do we need the markers
  XCTAssertTrue([wrappedString isEqualToString:@"\u200f\u202aThe quick brown fox jumps over the lazy dog.\u202c\u200f"]);
}

- (void)testZZZLTRStereoIsolateRTL {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection stringDirection = NSLocaleLanguageDirectionLeftToRight;
  NSLocaleLanguageDirection contextDirection = NSLocaleLanguageDirectionRightToLeft;

  NSString *wrappedString =
  [testString mdf_stringWithStereoIsolate:stringDirection
                                  context:contextDirection];

  // !!! wrappedString is "\u202b\u202aThe quick brown fox jumps over the lazy dog.\u202c\u202c
  // !!! testZZZString is "\u200f\u202aThe quick brown fox jumps over the lazy dog.\u202c\u200f

  NSString *testZZZString = ZZZBidiUnicodeWrapWithStereoReset(testString, stringDirection, contextDirection);
  XCTAssertTrue([wrappedString isEqualToString:testZZZString]);
}

- (void)testRTLStereoIsolateRTL {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection stringDirection = NSLocaleLanguageDirectionRightToLeft;
  NSLocaleLanguageDirection contextDirection = NSLocaleLanguageDirectionRightToLeft;

  NSString *wrappedString =
  [testString mdf_stringWithStereoIsolate:stringDirection
                                  context:contextDirection];

  // !!! wrappedString is "\u202b\u202aThe quick brown fox jumps over the lazy dog.\u202c\u202c
  // ??? Since the context is the same as the string, do we need the markers
  XCTAssertTrue([wrappedString isEqualToString:@"\u202bThe quick brown fox jumps over the lazy dog.\u202c"]);
}

- (void)testZZZRTLStereoIsolateRTL {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection stringDirection = NSLocaleLanguageDirectionRightToLeft;
  NSLocaleLanguageDirection contextDirection = NSLocaleLanguageDirectionRightToLeft;

  NSString *wrappedString =
  [testString mdf_stringWithStereoIsolate:stringDirection
                                  context:contextDirection];

  // !!! wrappedString is "\u202b\u202aThe quick brown fox jumps over the lazy dog.\u202c\u202c
  // !!! testZZZString is "\u200f\u202aThe quick brown fox jumps over the lazy dog.\u202c\u200f

  NSString *testZZZString = ZZZBidiUnicodeWrapWithStereoReset(testString, stringDirection, contextDirection);
  XCTAssertTrue([wrappedString isEqualToString:testZZZString]);
}

//KM
- (void)testStandardStringBehavior {
  NSString *string = @"the quick brown fox";
  // This indicates it will return a new string, but it does not
  NSString *strippedString = [string stringByReplacingOccurrencesOfString:@"zebra" withString:@"antelope"];

  XCTAssertTrue([string isEqualToString:strippedString]);
  XCTAssertEqual(string, strippedString);
}

// Previous ZZZBidiTests

- (void)testZZZLanguageDirectionOfPunctuationString {
  NSString *testString = @"@#%+=-^*";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionLeftToRight);
}

- (void)testZZZLanguageDirectionOfNumericString {
  NSString *testString = @"123";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionLeftToRight);
}

- (void)testZZZLanguageDirectionOfHebrewString {
  NSString *testString = @"!שלום";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionRightToLeft);
}

- (void)testZZZLanguageDirectionOfEnglishString {
  NSString *testString = @"Hello!";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionLeftToRight);
}

- (void)testZZZLanguageDirectionOfEmptyString {
  NSString *testString = @"";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionLeftToRight);
}

- (void)testZZZLanguageDirectionOfBidiString {
  NSString *rtlText =  @"اميل";
  // Note that setting this text to a latin name results in LTR
  // NSString *rtlText =  @"Steve";

  //  NSString *wrappedText = [rtlText mdf_stringWithBidiMarkers:NSLocaleLanguageDirectionRightToLeft];
  NSString *wrappedText =
      [rtlText mdf_stringWithStereoIsolate:NSLocaleLanguageDirectionRightToLeft
                                   context:NSLocaleLanguageDirectionLeftToRight];
  NSString *testString = [NSString stringWithFormat:@"Hello %@! (19 July)", wrappedText];
  // @"Hello اميل! (19 July)"

  //??? RTL - Arabic Characters having a stronger effect?  Is this intended behavior
  // Possibly 'any-RTL' : a string containing any RTL characters will be treated as RTL
  NSLocaleLanguageDirection direction = [testString mdf_calculatedLanguageDirection];
  NSLocaleLanguageDirection ZZZDirection = ZZZLanguageDirectionOfString(testString);

  // Then
  XCTAssertEqual(direction, ZZZDirection);
  //TODO: Test string contents, not direction.
  //FIXME Determine the proper behavior
//  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionLeftToRight);
}

- (void)testZZZLocaleDirection {
  BOOL isZZZRTL = ZZZIsRegionLanguageDirectionRTL();
  BOOL isRTL = [NSLocale mdf_isDefaultLanguageRTL];

  XCTAssertTrue(isZZZRTL == isRTL);
}

@end
