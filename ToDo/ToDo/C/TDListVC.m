//
//  TDListVC.m
//  ToDo
//
//  Created by fb on 17/3/1.
//  Copyright © 2017年 fb. All rights reserved.
//

#import "TDListVC.h"
#import "ToDo+CoreDataClass.h"
#import "TDListTVC.h"


@interface TDListVC ()<UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* todoList;
@property (nonatomic) dispatch_queue_t sessionQueue;
@end

@implementation TDListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sessionQueue = dispatch_get_main_queue();//dispatch_queue_create( "session queue", DISPATCH_QUEUE_SERIAL);//
    self.todoList = [[NSMutableArray alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 66.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[TDListTVC class] forCellReuseIdentifier:@"TDListTVC"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTodo:)];
    
    [self getCachedTodos];
}

- (void)getCachedTodos {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self.sessionQueue, ^{
        NSArray* arr = [ToDo MR_findAll];//[ToDo MR_findByAttribute:@"isDone" withValue:[NSNumber numberWithBool:YES]];//
        if (arr && arr.count>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.todoList addObjectsFromArray:arr];
                [weakSelf.tableView reloadData];
            });
        }
    });
}

- (void)addTodo:(id)sender {
    ToDo* todo = [ToDo MR_createEntity];
    //todo.title = @"New Todo";
    [self.todoList addObject:todo];
    [self.tableView reloadData];
    
    dispatch_async(self.sessionQueue, ^{
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    });
    
//    UIApplication *application = [UIApplication sharedApplication];
//    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
//        [application endBackgroundTask:bgTask];
//        bgTask = UIBackgroundTaskInvalid;
//    }];
//    
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//        
//        // Do your work to be saved here
//        todo.title = @"New Todo 1";
//    } completion:^(BOOL success, NSError *error) {
//        NSLog(@"------->>>>>>>>>>> save %@", success?@"success":[NSString stringWithFormat:@"failure:%@", [error localizedDescription]]);
//        [application endBackgroundTask:bgTask];
//        bgTask = UIBackgroundTaskInvalid;
//    }];
}

#pragma mark -- tableview delegate && datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.todoList.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return self.tableView.frame.size.width;
//}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString* cellID = @"TDListTVC";
    TDListTVC* cell = [tableView dequeueReusableCellWithIdentifier:@"TDListTVC"];

    //cell.delegate = self;
    
    ToDo* todo = [self.todoList objectAtIndex:indexPath.row];
    cell.title = @"圣诞节福建省代理费就当减肥来得及发链接打开了房间来得及福利大解放路口等级分类登记法律";
    cell.subtitle = @"2022-22-22 22:22 -- 2022-22-22 22:22";
    
    return cell;
}


#pragma mark -- swip cell delegate
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point {
    return YES;
}

-(nullable NSArray<UIView*>*) swipeTableCell:(nonnull MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(nonnull MGSwipeSettings*) swipeSettings expansionSettings:(nonnull MGSwipeExpansionSettings*) expansionSettings {
    
    swipeSettings.transition = MGSwipeTransitionClipCenter;
    swipeSettings.keepButtonsSwiped = NO;
    expansionSettings.buttonIndex = 0;
    expansionSettings.threshold = 1.0;
    expansionSettings.expansionLayout = MGSwipeExpansionLayoutCenter;
    expansionSettings.expansionColor = direction==MGSwipeDirectionRightToLeft?[UIColor colorWithRed:238/255.0 green:59/255.0 blue:59/255.0 alpha:1.0]:[UIColor colorWithRed:33/255.0 green:175/255.0 blue:67/255.0 alpha:1.0];
    expansionSettings.triggerAnimation.easingFunction = MGSwipeEasingFunctionCubicOut;
    expansionSettings.fillOnTrigger = NO;
    
    __weak __typeof(self) weakSelf = self;
    //MailData * mail = [self.todoList objectAtIndex:[self.tableView indexPathForCell:cell].row].;
    
    if (direction == MGSwipeDirectionLeftToRight) {
        
        expansionSettings.fillOnTrigger = NO;
        expansionSettings.threshold = 2;
        return @[[MGSwipeButton buttonWithTitle:@"Done" backgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0] padding:5 callback:^BOOL(MGSwipeTableCell *sender) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf == nil) {
                return YES;
            }
            NSIndexPath* indexPath = [strongSelf.tableView indexPathForCell:sender];
            ToDo* todo = [strongSelf.todoList objectAtIndex:indexPath.row];
            todo.isDone = YES;
            dispatch_async(self.sessionQueue, ^{
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            });

            [cell refreshContentView]; //needed to refresh cell contents while swipping
            
            [strongSelf.todoList removeObject:todo];
            
            [strongSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            return YES;
        }]];
    }
    else {
        
        expansionSettings.fillOnTrigger = YES;
        expansionSettings.threshold = 1.1;
        
        CGFloat padding = 15;
        
        MGSwipeButton * trash = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf == nil) {
                return NO;
            }
            NSIndexPath* indexPath = [strongSelf.tableView indexPathForCell:sender];
            ToDo* todo = [strongSelf.todoList objectAtIndex:indexPath.row];
            [todo MR_deleteEntity];
            dispatch_async(self.sessionQueue, ^{
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            });
            
            [strongSelf.todoList removeObject:todo];
            
            [strongSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            return NO; //don't autohide to improve delete animation
        }];
        
        return @[trash];
    }
    
    return nil;
}

@end
