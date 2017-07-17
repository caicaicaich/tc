//
//  TCLocationCell.m
//  SimpleApp
//
//  Created by jearoc on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "TCLocationCell.h"

@interface TCLocationCell ()

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *desc;

@end

@implementation TCLocationCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindModel:(Search *)model
{
  self.title.text = model.name;
  self.desc.text = [NSString stringWithFormat:@"%@米 | %@",model.distance,model.address];
}

@end
