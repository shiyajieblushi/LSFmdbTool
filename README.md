# LSFmdbTool
对FMDB的二次封装
/**
 * 初始化 工具
 * 并且开启db
 * 参数:将要存放数据库的模型(类名->NSString)
 */
+ (instancetype) fmdbToolWithName:(NSString *)class_name;

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
- (void) fmdbDelete:(JLProductModel *)product identfier:(NSString *)identfier;

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
 * 关闭数据库
 */
- (void) fmdbCloseFmdb;
