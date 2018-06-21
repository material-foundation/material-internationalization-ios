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


static NSString *kMDFLTREmbedding = @"\u202a";  // left-to-right embedding
static NSString *kMDFRTLEmbedding = @"\u202b";  // right-to-left embedding
static NSString *kMDFBidiPopEmbedding = @"\u202c";  // pop directional embedding

static NSString *kMDFLTRMark = @"\u200e";  // left-to-right mark
static NSString *kMDFRTLMark = @"\u200f";  // right-to-left mark

// The following only work on iOS 10+
static NSString *kMDFLTRIsolate = @"\u2066";  // left-to-right isolate
static NSString *kMDFRTLIsolate = @"\u2067";  // right-to-left isolate
static NSString *kMDFFirstStrongIsolate = @"\u2068";  // first strong isolate
static NSString *kMDFPopIsolate = @"\u2069";  // pop directional isolate


@interface BidirectionalViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *labelFour;

@end

@implementation BidirectionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.labelOne.text = @"a-)-b  Isolate  a-\u2067)\u2069-b";
  self.labelTwo.text = @"a-)-b  Embed  a-\u202b)\u202c-b";
//  self.labelThree.text = @"1st  a-\u2068.)\u200f\u2069-b";
//  self.labelFour.text = @"1st  a-\u2068\u200f.)\u2069-b";
  NSString *three = [NSString stringWithFormat:@"Read %@15 books%@ EOL", kMDFFirstStrongIsolate, kMDFPopIsolate];
  self.labelThree.text = three;
  NSString *four = [NSString stringWithFormat:@"Read %@15 كتاب%@ EOL", kMDFFirstStrongIsolate, kMDFPopIsolate];
  self.labelFour.text = four;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
