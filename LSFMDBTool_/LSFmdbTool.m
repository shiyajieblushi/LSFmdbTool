//
//  LSFmdbTool.m
//  02-FMDBQueue
//
//  Created by Yajie Shi on 2017/4/11.
//  Copyright © 2017年 itcast. All rights reserved.
//
/*
 对数据库中存储的每一个值都有一个类型
 1. NULL 这个值为空值
 2. INTEGER 值被标识为整数，依据值的大小可以依次被存储1～8个字节
 3. REAL 所有值都是浮动的数值
 4. TEXT 值为文本字符串
 5. BLOB 值为blob数据 - 二进制大文件
 */

#import "LSFmdbTool.h"
#import "FMDB.h"
#import <objc/runtime.h>
#import "JLProductModel.h"
#import "NSObject+LSGetProperty.h"


@interface LSFmdbTool()

@property (nonatomic, strong) FMDatabaseQueue *queue;
/** 表名 */
@property (nonatomic,copy) NSString *table_name;
/** 数据库地址 */
@property (nonatomic,copy) NSString *table_Path;

@end

@implementation LSFmdbTool

// 更新某一个模型
- (void) fmdbUpdateModel:(JLProductModel *)product
{
    [self.queue inDatabase:^(FMDatabase *db) {
        // 开启事务
        //        [db executeUpdate:@"begin transaction;"];
        //        [db beginTransaction];
        
        
        NSString *sqlStr = [NSString stringWithFormat:@"update t_%@ set use = %@ where borrowid = %@",_table_name,@"修改的东西",product.borrowid];

            [db executeUpdate:sqlStr];
        
        
        //        if (发现情况不对){
        //            // 回滚事务
        //            [db rollback];
        ////            [db executeUpdate:@"rollback transaction;"];
        //        }
        
        
//        [db executeUpdate:@"update t_homeCell set age = ? where name = ?;", @20, @"jack"];
        
        // 提交事务
        //        [db commit];
        //        [db executeUpdate:@"commit transaction;"];
    }];
}
// 更新整个数据库
- (void) fmdbUpdate:(NSArray *)dataArr
{
    // 删除整个数据库
    [self fmdbDeleteAllDataWithBlock:^{
        // 插入数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{// 两个操作太紧密，造成又删又插入，所以崩溃
            [self fmdbInsert:dataArr];

        });
    }];
}


// 插入
- (void) fmdbInsert:(NSArray *)dataArr
{
    NSLog(@"插入数据");
    [self.queue inDatabase:^(FMDatabase *db) {

        Class class = NSClassFromString(_table_name); // 获取类
        
        // 获取属性
        NSArray *propertyList = [class getPropertyNameList];

        for (JLProductModel *product in dataArr) {
            
            NSMutableString *mtbStr = [NSMutableString string]; // 拼接sql语句中的属性列表
            NSMutableString *wenhaoStr = [NSMutableString string]; // 拼接问号
            
            // 获取属性值
            NSArray *valuesList = [product getPropertyValueList];
            
            for (int i = 0; i < propertyList.count; i ++) {
                NSString *str = propertyList[i]; // key
                if(i == propertyList.count - 1){
                    [mtbStr appendString:[NSString stringWithFormat:@"%@",str]];
                    [wenhaoStr appendString:@"?"];
                }else{
                    [mtbStr appendString:[NSString stringWithFormat:@"%@,",str]];
                    [wenhaoStr appendString:[NSString stringWithFormat:@"?,"]];
                }
            }
            NSString *mtbSql = [NSString stringWithFormat:@"insert into t_%@ (%@) values (%@);",_table_name,mtbStr,wenhaoStr];


//            NSString *sqlStr = [NSString stringWithFormat:@"insert into t_%@ (use , producttype , interest , term , title , repaytype , progress , status ,borrowid) values (?, ?, ?, ?, ?, ?, ?, ?, ?);",_table_name];
            
//            [db executeUpdate:mtbSql,xx,xx,xx];
            
            [db executeUpdate:mtbSql withArgumentsInArray:valuesList]; // 拼接sql,后面跟值的数组
        }
    }];
}


// 删除特定某一标示数据
- (void) fmdbDelete:(JLProductModel *)product identfier:(NSString *)identfier{
    
    NSString *value = @"";
    Class class = NSClassFromString(_table_name); // 获取类

    NSArray *proList = [class getPropertyNameList]; // 取出key
    
    for (NSString *str in proList) {
        if([str isEqualToString:identfier]){
            SEL selector = NSSelectorFromString(str);
            value = [product performSelector:selector]; // 调用getter方法，获取值
        }
    }
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"delete from t_%@ where %@ = %@;",_table_name,identfier,value];

//        [db executeUpdate:@"update t_homeCell set age = ? where name = ?;", @20, @"jack"];
        
        [db executeUpdate:sqlStr];

//        [db executeUpdate:@"update t_homeCell set use = ? where name = ?;", @20, @"jack"];
        //        if (发现情况不对){
        //            // 回滚事务
        //            *rollback = YES;
        //        }
    }];
}
// 删除所有数据
- (void) fmdbDeleteAllDataWithBlock:(deleteDataBlock)deleteDataBlock{
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM t_%@",_table_name];
        [db executeUpdate:sqlStr];
        deleteDataBlock();// 完成通知

    }];

//    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        NSString *sqlStr = [NSString stringWithFormat:@"delete from t_%@ where use = %@;",_table_name,@"20"];
//        [db executeUpdate:sqlStr];
//
//        //        [db executeUpdate:@"update t_homeCell set use = ? where name = ?;", @20, @"jack"];
//        //        if (发现情况不对){
//        //            // 回滚事务
//        //            *rollback = YES;
//        //        }
//    }];
}

