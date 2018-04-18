//
//  TypeAnnotation.h
//  LXRouter
//
//  Created by 58 on 2018/4/13.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TypeAnnotation;

//先展开再解释
#define __annotation_macro_concat_inner(A, B) A##B
#define __annotation_macro_concat(a,b) __annotation_macro_concat_inner(a, b)

#define ParamRequired property (nonatomic, weak, readonly) TypeAnnotation *__annotation_macro_concat(paramRequired_,__COUNTER__);

#define DSProtocol(class) property (nonatomic, weak, readonly) TypeAnnotation *__annotation_macro_concat(propertyProtocol_##class##_,__COUNTER__);

//注释宏
#if DEBUG
#define PRComments(comment) property (nonatomic, weak, readonly) TypeAnnotation *__annotation_macro_concat(PRComments_##comment##_,__COUNTER__);

#else
#define PRComments(comment)
#endif

@interface TypeAnnotation : NSObject

@property (nonatomic,assign)BOOL required;
/**存放数组等集合数据中的数据类型*/
@property (nonatomic,retain)Class protocolClass;
/**当前属性的key*/
@property (nonatomic,copy)NSString * keyName;
/**当前属性的类别*/
@property (nonatomic,copy)NSString * typeName;
/**注释*/
@property (nonatomic,copy)NSString * comments;
/**当前层数*/
@property (nonatomic,assign)NSInteger level;
/**父亲key*/
@property (nonatomic,copy)NSString * fatherKey;
/**为了给中间节点加上自己的属性，设置子节点来存放json中的值*/
@property (nonatomic,retain) id child;

-(NSDictionary *)dic;

@end
