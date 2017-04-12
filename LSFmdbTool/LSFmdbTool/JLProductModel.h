//
//  JLProductModel.h
//  君来投
//
//  Created by blushi on 16/9/22.
//  Copyright © 2016年 blushi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLProductModel : NSObject

//@property (nonatomic,assign) BOOL outDate;

/** -----  */
/** 金额 */
@property (nonatomic,copy) NSString *amount;
/** id 标示 */
@property (nonatomic,copy) NSString *IDD; // 无论大写还是小写id在sql语句中都很敏感，所以不能出现
/** 截止日期 */
@property (nonatomic,copy) NSString *endtime;
/** 年利率 */
@property (nonatomic,copy) NSString *interest;
/** 投资金额 */
@property (nonatomic,copy) NSString *investamount;
/** 投资日期 */
@property (nonatomic,copy) NSString *investdate;
/** 借款标示 */
@property (nonatomic,copy) NSString *loanid;
/** 月还本息 */
@property (nonatomic,copy) NSString *monthlyamount;
/** 净收益 */
@property (nonatomic,copy) NSString *netincome;
/** 待还本息 */
@property (nonatomic,copy) NSString *nextamount;
/** 下期还款额 */
@property (nonatomic,copy) NSString *nextrepayamount;
/** 下一还款日 */
@property (nonatomic,copy) NSString *nextrepaydate;
/** 提前还款费率 */
@property (nonatomic,copy) NSString *prepayment;
/** 产品类型 - 君英贷 君车贷 君房贷 君业贷 君学贷 */
@property (nonatomic,copy) NSString *producttype;
/** 投标进度 */
@property (nonatomic,copy) NSString *progress;
/** 已还本息 */
@property (nonatomic,copy) NSString *repayedamount;
/** 还款方式 */
@property (nonatomic,copy) NSString *repaytype;
/** 保障方式 */
@property (nonatomic,copy) NSString *safetype;
/** 投标状态 - 未开始  投标中 满标 还款中 已还款 */
@property (nonatomic,copy) NSString *status;
/** 可投金额 */
@property (nonatomic,copy) NSString *subjectamount;
/** 还款期限 */
@property (nonatomic,copy) NSString *term;
/** 投资标题 */
@property (nonatomic,copy) NSString *title;
/** 标的类型：0-个人,1-企业 */
@property (nonatomic,copy) NSString *type;
/** 借款用途 */
@property (nonatomic,copy) NSString *use;
//@property (nonatomic,assign) int use;

/** 分类,信用标，抵押标，债权转让 */
@property (nonatomic,copy) NSString *loanClassify;

/** borrowid */
@property (nonatomic,copy) NSString * borrowid;

@end
