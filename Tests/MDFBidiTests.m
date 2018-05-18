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

//TODO Remove any GOO tests

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

- (void)testLTRStringDirection {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection MDFResult = [testString mdf_calculatedLanguageDirection];
  XCTAssertEqual(MDFResult, NSLocaleLanguageDirectionLeftToRight);
}

- (void)testGOOLTRStringDirection {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection MDFResult = [testString mdf_calculatedLanguageDirection];
  XCTAssertEqual(MDFResult, NSLocaleLanguageDirectionLeftToRight);

  //KM
  NSLocaleLanguageDirection GOOResult = GOOLanguageDirectionOfString(testString);
  XCTAssertEqual(MDFResult, GOOResult);
}

- (void)testRTLStringDirection {
  NSString *testString = @"الثعلب البني السريع يقفز فوق الكلب الكسول";
  NSLocaleLanguageDirection MDFResult = [testString mdf_calculatedLanguageDirection];
  XCTAssertEqual(MDFResult, NSLocaleLanguageDirectionRightToLeft);
}

- (void)testGOORTLStringDirection {
  NSString *testString = @"الثعلب البني السريع يقفز فوق الكلب الكسول";
  NSLocaleLanguageDirection MDFResult = [testString mdf_calculatedLanguageDirection];
  XCTAssertEqual(MDFResult, NSLocaleLanguageDirectionRightToLeft);

  //KM
  NSLocaleLanguageDirection GOOResult = GOOLanguageDirectionOfString(testString);
  XCTAssertEqual(MDFResult, GOOResult);
}

- (void)testAddLTRMarkers {
  NSString *testString = @"quick brown fox";
  NSString *wrappedString =
      [testString mdf_stringWithBidiMarkers:NSLocaleLanguageDirectionLeftToRight];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202aquick brown fox\u202c"]);
}

- (void)testGOOAddLTRMarkers {
  NSString *testString = @"quick brown fox";
  NSString *wrappedString =
  [testString mdf_stringWithBidiMarkers:NSLocaleLanguageDirectionLeftToRight];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202aquick brown fox\u202c"]);

  // KM
  NSString *gooString =
  GOOBidiUnicodeWrapWithLanguageDirection(testString, NSLocaleLanguageDirectionLeftToRight);
  XCTAssertTrue([wrappedString isEqualToString:gooString]);
}

- (void)testAddRTLMarkers {
  NSString *testString = @"quick brown fox";
  NSString *wrappedString =
      [testString mdf_stringWithBidiMarkers:NSLocaleLanguageDirectionRightToLeft];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202bquick brown fox\u202c"]);
}

