//
//  Employee+CoreDataProperties.m
//  CoreDataDemo
//
//  Created by morsearch on 2017/9/25.
//  Copyright © 2017年 morsearch. All rights reserved.
//

#import "Employee+CoreDataProperties.h"

@implementation Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
}

@dynamic brithday;
@dynamic heigth;
@dynamic name;
@dynamic sectionName;
@dynamic department;

@end
