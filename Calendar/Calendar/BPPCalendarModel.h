//
//  BPPCalendarModel.h
//  Animation
//
//  Created by Onway on 2017/4/7.
//  Copyright © 2017年 Onway. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^dateBlock)(NSUInteger,NSUInteger);

@interface BPPCalendarModel : NSObject

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, copy) dateBlock block;

- (NSArray *)setDayArr;

- (NSArray *)nextMonthDataArr;

- (NSArray *)lastMonthDataArr;

@end
