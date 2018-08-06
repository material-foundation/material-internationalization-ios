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

#import "BidirectionalViewController.h"


static NSString *LTREmbedding = @"\u202a";  // left-to-right embedding
static NSString *RTLEmbedding = @"\u202b";  // right-to-left embedding
static NSString *BidiPopEmbedding = @"\u202c";  // pop directional embedding

static NSString *LTRMark = @"\u200e";  // left-to-right mark
static NSString *RTLMark = @"\u200f";  // right-to-left mark

// The following only work on iOS 10+
static NSString *LTRIsolate = @"\u2066";  // left-to-right isolate
static NSString *RTLIsolate = @"\u2067";  // right-to-left isolate
static NSString *FirstStrongIsolate = @"\u2068";  // first strong isolate
static NSString *PopIsolate = @"\u2069";  // pop directional isolate


@interface BidirectionalViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *labelFour;

@end

@implementation BidirectionalViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // The following lines will display a (: if the markers are supported, ): if not.
  self.labelOne.text =
      [NSString stringWithFormat:@"Bidi Isolate supported %@)%@:", RTLIsolate, PopIsolate];
  self.labelTwo.text =
      [NSString stringWithFormat:@"Bidi Embed supported %@)%@:", RTLEmbedding, BidiPopEmbedding];

  NSString *three = [NSString stringWithFormat:@"Read %@15 books%@ EOL", FirstStrongIsolate, PopIsolate];
  self.labelThree.text = three;
  NSString *four = [NSString stringWithFormat:@"Read %@15 كتاب%@ EOL", FirstStrongIsolate, PopIsolate];
  self.labelFour.text = four;
}

@end
