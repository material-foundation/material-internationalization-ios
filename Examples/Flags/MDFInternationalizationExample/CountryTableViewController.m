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

#import "CountryTableViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "CountryCell.h"

@interface CountryTableViewController ()

@end

@implementation CountryTableViewController {
  NSArray<NSString *> *_countryCodes;
  NSMutableArray<UIImage *> *_flagImages;

  AVSpeechSynthesizer *_speechSynthesizer;
  NSMutableArray<NSIndexPath *> *_speakingCellIndexes;
}

- (void)viewDidLoad {
    [super viewDidLoad];

  _countryCodes = @[ @"ARG", @"AUS", @"BTN", @"CAN", @"FRA", @"GRC", @"IND", @"JAM", @"JPN", @"MEX",
                     @"NPL", @"PNG", @"QAT", @"SVK", @"TUN", @"USA", @"ZAF", @"ZMB" ];

  _flagImages = [[NSMutableArray alloc] initWithCapacity:_countryCodes.count];
  for (NSString *countryCode in _countryCodes) {
    UIImage *image = [UIImage imageNamed:countryCode];
    [_flagImages addObject:image];
  }

  _speakingCellIndexes = [[NSMutableArray alloc] init];

  _speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
  _speechSynthesizer.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (_speechSynthesizer.isPaused) {
    [_speechSynthesizer continueSpeaking];
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _countryCodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // NOTE: The string below must match the prototype cell identifier in the storyboard
  CountryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountryCell"];

  NSString *countryCode = _countryCodes[indexPath.row];
  UIImage *flagImage = _flagImages[indexPath.row];

  // Country names are taken from the Countries.strings file
  NSString *name = NSLocalizedStringFromTable(countryCode, @"Countries", @"ISO3 Country Code");

  cell.nameLabel.text = name;
  cell.flagView.image = flagImage;

  NSIndexPath *speakingIndexPath = [_speakingCellIndexes firstObject];
  if ([speakingIndexPath isEqual:indexPath]) {
    cell.speakingName = YES;
  } else {
    cell.speakingName = NO;
  }

  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *countryCode = _countryCodes[indexPath.row];
  NSString *name = NSLocalizedStringFromTable(countryCode, @"Countries", @"ISO3 Country Code");

  AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:name];
  [_speechSynthesizer speakUtterance:utterance];

  [_speakingCellIndexes addObject:indexPath];
}

#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
    willSpeakRangeOfSpeechString:(NSRange)characterRange
                       utterance:(AVSpeechUtterance *)utterance {
  NSIndexPath *indexPath = [_speakingCellIndexes firstObject];
  if (indexPath && [self.tableView.indexPathsForVisibleRows containsObject:indexPath]) {
    CountryCell *cell =
        (CountryCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    cell.speakingName = YES;

    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[ indexPath ]
                          withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
  }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
    didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
  NSIndexPath *indexPath = [_speakingCellIndexes firstObject];
  if (indexPath) {
    [_speakingCellIndexes removeObjectAtIndex:0];

    // Set speech icon back to normal when the country's name is finished being spoken
    if ([self.tableView.indexPathsForVisibleRows containsObject:indexPath]) {
      CountryCell *cell =
          (CountryCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
      cell.speakingName = NO;

      [self.tableView beginUpdates];
      [self.tableView reloadRowsAtIndexPaths:@[ indexPath ]
                            withRowAnimation:UITableViewRowAnimationNone];
      [self.tableView endUpdates];
    }
  }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
   didCancelSpeechUtterance:(AVSpeechUtterance *)utterance {
  // If the version of iOS is too old (~8.1 or earlier), we may be unable to speak country names.
  // In that case, present an alert to the user.
  NSIndexPath *indexPath = [_speakingCellIndexes firstObject];
  if (indexPath) {
    [_speakingCellIndexes removeObjectAtIndex:0];
  }

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *alertTitle =
        NSLocalizedString(@"Speech Error", @"Speech Error Alert Title");
    NSString *alertMessage =
        NSLocalizedString(@"Unable to speak country names", @"Speech Error Alert Message");
    UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:alertTitle
                                            message:alertMessage
                                     preferredStyle:UIAlertControllerStyleAlert];
    NSString *actionTitle = NSLocalizedString(@"Dismiss", @"Speech Error Alert Dismiss");
    UIAlertAction *dismissAction =
        [UIAlertAction actionWithTitle:actionTitle
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * _Nonnull action) {
      [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:dismissAction];

    [self presentViewController:alertController animated:YES completion:nil];
  });
}

@end
