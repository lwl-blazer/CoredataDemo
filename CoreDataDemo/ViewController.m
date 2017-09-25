//
//  ViewController.m
//  CoreDataDemo
//
//  Created by morsearch on 2017/9/25.
//  Copyright © 2017年 morsearch. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataManager.h"
#import "Person+CoreDataClass.h"
#import "Employee+CoreDataClass.h"
#import "Department+CoreDataClass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 * MOC将操作的数据存放在缓存层，只有调用MOC的save方法后，才会真正对数据库进行操作，否则这个对象只是存在内存中，这样做避免了频繁的数据库访问
 */
- (IBAction)add:(id)sender {
    Employee *em = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:[CoreDataManager sharedManager].manageObjectContext];
    em.name = @"blazer";
    em.heigth = 1.7;
    em.brithday = [NSDate date];
    em.sectionName = @"研发部";
    
    [[CoreDataManager sharedManager] save];
 
}

- (IBAction)update:(id)sender {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", @"blazer"];
    
    request.predicate = predicate;
    
    NSArray <Employee *> *employees = [[CoreDataManager sharedManager].manageObjectContext executeFetchRequest:request error:nil];
    
    [employees enumerateObjectsUsingBlock:^(Employee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.heigth = 3.0;
    }];
    
    [[CoreDataManager sharedManager] save];
}

- (IBAction)delete:(id)sender {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"blazer"];
    
    request.predicate = predicate;
    
    NSArray <Employee *> *employees = [[CoreDataManager sharedManager].manageObjectContext executeFetchRequest:request error:nil];
    
    [employees enumerateObjectsUsingBlock:^(Employee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[CoreDataManager sharedManager].manageObjectContext deleteObject:obj];
    }];
    
    [[CoreDataManager sharedManager] save];
}

- (IBAction)search:(id)sender {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"height = %lf", 3.0];
//    
//    request.predicate = predicate;
    
    NSArray <Employee *> *employees = [[CoreDataManager sharedManager].manageObjectContext executeFetchRequest:request error:nil];
    
    NSLog(@"%@", employees);
    
    [employees enumerateObjectsUsingBlock:^(Employee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"name:%@-----height:%lf",obj.name, obj.heigth);
    }];
    
}

//创建关联对象
- (IBAction)createMu:(id)sender {
    Department *iosDepartment = [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:[CoreDataManager sharedManager].manageObjectContext];
    iosDepartment.departName = @"iOS";
    iosDepartment.createDate = [NSDate date];

    
    Employee *zsEmployee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:[CoreDataManager sharedManager].manageObjectContext];
    zsEmployee.name = @"zhangsan";
    zsEmployee.heigth = 1.9;
    zsEmployee.brithday = [NSDate date];
    zsEmployee.department = iosDepartment;
    
    Employee *lsEmployee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:[CoreDataManager sharedManager].manageObjectContext];
    lsEmployee.name = @"lisi";
    lsEmployee.heigth = 1.7;
    lsEmployee.brithday = [NSDate date];
    lsEmployee.department = iosDepartment;
    
    Department *androidDepartment = [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:[CoreDataManager sharedManager].manageObjectContext];
    androidDepartment.departName = @"android";
    androidDepartment.createDate = [NSDate date];

    
    Employee *blEmployee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:[CoreDataManager sharedManager].manageObjectContext];
    blEmployee.name = @"blazer";
    blEmployee.heigth = 1.72;
    blEmployee.brithday = [NSDate date];
    blEmployee.department = androidDepartment;
    
    Employee *kkEmployee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:[CoreDataManager sharedManager].manageObjectContext];
    kkEmployee.name = @"kiki";
    kkEmployee.heigth = 1.6;
    kkEmployee.brithday = [NSDate date];
    kkEmployee.department = androidDepartment;
    
    [[CoreDataManager sharedManager] save];
}

//关联表的查询
- (IBAction)muSearch:(id)sender {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"department.departName = %@", @"iOS"];
    
    request.predicate = predicate;
    
    NSArray <Department *> *departments = [[CoreDataManager sharedManager].manageObjectContext executeFetchRequest:request error:nil];
    
    NSLog(@"%@", departments);
    [departments enumerateObjectsUsingBlock:^(Department * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       // NSLog(@"Department Search Result DepartName : %@, employee name : %@", obj.departName, obj.employee);
    }];
    
}


//分页查询

- (void)pageSearch{
    /*
     * 在从本地存储区获取数据时，可以指定从第几个获取，以及本次查询获取多少个数据，联合起来使用就是分页查询，
     * 当然也可以根据需求，单独使用这两个API
     */
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    //设置查找起点，这里是从搜索结果的第六个开始获取
    request.fetchOffset = 6;
    
    //设置分页，每次请求获取六个托管对象
    request.fetchLimit = 6;
    
    //设置排序规则，这里设置身高升高
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:YES];
    request.sortDescriptors = @[descriptor];
    
    //执行查询操作
    NSArray <Employee *> *employees = [[CoreDataManager sharedManager].manageObjectContext executeFetchRequest:request error:nil];
    
    [employees enumerateObjectsUsingBlock:^(Employee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"name:%@-----height:%lf",obj.name, obj.heigth);
    }];

}

