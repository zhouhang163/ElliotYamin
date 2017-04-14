//
//  AFFMenuDrop.m
//  AFFMenuDrop
//
//  Created by Lydix-Liu on 15/8/14.
//  Copyright (c) 2015年 某隻. All rights reserved.
//
#define kHeight_Section_M                    36.0f 

#import "AFFMenuDrop.h"

@implementation AFFMenuDrop

+ (AFFMenuDrop *)menuWithItems:(NSArray *)items atLocation:(EMenuDropLocation)location {
    return [[AFFMenuDrop alloc] initWithItems:items atLocation:location];
}

- (id)initWithItems:(NSArray *)items atLocation:(EMenuDropLocation)location {
    if (self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds]) {
        self.mArrItems = [NSMutableArray arrayWithArray:items];
        self.location = location;
        [self setup];
    }
    return self;
}

- (void)setup {
    CGRect frame = CGRectZero;
    frame.size.height = (self.mArrItems.count > 6 ? 6 : self.mArrItems.count) * kHeight_Section_M + 30;
    AFFMenuDropItem *largeItem = self.mArrItems.firstObject;
    for (AFFMenuDropItem *item in self.mArrItems) {
        if (item.title.length > largeItem.title.length) {
            largeItem = item;
        }
    }
    
    if (self.mArrItems.count > 0 && [(AFFMenuDropItem *)[self.mArrItems objectAtIndex:0] imageName]) {
        frame.size.width = 119;
        if (largeItem.title.length > 4) {
            frame.size.width += (largeItem.title.length - 4) * 13;
        }
    } else {
        frame.size.width = 108;
        if (largeItem.title.length > 4) {
            frame.size.width += (largeItem.title.length - 4) * 13;
        }
    }
    
    CGFloat navHeight = IOS_VERSION < 7.f ? kNavigationBar_Height : (kStatusBar_Height + kNavigationBar_Height);
    
    switch (self.location) {
        case EMenuDropLocationLeft:
            frame.origin = CGPointMake(6, navHeight);
            break;
        case EMenuDropLocationCenter:
            frame.origin = CGPointMake(SCREEN_WIDTH/2-frame.size.width/2, navHeight);
            break;
        case EMenuDropLocationRight:
            frame.origin = CGPointMake(SCREEN_WIDTH - 6 - frame.size.width, navHeight);
            break;
            
        default:
            break;
    }
    frame.origin.y -= 10;
    self.dropView = [[UIView alloc] initWithFrame:frame];
    self.dropView.backgroundColor = [UIColor whiteColor];
    self.dropView.layer.masksToBounds = YES;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height-10)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    [self.dropView addSubview:tableView];
    [self setGradientColor];
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    [self setMask:self.dropView];
    
    [self addSubview:self.dropView];
}

- (void)setGradientColor {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.dropView.frame.size.width, 20)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view1.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1 alpha:1].CGColor,
                       (id)[UIColor colorWithWhite:1 alpha:0].CGColor,nil];
    [view1.layer insertSublayer:gradient atIndex:0];
    
    [self.dropView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.dropView.bounds.size.height - 20, self.dropView.frame.size.width, 20)];
    
    CAGradientLayer *gradient2 = [CAGradientLayer layer];
    gradient2.frame = view2.bounds;
    gradient2.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1 alpha:0].CGColor,
                        (id)[UIColor colorWithWhite:1 alpha:1].CGColor,nil];
    [view2.layer insertSublayer:gradient2 atIndex:0];
    
    [self.dropView addSubview:view2];
}

