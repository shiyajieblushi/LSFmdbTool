//
//  NSObject+LSGetProperty.h
//  02-FMDBQueue
//
//  Created by Yajie Shi on 2017/4/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LSGetProperty)

/**
 * 对象方法
 * 获取所有属性值
 */
- (NSArray *)getPropertyValueList;


/**
 * 类方法
 * 获取所有属性名
 */
+ (NSArray *)getPropertyNameList;

@end
