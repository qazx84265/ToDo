//
//  ToDo+CoreDataProperties.h
//  ToDo
//
//  Created by fb on 17/3/2.
//  Copyright © 2017年 fb. All rights reserved.
//

#import "ToDo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ToDo (CoreDataProperties)

+ (NSFetchRequest<ToDo *> *)fetchRequest;

@property (nonatomic) BOOL isDelay;
@property (nonatomic) BOOL isDone;
@property (nonatomic) int16_t repeat;
@property (nullable, nonatomic, copy) NSDate *timeE;
@property (nullable, nonatomic, copy) NSDate *timeS;
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
