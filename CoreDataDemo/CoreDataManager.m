//
//  CoreDataManager.m
//  MorSearchProject
//
//  Created by morsearch on 2017/9/25.
//  Copyright © 2017年 morsearch. All rights reserved.
//

#import "CoreDataManager.h"
#import <UIKit/UIKit.h>


@interface CoreDataManager ()

/*iOS9 三个核心类*/

@property(nonatomic, strong) NSManagedObjectContext *managerContext;

@property(nonatomic, strong) NSManagedObjectModel *managerObjectModel;

@property(nonatomic, strong) NSPersistentStoreCoordinator *storeCoordinator;


/* iOS 10中的NSPersistentContainer *
 * 
 * CoreData stack容器
 *
 * 管理上下文对象  NSManagerObjectContext *viewContext
 * 
 * 对象管理模型  NSManagerObjectModel *managerModelObject
 *
 * 存储调度器  NSPersistentStoreCoordinator *persistentStoreCoordinator
 *
 */
@property(nonatomic, strong) NSPersistentContainer *persistentContainer;

@end


@implementation CoreDataManager

+ (instancetype)sharedManager{
    static CoreDataManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,  ^{
        sharedManager = [[CoreDataManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark --- Public Method -----

- (void)save{
    NSError *error = nil;
    
    if ([[CoreDataManager sharedManager].manageObjectContext hasChanges]) {
        [[CoreDataManager sharedManager].manageObjectContext save:&error];
    }
    
    if (error) {
        NSLog(@"存储失败:%@", error);
        abort();
    }else{
        NSLog(@"存储成功");
    }
}

/*
 * 通过方法返回iOS10的NSPersistentContainer
 * iOS9 返回nil
 * 主要目的是便于使用iOS多线程操作数据库
 */
- (NSPersistentContainer *)getCurrentPersistentContainer{
    
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 10.0) {
        return self.persistentContainer;
    }
    
    return nil;
}


- (NSManagedObjectContext *)manageObjectContext{

    if ([[UIDevice currentDevice] systemVersion].floatValue < 10.0) {
        
        return [CoreDataManager sharedManager].managerContext;
        
    }else{
        return [CoreDataManager sharedManager].persistentContainer.viewContext;

    }
}


#pragma mark ---- iOS8, iOS9 -----
//获取沙盒路径
- (NSURL *)getDocumentUrl{
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
}

- (NSManagedObjectModel *)managerObjectModel{
   
    if (_managerObjectModel != nil) {
        return _managerObjectModel;
    }
    
    //根据某个模型文件路径创建文件
    //_managerObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Person" withExtension:@"momd"]];
    
    //合并Bundle所有.momd文件
    //bundles为nil的时候，自动从mainBundle里查找所有的.momd文件
    _managerObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managerObjectModel;
}


- (NSPersistentStoreCoordinator *)storeCoordinator{
    if (_storeCoordinator != nil) {
        return _storeCoordinator;
    };
    
    //根据模型文件创建存储调度器
    
    _storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managerObjectModel];
    
    /*
     * 给调度存储器添加存储器
     * type:存储类型   configuration: 配置信息 nil  options:属性信息 nil URL:存储文件路径
     */
    NSURL *url = [[self getDocumentUrl] URLByAppendingPathComponent:@"CoreDataDemo.momd" isDirectory:YES];
    [_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    
    NSLog(@"%@", _storeCoordinator.persistentStores[0].URL);
    
    return _storeCoordinator;
}

- (NSManagedObjectContext *)managerContext{
    if (_managerContext != nil) {
        return _managerContext;
    }
    
    //参数表示线程类型  NSPrivateQueueConcurrencyType比NSMainQueueConcurrencyType略有延迟
    _managerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //设置存储调度器
    [_managerContext setPersistentStoreCoordinator:self.storeCoordinator];
    
    return _managerContext;
}

#pragma mark ---  iOS 10 CoreData Stack -----

- (NSPersistentContainer *)persistentContainer{
    
    if (_persistentContainer != nil) {
        return _persistentContainer;
    }
    
    //创建对象管理模型
    NSManagedObjectModel *objectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    //创建NSPersistentContainer
    _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CoreDataDemo" managedObjectModel:objectModel];
    
    //添加存储器
    [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull storeDescription, NSError * _Nullable error) {
        NSLog(@"%@", error);
        
        NSLog(@"%@", storeDescription);
    
    }];
    
    return _persistentContainer;
}
@end
