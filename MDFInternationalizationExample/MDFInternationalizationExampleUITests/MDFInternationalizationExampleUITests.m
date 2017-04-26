//
//  MDFInternationalizationExampleUITests.m
//  MDFInternationalizationExampleUITests
//
//  Created by Ian Gordon on 4/26/17.
//  Copyright © 2017 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MDFInternationalizationExampleUITests : XCTestCase

@end

@implementation MDFInternationalizationExampleUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBasic {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testNavigation {
  // Use recording to get started writing UI tests.
  // Use XCTAssert and related functions to verify your tests produce the correct results.
  
  XCUIApplication *app = [[XCUIApplication alloc] init];
  XCUIElementQuery *tablesQuery = app.tables;
  [tablesQuery.staticTexts[@"Japan"] tap];
  
  XCUIElementQuery *tabBarsQuery = app.tabBars;
  [tabBarsQuery.buttons[@"Info"] tap];
  [tabBarsQuery.buttons[@"Flags"] tap];
  [tablesQuery.staticTexts[@"Mexico"] swipeUp];
  [tablesQuery.staticTexts[@"United States of America"] tap];
  [tablesQuery.staticTexts[@"Slovakia"] tap];

}

@end
