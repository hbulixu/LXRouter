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

@interface TypeAnnotation : NSObject

@property (nonatomic,assign)BOOL required;
/**存放数组等集合数据中的数据类型*/
@property (nonatomic,retain)Class protocolClass;

@property (nonatomic,copy)NSString * keyName;

-(NSDictionary *)dic;

@end
