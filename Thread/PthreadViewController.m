//
//  PthreadViewController.m
//  Thread
//
//  Created by zack on 16/6/12.
//  Copyright © 2016年 HF. All rights reserved.
//

#import "PthreadViewController.h"
#import <pthread.h>


@interface PthreadViewController ()

@end

@implementation PthreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建线程
    pthread_t thread;
    /*
     第一个参数:线程对象
     第二个参数:线程属性
     第三个参数:void *(*)(void *) 指向函数的指针
     第四个参数:函数的参数
     */
    /** 这种方式 创造的线程是子线程*/
    pthread_create(&thread, NULL, run, NULL);
    
}
//void *(*)(void *)
void *run(void *param)
{
    //    NSLog(@"---%@-",[NSThread currentThread]);
    for (NSInteger i =0 ; i<10000; i++) {
        NSLog(@"%zd--%@-",i,[NSThread currentThread]);
    }
    return NULL;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