- (void)testGOOAddRTLMarkers {
  NSString *testString = @"quick brown fox";
  NSString *wrappedString =
  [testString mdf_stringWithBidiMarkers:NSLocaleLanguageDirectionRightToLeft];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202bquick brown fox\u202c"]);

  // KM
  NSString *gooString =
  GOOBidiUnicodeWrapWithLanguageDirection(testString, NSLocaleLanguageDirectionRightToLeft);
  XCTAssertTrue([wrappedString isEqualToString:gooString]);
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

- (void)testGOOAddCalculatedMarkers {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSString *wrappedString =
  [testString mdf_stringWithBidiMarkers];
  XCTAssertTrue([wrappedString isEqualToString:@"\u202aThe quick brown fox jumps over the lazy dog.\u202c"]);

  // KM
  NSString *gooString =
  GOOBidiUnicodeWrap(testString);
  XCTAssertTrue([wrappedString isEqualToString:gooString]);
}

- (void)testStripMarkers {
  NSString *testString = @"\u202aThe quick brown fox jumps over the lazy dog.\u202c";
  NSString *strippedString = [testString mdf_stringWithBidiMarkersStripped];
  XCTAssertTrue([strippedString isEqualToString:@"The quick brown fox jumps over the lazy dog."]);
}

- (void)testGOOStripMarkers {
  NSString *testString = @"\u202aThe quick brown fox jumps over the lazy dog.\u202c";
  NSString *strippedString = [testString mdf_stringWithBidiMarkersStripped];
  XCTAssertTrue([strippedString isEqualToString:@"The quick brown fox jumps over the lazy dog."]);

  //KM
  NSString *gooString = GOOStripBidiUnicodeCharacters(testString);
  XCTAssertTrue([strippedString isEqualToString:gooString]);
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

- (void)testGOOLTRStereoIsolateLTR {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection stringDirection = NSLocaleLanguageDirectionLeftToRight;
  NSLocaleLanguageDirection contextDirection = NSLocaleLanguageDirectionLeftToRight;

  NSString *wrappedString =
      [testString mdf_stringWithStereoIsolate:stringDirection
                                      context:contextDirection];

  NSString *gooString = GOOBidiUnicodeWrapWithStereoReset(testString, stringDirection, contextDirection);
  XCTAssertTrue([wrappedString isEqualToString:gooString]);
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

- (void)testGOOLTRStereoIsolateRTL {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection stringDirection = NSLocaleLanguageDirectionLeftToRight;
  NSLocaleLanguageDirection contextDirection = NSLocaleLanguageDirectionRightToLeft;

  NSString *wrappedString =
  [testString mdf_stringWithStereoIsolate:stringDirection
                                  context:contextDirection];

  // !!! wrappedString is "\u202b\u202aThe quick brown fox jumps over the lazy dog.\u202c\u202c
  // !!! gooString is "\u200f\u202aThe quick brown fox jumps over the lazy dog.\u202c\u200f

  NSString *gooString = GOOBidiUnicodeWrapWithStereoReset(testString, stringDirection, contextDirection);
  XCTAssertTrue([wrappedString isEqualToString:gooString]);
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

- (void)testGOORTLStereoIsolateRTL {
  NSString *testString = @"The quick brown fox jumps over the lazy dog.";
  NSLocaleLanguageDirection stringDirection = NSLocaleLanguageDirectionRightToLeft;
  NSLocaleLanguageDirection contextDirection = NSLocaleLanguageDirectionRightToLeft;

  NSString *wrappedString =
  [testString mdf_stringWithStereoIsolate:stringDirection
                                  context:contextDirection];

  // !!! wrappedString is "\u202b\u202aThe quick brown fox jumps over the lazy dog.\u202c\u202c
  // !!! gooString is "\u200f\u202aThe quick brown fox jumps over the lazy dog.\u202c\u200f

  NSString *gooString = GOOBidiUnicodeWrapWithStereoReset(testString, stringDirection, contextDirection);
  XCTAssertTrue([wrappedString isEqualToString:gooString]);
}

//KM
- (void)testStandardStringBehavior {
  NSString *string = @"the quick brown fox";
  // This indicates it will return a new string, but it does not
  NSString *strippedString = [string stringByReplacingOccurrencesOfString:@"zebra" withString:@"antelope"];

  XCTAssertTrue([string isEqualToString:strippedString]);
  XCTAssertEqual(string, strippedString);
}

// Previous GOOBidiTests

- (void)testGOOLanguageDirectionOfPunctuationString {
  NSString *testString = @"@#%+=-^*";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionLeftToRight);
}

- (void)testGOOLanguageDirectionOfNumericString {
  NSString *testString = @"123";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionLeftToRight);
}

- (void)testGOOLanguageDirectionOfHebrewString {
  NSString *testString = @"!שלום";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionRightToLeft);
}

- (void)testGOOLanguageDirectionOfEnglishString {
  NSString *testString = @"Hello!";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionLeftToRight);
}

- (void)testGOOLanguageDirectionOfEmptyString {
  NSString *testString = @"";

  // Then
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionLeftToRight);
}

- (void)testGOOLanguageDirectionOfBidiString {
  NSString *rtlText =  @"اميل";
//  NSString *wrappedText = [rtlText mdf_stringWithBidiMarkers:NSLocaleLanguageDirectionRightToLeft];
  NSString *wrappedText =
      [rtlText mdf_stringWithStereoIsolate:NSLocaleLanguageDirectionRightToLeft
                                   context:NSLocaleLanguageDirectionLeftToRight];
  NSString *testString = [NSString stringWithFormat:@"Hello %@! (19 July)", wrappedText];
  // @"Hello اميل! (19 July)"

  //??? RTL - Arabic Characters having a stronger effect?  Is this intended behavior
  NSLocaleLanguageDirection direction = [testString mdf_calculatedLanguageDirection];

  // Then
  //TODO Test string contents, not direction.
  XCTAssertEqual([testString mdf_calculatedLanguageDirection], NSLocaleLanguageDirectionLeftToRight);
}

@end
