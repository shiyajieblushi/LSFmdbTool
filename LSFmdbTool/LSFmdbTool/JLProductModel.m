//
//  JLProductModel.m
//  君来投
//
//  Created by blushi on 16/9/22.
//  Copyright © 2016年 blushi. All rights reserved.
//

#import "JLProductModel.h"

@implementation JLProductModel

- (NSDictionary *)replacedKeyFromPropertyName{
    // ID :为模型中成员变量名  ，id : 返回字典的key值
    return @{@"IDD":@"id"};
}

@end
