//
//  TDListTVC.m
//  ToDo
//
//  Created by fb on 17/3/1.
//  Copyright © 2017年 fb. All rights reserved.
//

#import "TDListTVC.h"

#define kSwipeThrehold 70.0

@interface TDListTVC()<UIGestureRecognizerDelegate>
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
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.leftView = [[UIView alloc] init];
    [self.contentView addSubview:self.leftView];
    
    self.leftTipLabel = [[UILabel alloc] init];
    self.leftTipLabel.textColor = [UIColor whiteColor];
    self.leftTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.leftView addSubview:self.leftTipLabel];
    
    self.rightView = [[UIView alloc] init];
    [self.contentView addSubview:self.rightView];
    
    self.rightTipLabel = [[UILabel alloc] init];
    self.rightTipLabel.textColor = [UIColor whiteColor];
    self.rightTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.rightView addSubview:self.rightTipLabel];
    
    self.swipeView = [[UIView alloc] init];
    self.swipeView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.swipeView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.swipeView addSubview:self.titleLabel];
    
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.textColor = [UIColor whiteColor];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.swipeView addSubview:self.subtitleLabel];
    
    
    //-- tap
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self.swipeView addGestureRecognizer:tap];
    
    //-- pan
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [self.swipeView addGestureRecognizer:pan];
    pan.delegate = self;
    
    [self setConstraits];
}

- (void)setConstraits {
    __weak __typeof(self) weakSelf = self;
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(weakSelf.contentView);
        make.width.equalTo(@0);
    }];
    
    [self.leftTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(weakSelf.leftView);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(weakSelf.contentView);
        make.width.equalTo(@0);
    }];
    
    [self.rightTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(weakSelf.leftView);
    }];
    
    [self.swipeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView).offset(50);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.swipeView).offset(10);
        make.right.equalTo(weakSelf.swipeView).offset(-10);
        make.top.equalTo(weakSelf.swipeView).offset(5);
        make.bottom.equalTo(weakSelf.subtitleLabel).offset(-5);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.swipeView).offset(10);
        make.right.equalTo(weakSelf.swipeView).offset(-10);
        make.top.equalTo(weakSelf.titleLabel).offset(5);
        make.bottom.equalTo(weakSelf.swipeView).offset(-5);
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

#pragma mark -- setters
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

}


@end
