//
//  ViewController.m
//  LSFmdbTool
//
//  Created by Yajie Shi on 2017/4/12.
//  Copyright © 2017年 Yajie Shi. All rights reserved.
//

#import "ViewController.h"
#import "LSFmdbTool.h"
#import "JLProductModel.h"

@interface ViewController ()
@property(nonatomic, strong) NSArray *dataArr;
@property(nonatomic, strong) LSFmdbTool *fmdbTool;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JLProductModel *product = [[JLProductModel alloc] init];
    product.use = @"19" ; product.producttype = @"21" ;
    product.interest = @"d" ;
    product.term  = @"sad" ;
    product.title  = @"asd" ;
    product.repaytype = @"sad" ;
    product.progress  = @"ads" ;
    product.status = @"sd" ;
    product.borrowid = @"12345";
    
    JLProductModel *product2 = [[JLProductModel alloc] init];
    product2.use = @"20" ; product.producttype = @"你妹" ;
    product2.interest = @"妹" ;
    product2.term  = @"妹" ;
    product2.title  = @"妹" ;
    product2.repaytype = @"妹" ;
    product2.progress  = @"妹" ;
    product2.status = @"cjk" ;
    product2.borrowid = @"000000";
    
    _dataArr = @[product,product2];
    
    
    self.fmdbTool = [LSFmdbTool fmdbToolWithName:NSStringFromClass([JLProductModel class])];
}

// 插入数据
- (IBAction)insert:(id)sender {
    
    [self.fmdbTool fmdbInsert:_dataArr];
}

// 更新所有数据
- (IBAction)updateAllData:(id)sender {
    
    [self.fmdbTool fmdbUpdate:_dataArr];
}

// 查询数据
- (IBAction)query:(id)sender {
    
    [self.fmdbTool fmdbQueryWithBlock:^(NSArray *dataArr) {
        NSLog(@"%@",dataArr);
    }];
}
// 删除
- (IBAction)deleteData:(id)sender {
    
    // 删除标识为product.borrowid的模型
    JLProductModel *product = _dataArr[0];
    [self.fmdbTool fmdbDelete:product identfier:@"borrowid"];
}

// 删除所有数据
- (IBAction)deleteAllData:(id)sender {
    [self.fmdbTool fmdbDeleteAllDataWithBlock:^{
        NSLog(@"删除完成");
    }];
}
// 删除数据库
- (IBAction)deleteSqlit:(id)sender {
    [self.fmdbTool fmdbDeleteDatabse];
}
// 关闭数据库
- (IBAction)closeSq:(id)sender {
    
    [self.fmdbTool fmdbCloseFmdb];
}


@end
