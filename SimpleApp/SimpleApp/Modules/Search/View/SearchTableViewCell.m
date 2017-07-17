//
//  SearchTableViewCell.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "SearchTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Search.h"
#import "NSString+isEmpty.h"

@interface SearchTableViewCell ()


/**
 目的地
 */
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;


@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@end

@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    @weakify(self)
    [RACObserve(self, searchModel) subscribeNext:^(Search *model) {
    @strongify(self)
      if (![NSString isEmpty:model.name] ) {
        NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc] initWithString:model.name];
        [nameStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, model.name.length)];
        if (![NSString isEmpty:self.searchValue]) {
          [nameStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[model.name rangeOfString:self.searchValue]];
        }
        self.destinationLabel.attributedText = nameStr;
      }

      self.descriptionLabel.text = [NSString stringWithFormat:@"%ld米 | %@",[model.distance integerValue],model.address];
  }];
  
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
