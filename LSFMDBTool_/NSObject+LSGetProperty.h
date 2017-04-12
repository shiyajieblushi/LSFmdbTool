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
 * 获取所有属性值
 */
- (NSArray *)getPropertyValueList:(Class)class_name;


/**
 * 获取所有属性名
 */
+ (NSArray *)getPropertyNameList:(Class)class_name;

@end