// 查询
- (void) fmdbQueryWithBlock:(queryBlock)queryBlock
{
    NSLog(@"点击了查询");

    [self.queue inDatabase:^(FMDatabase *db) {
        // 1.查询数据
        NSString *sqlStr = [NSString stringWithFormat:@"select * from t_%@",_table_name];
        FMResultSet *rs = [db executeQuery:sqlStr];
        NSMutableArray *mtb = [NSMutableArray array];
        
        // 1.1 获取参数列表
        Class class = NSClassFromString(_table_name);
        NSArray *propertyList = [class getPropertyNameList]; // key
        
        // 2.遍历结果集
        while (rs.next) {
            //            int ID = [rs intForColumn:@"id"]; // 获取表中的id
            
            JLProductModel *product = [[JLProductModel alloc] init];
            //            Class product = [[class alloc] init];
            
            for (NSString *proper in propertyList) {
                
                BOOL letter = [self isCatipalLetter:proper];// 判断是否是大写
                NSString *daxieStr = @"";// 首字母转换大写
                if(letter){//是
                    daxieStr = proper;
                }else{
                    daxieStr = [self replaceFirstChar:proper];
                }
                NSString *seletorStr = [NSString stringWithFormat:@"set%@:",daxieStr];// 拼写setter方法
                SEL seletor = NSSelectorFromString(seletorStr);// 转方法
                id value = [rs stringForColumn:proper]; // 获取值
                if(value == NULL){
                    value = [NSNull null];
                }else{
                    if([product respondsToSelector:seletor]){ // 判断是否相应某个方法
                        [product performSelector:seletor withObject:value]; // 执行setter方法
                    }
                }
            }
            
            [mtb addObject:product];
            //            LSLog(@"%d %@", ID, product.borrowid);
        }
        queryBlock(mtb);
    }];

}
// 判断首字母是不是大写
- (BOOL)isCatipalLetter:(NSString *)str{
    
    if ([str characterAtIndex:0] >= 'A' && [str characterAtIndex:0] <= 'Z') {
        
        return YES;
    }
    return NO;
}

// 转换首字母为大写
- (NSString *)replaceFirstChar:(NSString *)str{
    
    char  temp=[str characterAtIndex:0]-32;
    NSRange range=NSMakeRange(0, 1);
    NSString *replaceStr = [NSString stringWithFormat:@"%c",temp];
    str=[str stringByReplacingCharactersInRange:range withString:replaceStr];
    return str;
}
// 关闭
- (void)fmdbCloseFmdb{

    [self.queue inDatabase:^(FMDatabase *db) {
       
        [db close];
    }];
}
// 打开
- (void) fmdbOpenFmdb{

    [self.queue inDatabase:^(FMDatabase *db) {
        [db open];
    }];
}

// 创建表
//- (void)fmdbCreatTable:(NSString *)table_name{
//    
//    _table_name = table_name;
//    
//    // 0.获得沙盒中的数据库文件名
//    NSString *tabel_name = [NSString stringWithFormat:@"%@.sqlite",table_name];
//    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:tabel_name];
//    _table_Path = filename;
//    NSLog(@"%@",filename);
//    // 1.创建数据库队列
//    self.queue = [FMDatabaseQueue databaseQueueWithPath:filename];
//    
//    // 2.创表
//    [self.queue inDatabase:^(FMDatabase *db) {
//        NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists t_%@ (id integer primary key autoincrement, use text, producttype text, interest text, term text, title text, repaytype text, progress text, status text,borrowid text);",table_name];
//        BOOL result = [db executeUpdate:sqlStr];
//        
//        if (result) {
//            NSLog(@"创表成功");
//        } else {
//            NSLog(@"创表失败");
//        }
//    }];
//}

// 删除数据库 - 用户更新的时候先删除
- (void)fmdbDeleteDatabse
{
    BOOL success;
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // delete the old db.
    if ([fileManager fileExistsAtPath:_table_Path])
    {
        success = [fileManager removeItemAtPath:_table_Path error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to delete old database file with message '%@'.", [error localizedDescription]);
        }
    }
}
- (instancetype)initWithTableName:(NSString *)class_name{
    if(self = [super init]){
    
        Class class = NSClassFromString(class_name); // 获取类
        
        _table_name = class_name;
        
        // 获取参数列表
        NSArray *propertyList = [class getPropertyNameList];

        NSMutableString *mtbStr = [NSMutableString string]; // 拼接sql语句中的属性列表
        for (NSString *str in propertyList) {
            
            [mtbStr appendString:[NSString stringWithFormat:@",%@ text",str]];
        }
      
        
        NSLog(@"%@",mtbStr);
        // 0.获得沙盒中的数据库文件名
        NSString *tabel_name = [NSString stringWithFormat:@"%@.sqlite",_table_name];
        NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:tabel_name];
        _table_Path = filename;
        NSLog(@"%@",filename);
        // 1.创建数据库队列
        self.queue = [FMDatabaseQueue databaseQueueWithPath:filename];
        
        // 2.创表
        [self.queue inDatabase:^(FMDatabase *db) {
            NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists t_%@ (id integer primary key autoincrement%@);",_table_name,mtbStr];
            BOOL result = [db executeUpdate:sqlStr];
            
            if (result) {
                NSLog(@"创表成功");
            } else {
                NSLog(@"创表失败");
            }
        }];
    }
    return self;
}


+ (instancetype) fmdbToolWithName:(NSString *)class_name{

    return [[self alloc] initWithTableName:class_name];
}

@end
