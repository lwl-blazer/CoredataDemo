//
//  Employee+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by morsearch on 2017/9/25.
//  Copyright © 2017年 morsearch. All rights reserved.
//

#import "Employee+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *brithday;
@property (nonatomic) float heigth;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *sectionName;
@property (nullable, nonatomic, retain) Department *department;

@end

NS_ASSUME_NONNULL_END
