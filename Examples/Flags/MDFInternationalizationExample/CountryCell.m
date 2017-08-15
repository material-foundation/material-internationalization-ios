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

#import "CountryCell.h"

#import <MDFInternationalization/MDFInternationalization.h>

@implementation CountryCell

// Mirroring images could take a non-trivial amount of time to create, so we cache the images.
static UIImage *sSpeakingIcon;
static UIImage *sNonspeakingIcon;

- (void)awakeFromNib {
  [super awakeFromNib];

  // A flag imageview should not be mirrored in Right-to-Left so we force the view to Left-to-Right.
  self.flagView.mdf_semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;

  // The speech indicator icon can be mirrored, so we keep the default of
  // UISemanticContentAttributeUnspecified.
  //  self.speechIcon.mdf_semanticContentAttribute = UISemanticContentAttributeUnspecified;

  // Our country name label takes up the middle of our cell, but will automatically align the
  // text based on it's default textAlignment of NSTextAlignmentNatural.  So we leave its
  // mdf_semanticContentAttribute value as the default UISemanticContentAttributeUnspecified.
  //  self.nameLabel.mdf_semanticContentAttribute = UISemanticContentAttributeUnspecified;

  // Mirroring images could take a non-trivial amount of time, so we cache the resulting images.
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sSpeakingIcon = [UIImage imageNamed:@"Speaking"];
    sNonspeakingIcon = [UIImage imageNamed:@"Nonspeaking"];
    if (self.speechIcon.mdf_effectiveUserInterfaceLayoutDirection !=
        UIUserInterfaceLayoutDirectionLeftToRight) {
      sSpeakingIcon = [sSpeakingIcon mdf_imageWithHorizontallyFlippedOrientation];
      sNonspeakingIcon = [sNonspeakingIcon mdf_imageWithHorizontallyFlippedOrientation];
    }
  });
}

- (void)layoutSubviews {
  // We manually calculate the frames for the views in our country cell
  CGFloat flagWidth = ceil(CGRectGetWidth(self.bounds) * 0.25);
  CGFloat flagHeight = CGRectGetHeight(self.bounds);
  CGRect flagFrame = CGRectMake(0.0, 0.0, flagWidth, flagHeight);
  flagFrame = CGRectInset(flagFrame, 4.0, 4.0);

  CGFloat speakIconWidth = ceil(CGRectGetWidth(self.bounds) * 0.15);
  CGFloat speakIconHeight = CGRectGetHeight(self.bounds);
  CGRect speechIconFrame = CGRectMake(0.0, 0.0, speakIconWidth, speakIconHeight);
  speechIconFrame.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(speechIconFrame);

  CGFloat nameWidth =
      CGRectGetWidth(self.bounds) - CGRectGetWidth(flagFrame) - CGRectGetWidth(speechIconFrame);
  CGFloat nameHeight = CGRectGetHeight(self.bounds);
  CGRect nameFrame = CGRectMake(0.0, 0.0, nameWidth, nameHeight);
  nameFrame.origin.x = CGRectGetMaxX(flagFrame);
  nameFrame = CGRectInset(nameFrame, 4.0, 0.0);

  // Mirror the framges if we are in RightToLeft mode.
  if (self.mdf_effectiveUserInterfaceLayoutDirection != UIUserInterfaceLayoutDirectionLeftToRight) {
    flagFrame = MDFRectFlippedHorizontally(flagFrame, CGRectGetWidth(self.bounds));
    nameFrame = MDFRectFlippedHorizontally(nameFrame, CGRectGetWidth(self.bounds));
    speechIconFrame = MDFRectFlippedHorizontally(speechIconFrame, CGRectGetWidth(self.bounds));
  }

  // Set the view frames
  self.flagView.frame = flagFrame;
  self.nameLabel.frame = nameFrame;
  self.speechIcon.frame = speechIconFrame;
}

// Adjust our speech indicator if we are actively speaking the name of the country.
- (void)setSpeakingName:(BOOL)speakingName {
  if (speakingName) {
    self.speechIcon.image = sSpeakingIcon;
  } else {
    self.speechIcon.image = sNonspeakingIcon;
  }
}

@end
