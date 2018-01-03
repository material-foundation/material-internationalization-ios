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

#import "InformationViewController.h"

#import <MDFInternationalization/MDFInternationalization.h>

@interface InformationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *OSVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *localeLabel;
@property (weak, nonatomic) IBOutlet UILabel *LTRRTLLabel;
@property (weak, nonatomic) IBOutlet UIImageView *originalImage;
@property (weak, nonatomic) IBOutlet UIImageView *flippedImage;
@property (weak, nonatomic) IBOutlet UIImageView *twiceFlippedImage;
@property (weak, nonatomic) IBOutlet UIImageView *originalLTRImage;
@property (weak, nonatomic) IBOutlet UIImageView *flippedLTRImage;
@property (weak, nonatomic) IBOutlet UIImageView *twiceFlippedLTRImage;
@property (weak, nonatomic) IBOutlet UIImageView *originalRTLImage;
@property (weak, nonatomic) IBOutlet UIImageView *flippedRTLImage;
@property (weak, nonatomic) IBOutlet UIImageView *twiceFlippedRTLImage;

@end

static NSString *sWikipediaURL = @"https://wikipedia.org";

@implementation InformationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  self.deviceLabel.text = [UIDevice currentDevice].name;
  NSString *versionString = [NSString stringWithFormat:@"%@ - %@ %@",
                             [UIDevice currentDevice].localizedModel,
                             [UIDevice currentDevice].systemName,
                             [UIDevice currentDevice].systemVersion];
  self.OSVersionLabel.text = versionString;
  NSString *localeIdentifier = [NSLocale currentLocale].localeIdentifier;
  NSString *displayLocaleName =
      [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:localeIdentifier];
  NSString *localeString;
  if (displayLocaleName) {
    localeString = [NSString stringWithFormat:@"%@ - %@", localeIdentifier, displayLocaleName];
  } else {
    localeString = localeIdentifier;
  }

  self.localeLabel.text = localeString;
  NSString *userInterfaceLayoutDirectionString;
  if ([UIApplication sharedApplication].userInterfaceLayoutDirection
      == UIUserInterfaceLayoutDirectionLeftToRight) {
    userInterfaceLayoutDirectionString = NSLocalizedString(@"LeftToRight", @"LeftToRight");
  } else {
    userInterfaceLayoutDirectionString = NSLocalizedString(@"RightToLeft", @"RightToLeft");
  }
  self.LTRRTLLabel.text = userInterfaceLayoutDirectionString;

  UIImage *standardImage = [UIImage imageNamed:@"Standard"];
  UIImage *flippedImage = [standardImage mdf_imageWithHorizontallyFlippedOrientation];
  UIImage *twiceFlippedImage = [flippedImage mdf_imageWithHorizontallyFlippedOrientation];

  self.originalImage.image = standardImage;
  self.originalLTRImage.image = standardImage;
  self.originalRTLImage.image = standardImage;

  self.flippedImage.image = flippedImage;
  self.flippedLTRImage.image = flippedImage;
  self.flippedRTLImage.image = flippedImage;

  self.twiceFlippedImage.image = twiceFlippedImage;
  self.twiceFlippedLTRImage.image = twiceFlippedImage;
  self.twiceFlippedRTLImage.image = twiceFlippedImage;
}

- (IBAction)navigateToWikipedia:(id)sender {
  if ([sender isKindOfClass:[UIButton class]]) {
    NSURL *wikipediaURL = [NSURL URLWithString:sWikipediaURL];
    if (wikipediaURL &&
        [[UIApplication sharedApplication] canOpenURL:wikipediaURL]) {
      [[UIApplication sharedApplication] openURL:wikipediaURL];
    }
  }
}

@end
