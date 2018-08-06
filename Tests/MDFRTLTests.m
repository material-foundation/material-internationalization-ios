/*
 Copyright 2016-present Google Inc. All Rights Reserved.

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

@interface RTLTests : XCTestCase

@end

@implementation RTLTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMDCRectHorizontallyFlipped {
  CGRect frame = CGRectMake(10.0, 20.0, 50.0, 30.0);
  CGRect flippedFrame = MDFRectFlippedHorizontally(frame, 100.0);
  CGRect validResultFrame = CGRectMake(40.0, 20.0, 50.0, 30.0);

  XCTAssert(CGRectEqualToRect(flippedFrame, validResultFrame));
}

- (void)testMDCRectDoublyHorizontallyFlipped {
  CGRect frame = CGRectMake(10.0, 20.0, 50.0, 30.0);
  CGRect flippedFrame = MDFRectFlippedHorizontally(frame, 100.0);
  CGRect twiceFlippedFrame = MDFRectFlippedHorizontally(flippedFrame, 100.0);

  XCTAssert(CGRectEqualToRect(frame, twiceFlippedFrame));
}

- (void)testNegativeMDCRectHorizontallyFlipped {
  CGRect frame = CGRectMake(60.0, 50.0, -50.0, -30.0);
  CGRect flippedFrame = MDFRectFlippedHorizontally(frame, 100.0);
  CGRect validResultFrame = CGRectMake(40.0, 20.0, 50.0, 30.0);

  XCTAssert(CGRectEqualToRect(flippedFrame, validResultFrame));
}

- (void)testMDCRectFlippedForRTLRightToLeft {
  CGRect frame = CGRectMake(10.0, 20.0, 50.0, 30.0);
  CGFloat boundsWidth = 100.0;
  CGRect flippedFrame = MDFRectFlippedHorizontally(frame, boundsWidth);
  CGRect validResultFrame = CGRectMake(40.0, 20.0, 50.0, 30.0);

  XCTAssert(CGRectEqualToRect(flippedFrame, validResultFrame));
}

- (void)testMDCRectFlippedForRTLNegativeRightToLeft {
  CGRect frame = CGRectMake(60.0, 50.0, -50.0, -30.0);
  CGFloat boundsWidth = 100.0;
  CGRect flippedFrame = MDFRectFlippedHorizontally(frame, boundsWidth);
  CGRect validResultFrame = CGRectMake(40.0, 20.0, 50.0, 30.0);

  XCTAssert(CGRectEqualToRect(flippedFrame, validResultFrame));
}

- (void)testMDCInsetsMakeWithLayoutDirectionLeftToRight {
  UIEdgeInsets insets = MDFInsetsMakeWithLayoutDirection(10, 20, 30, 40, UIUserInterfaceLayoutDirectionLeftToRight);
  XCTAssertEqual(insets.left, 20);
  XCTAssertEqual(insets.right, 40);
}

- (void)testMDCInsetsMakeWithLayoutDirectionRightToLeft {
  UIEdgeInsets insets = MDFInsetsMakeWithLayoutDirection(10, 20, 30, 40, UIUserInterfaceLayoutDirectionRightToLeft);
  XCTAssertEqual(insets.left, 40);
  XCTAssertEqual(insets.right, 20);
}

- (void)testMDCRTLFlippedImagePortsRenderingMode {
  UIImage *image = [RTLTests standardImage];
  UIImage *flippedImage = [image mdf_imageWithHorizontallyFlippedOrientation];

  XCTAssertTrue(image.renderingMode == UIImageRenderingModeAutomatic);
  XCTAssertTrue(flippedImage.renderingMode == UIImageRenderingModeAutomatic);

  UIImage *templateImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  UIImage *flippedTemplateImage = [templateImage mdf_imageWithHorizontallyFlippedOrientation];

  XCTAssertTrue(templateImage.renderingMode == UIImageRenderingModeAlwaysTemplate);
  XCTAssertTrue(flippedTemplateImage.renderingMode == UIImageRenderingModeAlwaysTemplate);

  UIImage *originalImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  UIImage *flippedOriginalImage = [originalImage mdf_imageWithHorizontallyFlippedOrientation];

  XCTAssertTrue(originalImage.renderingMode == UIImageRenderingModeAlwaysOriginal);
  XCTAssertTrue(flippedOriginalImage.renderingMode == UIImageRenderingModeAlwaysOriginal);
}

//TODO: (#6) Implement per-pixel comparison
//- (void)testImageMirror {
//  UIImage *sourceImage = [RTLTests standardImage];
//  UIImage *flippedImage = [sourceImage mdf_imageWithHorizontallyFlippedOrientation];
//  UIImage *twiceFlippedImage = [flippedImage mdf_imageWithHorizontallyFlippedOrientation];

// sourceImage != flippedImage
// sourceImage == twiceFlippedImage
//}


// Pixel Image is a 1 x 1 red square
+ (UIImage *)pixelImage {
  CGRect frame = CGRectMake(0.0, 0.0, 1.0, 1.0);

  UIGraphicsBeginImageContext(frame.size);

  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
  CGContextFillRect(context, frame);

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

// Standard Image is a blue rectangle with a green line from top left to bottom right
+ (UIImage *)standardImage {
  static UIImage *image;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    CGRect frame = CGRectMake(0.0, 0.0, 60.0, 40.0);

    UIGraphicsBeginImageContext(frame.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextFillRect(context, frame);

    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(context, 1.0);

    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, 60.0, 40.0);

    CGContextStrokePath(context);

    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  });

  return image;
}

@end
