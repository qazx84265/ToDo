//
//  ToDo+CoreDataProperties.m
//  ToDo
//
//  Created by fb on 17/3/2.
//  Copyright © 2017年 fb. All rights reserved.
//

#import "ToDo+CoreDataProperties.h"

@implementation ToDo (CoreDataProperties)

+ (NSFetchRequest<ToDo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ToDo"];
}

@dynamic isDelay;
@dynamic isDone;
@dynamic repeat;
@dynamic timeE;
@dynamic timeS;
@dynamic title;

- (void)awakeFromInsert {
    self.title = @"defult";
    self.repeat = 0;
    self.isDone = NO;
    self.isDelay = NO;
}

@end
