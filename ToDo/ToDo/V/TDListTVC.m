//
//  TDListTVC.m
//  ToDo
//
//  Created by fb on 17/3/1.
//  Copyright © 2017年 fb. All rights reserved.
//

#import "TDListTVC.h"

#define kSwipeThrehold 120.0

@interface TDListTVC()<UIGestureRecognizerDelegate> {
    CGPoint _panStartPoint;
    CGFloat _panStartOffset;
    CGFloat _swipeOffset;
    UIPanGestureRecognizer* _panGesture;
    SwipeDirection _swipeDirection;
}
@property (nonatomic, strong) UIView* leftView;
@property (nonatomic, strong) UILabel* leftTipLabel;

@property (nonatomic, strong) UIView* rightView;
@property (nonatomic, strong) UILabel* rightTipLabel;

@property (nonatomic, strong) UIView* swipeView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@end

@implementation TDListTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _swipeOffset = 0;
        _swipeDirection = swipeDirectionLeft2right;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.leftView = [[UIView alloc] init];
    self.leftView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.leftView];
    
    self.leftTipLabel = [[UILabel alloc] init];
    self.leftTipLabel.textColor = [UIColor whiteColor];
    self.leftTipLabel.font = [UIFont systemFontOfSize:12.0];
    self.leftTipLabel.text = @"Done";
    self.leftTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.leftView addSubview:self.leftTipLabel];
    
    self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.rightView];
    
    self.rightTipLabel = [[UILabel alloc] init];
    self.rightTipLabel.textColor = [UIColor whiteColor];
    self.rightTipLabel.font = [UIFont systemFontOfSize:12.0];
    self.rightTipLabel.textAlignment = NSTextAlignmentCenter;
    self.rightTipLabel.text = @"Delete";
    [self.rightView addSubview:self.rightTipLabel];
    
    self.swipeView = [[UIView alloc] init];
    self.swipeView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.swipeView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    //self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.swipeView addSubview:self.titleLabel];
    
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.textColor = [UIColor lightGrayColor];
    self.subtitleLabel.font = [UIFont systemFontOfSize:12.0];
    //self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.swipeView addSubview:self.subtitleLabel];
    
    
    //-- tap
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
//    [self.swipeView addGestureRecognizer:tap];
    
    //-- pan
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [self.swipeView addGestureRecognizer:_panGesture];
    _panGesture.delegate = self;
    
    [self setConstraits];
}

- (void)setConstraits {
    __weak __typeof(self) weakSelf = self;
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.swipeView.mas_left);
    }];
    [self.leftTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(weakSelf.leftView);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.swipeView.mas_right);
    }];
    [self.rightTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(weakSelf.rightView);
    }];
    
    [self.swipeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.width.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.swipeView.mas_left).offset(10);
        make.right.equalTo(weakSelf.swipeView.mas_right).offset(-10);
        make.top.equalTo(weakSelf.swipeView.mas_top).offset(5);
        make.bottom.equalTo(weakSelf.subtitleLabel.mas_top).offset(-5);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.swipeView.mas_left).offset(10);
        make.right.equalTo(weakSelf.swipeView.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.swipeView.mas_bottom).offset(-5);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(5);
    }];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma makr -- setters
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}
- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    self.subtitleLabel.text = _subtitle;
}



#pragma mark -- gesture
- (void)tapHandler:(UITapGestureRecognizer*)tapGes {

}


- (void)panHandler:(UIPanGestureRecognizer*)panGes {
    CGPoint current = [panGes translationInView:self];
    NSLog(@"--------->>>>>>>>>>>>>>> pan point:x %f, y:%f", current.x, current.y);
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        _panStartPoint = current;
        _panStartOffset = _swipeOffset;
    }
    else if (panGes.state == UIGestureRecognizerStateChanged) {
        _swipeOffset = _panStartOffset + current.x - _panStartPoint.x;
        NSLog(@"---------->>>>>>>>>>>>>>> pan offset : %f", _swipeOffset);
        _swipeDirection = _swipeOffset > 0 ? swipeDirectionLeft2right:swipeDirectionRight2left;
        __weak __typeof(self) weakSelf = self;
        [self.swipeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.contentView).offset(_swipeOffset);
        }];
        [self.swipeView layoutIfNeeded];
        
        CGFloat offset = ABS(_swipeOffset);
        if (_swipeDirection == swipeDirectionLeft2right) {
            self.leftTipLabel.text = offset >= kSwipeThrehold ? @"drag right to done" : @"Done";
            self.leftView.backgroundColor = [UIColor colorWithRed:(255.0-offset)/255.0 green:1.0 blue:(255.0-offset)/255.0 alpha:1.0];
        }
        else {
            self.rightTipLabel.text = offset >= kSwipeThrehold ? @"drag left to delete" : @"delete";
            self.rightView.backgroundColor = [UIColor colorWithRed:1.0 green:(255.0-offset)/255.0 blue:(255.0-offset)/255.0 alpha:1.0];
        }
    }
    else {
        NSLog(@"---------->>>>>>>>>>>> pan end");
        //开始动画
        [UIView beginAnimations:nil context:nil];
        
        __weak __typeof(self) weakSelf = self;
        
        
        //设定动画持续时间
        [UIView setAnimationDuration:2];
        
        
        [self.swipeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.contentView).offset(ABS(_swipeOffset) < kSwipeThrehold ? 0 : (_swipeDirection==swipeDirectionLeft2right?self.bounds.size.width:-self.bounds.size.width));
        }];
        //必须调用此方法，才能出动画效果
        [self.swipeView layoutIfNeeded];
        //动画结束
        [UIView commitAnimations];
        
        if (ABS(_swipeOffset) >= kSwipeThrehold && self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(swipeCell:direction:)]) {
            [self.cellDelegate swipeCell:self direction:_swipeDirection];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == _panGesture) {
        if (self.isEditing) {
            return NO; //do not swipe while editing table
        }
        
        CGPoint translation = [_panGesture translationInView:self];
        if (fabs(translation.y) > fabs(translation.x)) {
            return NO; // user is scrolling vertically
        }
    }
//    else if (gestureRecognizer == _tapRecognizer) {
//        CGPoint point = [_tapRecognizer locationInView:_swipeView];
//        return CGRectContainsPoint(_swipeView.bounds, point);
//    }
    return YES;
}

@end