//模糊查询
- (void)linkSearch{
    //主要是进行NSPredicate predicate的设置
    
    // 谓词的通配符使用
    
    // 创建模糊查询条件。这里设置的带通配符的查询，查询条件是结果包含lxz
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE %@", @"*lxz*"];
    
    //以lxz开头
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"name BEGINSWITH %@", @"lxz"];
    
    //以lxz结尾
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"name ENDSWITH %@", @"lxz"];
    
    //其中包含lxz
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"name contains %@", @"lxz"];

    //查询条件结果包含Lxz的
    NSPredicate *predicate4 = [NSPredicate predicateWithFormat:@"name LIKE %@", @"*lxz*"];

}

//加载请求模板
//在模型文件中设置请求模板，也就是在.xcdatamodeld文件中，设置Fetch Request 使用时可以通过对应的NSManagerObjectModel获取设置好的模板
- (void)loadRequestModel{
    // 通过MOC获取模型文件对应的托管对象模型
    NSManagedObjectModel *model = [CoreDataManager sharedManager].manageObjectContext.persistentStoreCoordinator.managedObjectModel;
    // 通过.xcdatamodeld文件中设置的模板名，获取请求对象
    NSFetchRequest *fetchRequest = [model fetchRequestTemplateForName:@"EmployeeFR"];
    
    // 请求数据，下面的操作和普通请求一样
    NSError *error = nil;
    NSArray<Employee *> *dataList = [[CoreDataManager sharedManager].manageObjectContext executeFetchRequest:fetchRequest error:&error];
    [dataList enumerateObjectsUsingBlock:^(Employee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    }];
    
    // 错误处理
    if (error) {
        NSLog(@"Execute Fetch Request Error : %@", error);
    }
}

//获取Count值
/*
 * 开发过程中有时需要只获取所需数据的count值，不能像上面查询一样，先得到数组，然后再得到Count, 这样MOC执行操作，对内存消耗是很大的
 *
 * 苹果提供了两种常用的方式获取这个Count值，这两种获取操作，都是在数据库中完成的，并不需要将托管对象加载到内存中，对内存的开销也是很小的
 *
 */

- (void)getCount{
    //方法1 设置resultType

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"height < 2"];

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    fetchRequest.predicate = predicate;
    // 这一步是关键。设置返回结果类型为Count，返回结果为NSNumber类型
    fetchRequest.resultType = NSCountResultType;
    
    // 执行查询操作，返回的结果还是数组，数组中只存在一个对象，就是计算出的Count值
    NSError *error = nil;
    NSArray *dataList = [[CoreDataManager sharedManager].manageObjectContext executeFetchRequest:fetchRequest error:&error];
    NSInteger count = [dataList.firstObject integerValue];
    NSLog(@"fetch request result Employee.count = %ld", count);
    
    // 错误处理
    if (error) {
        NSLog(@"fetch request result error : %@", error);
    }
    
    //方法2 使用MOC提供的方法
    //设置查询条件跟上面一样的
    NSUInteger count1 = [[CoreDataManager sharedManager].manageObjectContext countForFetchRequest:fetchRequest error:&error];
    NSLog(@"fetch request result count is : %ld", count1);

}


//位运算
//假设有需求是对一个表中的，所有托管对象的一个属性值进行求和  比较节省内存的做法就是CoreData提供的位运算
//
// NSExpression 类可以描述多种运算
- (void)bitOperation{

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    // 设置返回值为字典类型，这是为了结果可以通过设置的name名取出，这一步是必须的
    fetchRequest.resultType = NSDictionaryResultType;
    
    // 创建描述对象
    NSExpressionDescription *expressionDes = [[NSExpressionDescription alloc] init];
    // 设置描述对象的name，最后结果需要用这个name当做key来取出结果
    expressionDes.name = @"sumOperatin";
    // 设置返回值类型，根据运算结果设置类型
    expressionDes.expressionResultType = NSFloatAttributeType;
    
    // 创建具体描述对象，用来描述对那个属性进行什么运算(可执行的运算类型很多，这里描述的是对height属性，做sum运算)
    NSExpression *expression = [NSExpression expressionForFunction:@"sum:" arguments:@[[NSExpression expressionForKeyPath:@"height"]]];
    // 只能对应一个具体描述对象
    expressionDes.expression = expression;
    // 给请求对象设置描述对象，这里是一个数组类型，也就是可以设置多个描述对象
    fetchRequest.propertiesToFetch = @[expressionDes];
    
    // 执行请求，返回值还是一个数组，数组中只有一个元素，就是存储计算结果的字典
    NSError *error = nil;
    NSArray *resultArr = [[CoreDataManager sharedManager].manageObjectContext executeFetchRequest:fetchRequest error:&error];
    // 通过上面设置的name值，当做请求结果的key取出计算结果
    NSNumber *number = resultArr.firstObject[@"sumOperatin"];
    NSLog(@"fetch request result is %f", [number floatValue]);

}


