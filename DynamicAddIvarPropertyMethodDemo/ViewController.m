//
//  ViewController.m
//  DynamicAddIvarPropertyMethodDemo
//
//  Created by cheyipai on 2018/6/30.
//  Copyright © 2018年 cheyipai. All rights reserved.
//

#import "ViewController.h"
#import "MyClass.h"
#import <objc/runtime.h>
@interface ViewController ()
@end

@implementation ViewController
void otherMethod(id self,SEL _cmd){
    NSLog(@"新添加的方法");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self dynamicAddIvarPropertyMethod];
    [self test];
}
-(void)dynamicAddIvarPropertyMethod{
    //添加Ivar
    class_addIvar([MyClass class],"newIvar",sizeof(id),log2(sizeof(id)), "@");
    //添加属性
    objc_property_attribute_t type = {"T","@\"NSString\""};
    objc_property_attribute_t ownerShip = {"c",""};
    objc_property_attribute_t attrs[] = {type,ownerShip};
    class_addProperty([MyClass class], "age",attrs, 2);
    //添加方法
    class_addMethod([MyClass class],@selector(otherMethod),(IMP)otherMethod,"v@");
}
//测试相应的添加是否成功
-(void)test{
    //首先调用动态添加的方法
    [[MyClass new] performSelector:NSSelectorFromString(@"otherMethod") withObject:nil];
    unsigned int nums;//用于记录成员变量、属性或方法的个数
    //取成员变量
    Ivar *vars = class_copyIvarList([MyClass class],&nums);
    NSString *ivarkey = @"";
    for (int i = 0;i < nums;i++) {
        Ivar ivar = vars[i];
        ivarkey = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSLog(@"variable name:%@",ivarkey);
    }
    printf("-----------成员变量打印结束---------");
    //取成员属性
    NSString *propertyKey = @"";
    objc_property_t *properties = class_copyPropertyList([MyClass class],&nums);
    for (int i = 0;i < nums;i++) {
        objc_property_t property = properties[i];
        propertyKey = [NSString stringWithUTF8String:property_getName(property)];
        NSLog(@"property name:%@",propertyKey);
    }
    printf("-----------成员属性打印结束--------");
    //取方法
    Method *methods = class_copyMethodList([MyClass class],&nums);
    for (int i = 0;i < nums;i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *methodName = NSStringFromSelector(selector);
        NSLog(@"method name:%@",methodName);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
