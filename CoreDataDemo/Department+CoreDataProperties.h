//
//  Department+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by morsearch on 2017/9/25.
//  Copyright © 2017年 morsearch. All rights reserved.
//
/*
 * 如果没有设置对多关系的实体，只会有CoreDataProperties   而设置了对多关系的实体系统会为其生成CoreDataGeneratedAccessors
 *
 * CoreDataProperties中会生成实体中声明的Attributes和Relationships中的属性，其中对多关系是用NSSet存储的属性，如果是对一的关系则是非集合的对象类型属性
 *
 * 对多属性生成的CoreDataGeneratedAccessors，是系统自动生成管理对多属性集合的方法，一般都是一个属性对应四个方法，方法都是用来操作集合对象的
 */

#import "Department+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Department (CoreDataProperties)

+ (NSFetchRequest<Department *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, copy) NSString *departName;
@property (nullable, nonatomic, retain) NSSet<Employee *> *employee;

@end

@interface Department (CoreDataGeneratedAccessors)

- (void)addEmployeeObject:(Employee *)value;
- (void)removeEmployeeObject:(Employee *)value;
- (void)addEmployee:(NSSet<Employee *> *)values;
- (void)removeEmployee:(NSSet<Employee *> *)values;

@end

NS_ASSUME_NONNULL_END
