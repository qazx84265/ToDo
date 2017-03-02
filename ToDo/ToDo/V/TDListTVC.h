//
//  TDListTVC.h
//  ToDo
//  ToDo item cell
//  Created by fb on 17/3/1.
//  Copyright © 2017年 fb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SwipeDirection) {
    swipeDirectionLeft2right = 0,
    swipeDirectionRight2left
};

@class TDListTVC;
@protocol TDListTVCDelegate <NSObject>
- (void)swipeCell:(TDListTVC*)cell direction:(SwipeDirection)direction;
@end

@interface TDListTVC : UITableViewCell
@property (nonatomic, weak) NSIndexPath* cellIdx;
@property (nonatomic, weak) id<TDListTVCDelegate> cellDelegate;

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;
@end
