//
//  BPPCalendar.m
//  Animation
//
//  Created by Onway on 2017/4/7.
//  Copyright © 2017年 Onway. All rights reserved.
//

#import "BPPCalendar.h"
#import "BPPCalendarModel.h"
#import "BPPCalendarCell.h"


@interface BPPCalendar () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong)  BPPCalendarModel *calendarModel;
@property (nonatomic, strong) NSArray *weekArray;
@property (nonatomic, strong) NSArray *dayArray;
@property (nonatomic, strong) UICollectionView *calendarCollectView;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) UILabel *titlelabel;
@property (nonatomic, strong) NSMutableDictionary *mutDict;

@end

@implementation BPPCalendar

- (UILabel *)titlelabel {
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 60, 20, 120, 30)];
        _titlelabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titlelabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self initDataSourse];
        [self stepUI];
    }
    return self;
}

//初始化数据
- (void)initDataSourse {
    __weak typeof(self) weakSelf = self;
    _weekArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
   _calendarModel = [[BPPCalendarModel alloc] init];
    self.calendarModel.block = ^(NSUInteger year, NSUInteger month) {
        weakSelf.titlelabel.text = [NSString stringWithFormat:@"%ld年%ld月",year,month];
    };
    _dayArray = [_calendarModel setDayArr];
    self.index = _calendarModel.index;
    _mutDict = [NSMutableDictionary new];
}

//布局
- (void)stepUI {
    [self addSubview:self.titlelabel];
    CGFloat width = self.bounds.size.width/7.0;
    UIButton *lastBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 60, 30)];
    [lastBtn setTitle:@"上一月" forState:UIControlStateNormal];
    [lastBtn addTarget:self action:@selector(lastMonthClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lastBtn];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 80, 20, 60, 30)];
    [nextBtn setTitle:@"下一月" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextMonthClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextBtn];
    
    for (int i = 0; i < [_weekArray count]; i ++) {
        UIButton *weekBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 50, width, width)];
        [weekBtn setTitle:_weekArray[i] forState:UIControlStateNormal];
        [self addSubview:weekBtn];
    }
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.minimumLineSpacing = 0;
    flowlayout.minimumInteritemSpacing = 0;
    _calendarCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, width + 50, self.bounds.size.width, self.bounds.size.height - width) collectionViewLayout:flowlayout];
    _calendarCollectView.delegate = self;
    _calendarCollectView.dataSource = self;
    [_calendarCollectView registerClass:[BPPCalendarCell class] forCellWithReuseIdentifier:@"cell"];
    _calendarCollectView.backgroundColor = [UIColor yellowColor];
    self.calendarCollectView.alwaysBounceVertical=YES;
    [self addSubview:_calendarCollectView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dayArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width/7.0, self.bounds.size.width/7.0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BPPCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dayArray[indexPath.row];
    if (self.index == indexPath.row) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.layer.cornerRadius = cell.textLabel.frame.size.height/2.0;
        cell.textLabel.clipsToBounds = YES;
        cell.textLabel.backgroundColor = [UIColor redColor];
    }else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.clipsToBounds = NO;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        if ([self.mutDict valueForKey:[NSString stringWithFormat:@"%ld",indexPath.row]]) {
            cell.contentView.backgroundColor = [UIColor lightGrayColor];
        }else {
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
    }
    
    return cell;
}

- (void)lastMonthClick {
    [self.mutDict removeAllObjects];
    self.dayArray = [self.calendarModel lastMonthDataArr];
    [self.calendarCollectView reloadData];
}

- (void)nextMonthClick {
    [self.mutDict removeAllObjects];
    self.dayArray = [self.calendarModel nextMonthDataArr];
    [self.calendarCollectView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    BPPCalendarCell *cell = (BPPCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    [self.mutDict removeAllObjects];
    [self.mutDict setValue:@"value" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
    [self.calendarCollectView reloadData];
    
    //我将数据分为三部分处理，第一，获取本月的天数范围，第二，获取上个月与本月第一天遗留的天数，第三，获取到本月最后一天yu
}


@end
