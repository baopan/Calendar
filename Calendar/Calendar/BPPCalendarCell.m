//
//  BPPCalendarCell.m
//  Animation
//
//  Created by Onway on 2017/4/7.
//  Copyright © 2017年 Onway. All rights reserved.
//

#import "BPPCalendarCell.h"

@implementation BPPCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
   // self.textLabel.backgroundColor = [UIColor redColor];
   // self.textLabel.textColor = [UIColor blueColor];
   // self.textLabel.text = @"sss";
    [self.contentView addSubview:self.textLabel];
}

@end
