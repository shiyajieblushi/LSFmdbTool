//
//  NSObject+LSGetProperty.m
//  02-FMDBQueue
//
//  Created by Yajie Shi on 2017/4/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "NSObject+LSGetProperty.h"
#import <objc/runtime.h>

@implementation NSObject (LSGetProperty)
// 获取所有属性名
+ (NSArray *)getPropertyNameList{
    
    u_int count = 0;
    
    objc_property_t *property = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertyNameArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i=0; i<count; i++){
        
        const char* propertyName = property_getName(property[i]);
        
        [propertyNameArray addObject: [NSString stringWithUTF8String:propertyName]];
    }    
    free(property); // 释放
    
    return propertyNameArray;
    
}
// 获取所有属性值
- (NSArray *)getPropertyValueList{
    u_int count = 0;
   
    // 获取类名
    NSString *ssss = [NSString stringWithUTF8String:object_getClassName(self)];
    Class ccc = NSClassFromString(ssss);
    
    objc_property_t *property = class_copyPropertyList([ccc class], &count);
    NSMutableArray *propertyValueArray = [NSMutableArray arrayWithCapacity:count];
    for (int i=0; i<count; i++){
        const char* char_f =property_getName(property[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) {
            [propertyValueArray addObject:propertyValue];
        }
        else{
            [propertyValueArray addObject:[NSNull null]];
        }
    }
    free(property);
    return propertyValueArray;
}
//获取所有对象方法
-(void)printAllMethods{
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList([self class],&mothCout_f);
    for(int i=0;i<mothCout_f;i++){
        Method temp_f = mothList_f[i];
        const char* name_s =sel_getName(method_getName(temp_f));
        int arguments = method_getNumberOfArguments(temp_f);
        const char* encoding =method_getTypeEncoding(temp_f);
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,[NSString stringWithUTF8String:encoding]);
    }
    free(mothList_f);
}

@end
