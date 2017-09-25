//
//  Person+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by morsearch on 2017/9/25.
//  Copyright © 2017年 morsearch. All rights reserved.
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t age;
@property (nonatomic) BOOL grade;

@end

NS_ASSUME_NONNULL_END