- (void)show {
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
    
    __block CGRect frame = self.dropView.frame;
    CGFloat height = frame.size.height;
    frame.origin.y = kNavigationBar_Height+kStatusBar_Height-10;
    frame.size.height = 0;
    self.dropView.frame = frame;
    
    for (UIWindow *window in frontToBackWindows) {
        if (window.windowLevel == UIWindowLevelNormal) {
            [window addSubview:self];
            break;
        }
    }
    
    [UIView animateWithDuration:.15 animations:^{
        frame.size.height = height;
        self.dropView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
    [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchDown];
}

- (void)dismiss {
    __block CGRect frame = self.dropView.frame;
    frame.size.height = 0;
    [UIView animateWithDuration:.2 animations:^{
        self.dropView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.dropView removeFromSuperview];
        [self removeTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchDown];
    }];
}

- (void)setMask:(UIView *)view {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint trTop = CGPointMake(view.bounds.size.width/2, 0);
    if (self.location == EMenuDropLocationRight) {
        trTop.x = view.bounds.size.width - 15;
    } else if (self.location == EMenuDropLocationLeft) {
        trTop.x = 15;
    }
    
    [path moveToPoint:CGPointMake(10, 10)];
    [path addLineToPoint:CGPointMake(trTop.x-5, 10)];
    [path addLineToPoint:trTop];
    [path addLineToPoint:CGPointMake(trTop.x+5, 10)];
    [path addLineToPoint:CGPointMake(view.bounds.size.width-5, 10)];
    [path addArcWithCenter:CGPointMake(view.bounds.size.width-3,13) radius:3 startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    [path addLineToPoint:CGPointMake(view.bounds.size.width, view.bounds.size.height-3)];
    [path addArcWithCenter:CGPointMake(view.bounds.size.width-3, view.bounds.size.height-3) radius:3 startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(3, view.bounds.size.height)];
    [path addArcWithCenter:CGPointMake(3, view.bounds.size.height-3) radius:3 startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(0, 13)];
    [path addArcWithCenter:CGPointMake(3, 13) radius:3 startAngle:M_PI endAngle:M_PI_2*3 clockwise:YES];
    [path closePath];
    
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:path.CGPath];
    view.layer.mask = shape;
}

#pragma mark - tableview delegate & datasouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mArrItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeight_Section_M;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
    }
    cell.backgroundColor = [UIColor clearColor];
    NSString *imageName = [(AFFMenuDropItem *)[self.mArrItems objectAtIndex:indexPath.row] imageName];
    NSString *title = [(AFFMenuDropItem *)[self.mArrItems objectAtIndex:indexPath.row] title];
    
    if (imageName) {
        if ([cell viewWithTag:100]) {
            [(UIImageView*)[cell viewWithTag:100] setImage:[UIImage imageNamed:imageName]];
        } else {
            UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            imageV.frame = CGRectMake(15, 10, 15, 15);
            imageV.tag = 100;
            [cell addSubview:imageV];
        }
        
        if ([cell viewWithTag:101]) {
            [(UILabel *)[cell viewWithTag:101] setText:title];
        } else {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 120, 15)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:14];
            label.text = title;
            label.tag = 101;
            [cell addSubview:label];
        }
    } else {
        if ([cell viewWithTag:101]) {
            [(UILabel *)[cell viewWithTag:101] setText:title];
        } else {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 75, 15)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:13];
            label.text = title;
            label.tag = 101;
            [cell addSubview:label];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dropView removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuDrop:didSelectItem:)]) {
        [self.delegate menuDrop:self didSelectItem:[self.mArrItems objectAtIndex:indexPath.row]];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuDrop:didSelectItemAtIndex:)]) {
        [self.delegate menuDrop:self didSelectItemAtIndex:indexPath.row];
    }
}

@end


@implementation AFFMenuDropItem

+ (AFFMenuDropItem *)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    return [[AFFMenuDropItem alloc] initWithTitle:title imageName:imageName];
}

+ (NSArray *)itemsWithTitles:(NSArray *)titles images:(NSArray *)images {
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i++) {
        AFFMenuDropItem *item = [AFFMenuDropItem initWithTitle:titles[i] imageName:images[i]];
        item.index = i;
        [arr addObject:item];
    }
    
    return arr;
}

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString*)imageName {
    if (self = [super init]) {
        self.title = title;
        self.imageName = imageName;
    }
    return self;
}

@end