/*
 * 批处理   假如需要进行大量的进行数据处理，因为CoreData 都是先把数据加到内存中然后再进行处理，，这样有可能造成应用闪退，
 *
 * 在iOS8 推出了批量删更新API
 *
 * 在iOS9 批量删除API
 * 
 * 关于批处理API很多都是iOS8,iOS9出来的，需要注意版本兼容
 * 
 * 问题：批量更新和批量删除的两个API，都是直接对数据库进行操作，更新完之后会导致MOC缓存和本地持久化数据不同步的问题，所以需要手动刷新受影响的MOC中存储的托管对象
 */

- (void)batchUpdate{
    // 创建批量更新对象
    NSBatchUpdateRequest *updateRequest = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:@"Employee"];
    
    // 设置返回值类型，默认是什么都不返回(NSStatusOnlyResultType)，这里设置返回发生改变的对象Count值
    updateRequest.resultType = NSUpdatedObjectsCountResultType;
   
    // 设置发生改变字段的字典
    updateRequest.propertiesToUpdate = @{@"height" : [NSNumber numberWithFloat:5.f]};
    
    // 执行请求后，返回值是一个特定的result对象，通过result的属性获取返回的结果。MOC的这个API是从iOS8出来的，所以需要注意版本兼容。
    NSError *error = nil;
    NSBatchUpdateResult *result = [[CoreDataManager sharedManager].manageObjectContext executeRequest:updateRequest error:&error];
    NSLog(@"batch update count is %ld", [result.result integerValue]);
    
    // 错误处理
    if (error) {
        NSLog(@"batch update request result error : %@", error);
    }
    
    // 更新MOC中的托管对象，使MOC和本地持久化区数据同步
    [[CoreDataManager sharedManager].manageObjectContext refreshAllObjects];

}

//批量删除

- (void)batchDelete{
    // 创建请求对象
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    // 通过谓词设置过滤条件，设置条件为height小于1.7
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"height < %f", 1.7f];
    fetchRequest.predicate = predicate;
    
    // 创建批量删除请求，并使用上面创建的请求对象当做参数进行初始化
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    // 设置请求结果类型，设置为受影响对象的Count
    deleteRequest.resultType = NSBatchDeleteResultTypeCount;
    
    // 使用NSBatchDeleteResult对象来接受返回结果，通过id类型的属性result获取结果
    NSError *error = nil;
    NSBatchDeleteResult *result = [[CoreDataManager sharedManager].manageObjectContext executeRequest:deleteRequest error:&error];
    
    // 错误处理
    if (error) {
        NSLog(@"batch delete request error : %@", error);
    }
    
    // 更新MOC中的托管对象，使MOC和本地持久化区数据同步
    [[CoreDataManager sharedManager].manageObjectContext refreshAllObjects];

    /*
     * refreshAllObjects是从iOS9出来的，在iOS9之前因为要做版本兼容，所以需要使用refreshObject:mergeChanges
     */
}

//异步请求
- (void)asyncRequest{
    // 创建请求对象，并指明操作Employee表
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    // 创建异步请求对象，并通过一个block进行回调，返回结果是一个NSAsynchronousFetchResult类型参数
    NSAsynchronousFetchRequest *asycFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fetchRequest completionBlock:^(NSAsynchronousFetchResult * _Nonnull result) {
        
        [result.finalResult enumerateObjectsUsingBlock:^(Employee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"fetch request result Employee.count = %ld, Employee.name = %@", result.finalResult.count, obj.name);
        }];
    }];
    
    // 执行异步请求，和批量处理执行同一个请求方法
    NSError *error = nil;
    [[CoreDataManager sharedManager].manageObjectContext executeRequest:asycFetchRequest error:&error];
    
    // 错误处理
    if (error) {
        NSLog(@"fetch request result error : %@", error);
    }
   
    /*
     * 如果多个请求同时发起，不需要担心线程安全的问题，系统会将所有的异步请求添加到一个操作队列中，在前一个任务访关数据库时，CoreData会将数据库加锁
     *
     * NSAsynchronousFetchRequest 提供cancel方法  也就是在请求过程中，将这个请求取消，还可以通过 NSProgress 类型的属性，获取请求完成进度
     */
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    Person *p = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[CoreDataManager sharedManager].manageObjectContext];
//    
//    p.name = @"blazer";
//    p.age = 45;
//    p.grade = NO;
//    
//    [[CoreDataManager sharedManager] save];
}



@end
