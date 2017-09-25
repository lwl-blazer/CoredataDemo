//
//  Department+CoreDataProperties.m
//  CoreDataDemo
//
//  Created by morsearch on 2017/9/25.
//  Copyright © 2017年 morsearch. All rights reserved.
//

#import "Department+CoreDataProperties.h"

@implementation Department (CoreDataProperties)

+ (NSFetchRequest<Department *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Department"];
}

/*
 * 所有的属性都用@dynamic修饰，CoreData会在运行时动态为所有Category中的属性生成实现代码，所以这里用@dynamic修饰
 */

@dynamic createDate;
@dynamic departName;
@dynamic employee;

@end
