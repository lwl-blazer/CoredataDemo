//
//  CoreDataManager.h
//  MorSearchProject
//
//  Created by morsearch on 2017/9/25.
//  Copyright © 2017年 morsearch. All rights reserved.
//
//
// CoreData 的管理基类
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoreDataManager : NSObject

//管理对象上下文
@property(nonatomic, strong, readonly) NSManagedObjectContext *manageObjectContext;

+ (instancetype)sharedManager;

//保存数据
- (void)save;

//用于iOS10
- (NSPersistentContainer *)getCurrentPersistentContainer;

@end
