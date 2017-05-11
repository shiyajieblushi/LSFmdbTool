//
//  LSFmdbTool.h
//  02-FMDBQueue
//
//  Created by Yajie Shi on 2017/4/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^queryBlock)(NSArray * dataArr); // 查询整个数据库，返回所有数据
typedef void(^deleteDataBlock)(); // 删除整个数据库数据

@class JLProductModel;
@interface LSFmdbTool : NSObject


/**
 * 初始化 工具
 * 并且开启db
 * 参数:将要存放数据库的模型(类名->NSString)
 */
+ (instancetype) fmdbToolWithName:(NSString *)class_name;


/**
 * 创建表 - 顺便开启了 _db
 * 表名
 */
//- (void) fmdbCreatTable:(NSString *)table_name;

/**
 * 插入
 */
- (void) fmdbInsert:(NSArray *)dataArr;

/**
 * 更新所有数据
 */
- (void) fmdbUpdate:(NSArray *)dataArr;

/**
 * 删除指定数据
 * 需要唯一标示(对象的某一个属性)
 */
- (void) fmdbDelete:(id)product identfier:(NSString *)identfier;

/**
 * 删除数据库
 */
- (void)fmdbDeleteDatabse;

/**
 * 查询
 */
- (void) fmdbQueryWithBlock:(queryBlock)queryBlock;


/**
 * 删除所有数据
 */
- (void) fmdbDeleteAllDataWithBlock:(deleteDataBlock)deleteDataBlock;

/**
 * 打开数据库
 */
- (void) fmdbOpenFmdb;

/**
 * 关闭数据库
 */
- (void) fmdbCloseFmdb;

@end
