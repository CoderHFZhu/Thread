//
//  NSThreadViewController.m
//  Thread
//
//  Created by zack on 16/6/12.
//  Copyright © 2016年 HF. All rights reserved.
//

#import "NSThreadViewController.h"

@interface NSThreadViewController ()
//售票员01
@property (nonatomic, strong) NSThread *thread01;
//售票员02
@property (nonatomic, strong) NSThread *thread02;
//售票员03
@property (nonatomic, strong) NSThread *thread03;

//总票数
@property(nonatomic, assign) NSInteger totalticket;
@end

@implementation NSThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createThread1];
    
    /** 线程安全*/
    //假设有100张票
    self.totalticket = 100;
    //    self.obj = [[NSObject alloc]init];
    //创建线程
    self.thread01 =  [[NSThread alloc]initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread01.name = @"售票员01";
    
    self.thread02 =  [[NSThread alloc]initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread02.name = @"售票员02";
    self.thread03 =  [[NSThread alloc]initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread03.name = @"售票员03";
    
}

/*
 第三种创建线程的方式
 特点:默认开启线程
 */
-(void)createThread3
{
    
    [self performSelectorInBackground:@selector(run:) withObject:@"我是子线程"];
}

/*
 第二种创建线程的方式
 特点:默认开启线程
 */
-(void)createThread2
{
    /*
     第一个参数:选择器,调用哪个方法
     第二个参数:目标对象
     第三个参数:前面方法需要传递的参数
     */
    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"我是子线程"];
    
}
/*
 第一种创建线程的方式
 特点:需要调用start方法开启线程
 */
-(void)createThread1
{
    //创建线程
    /*
     第一个参数:目标对象
     第二个参数:选择器,调用哪个方法
     第三个参数:前面方法需要传递的参数
     */
    NSThread *thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(run:) object:@"我是子线程"];
    //设置基本属性
    thread1.name = @"线程1";
    
    //线程优先级
    [thread1 setThreadPriority:1.0];
    
    //开启线程
    [thread1 start];
    
    NSThread *thread2 = [[NSThread alloc]initWithTarget:self selector:@selector(run:) object:@"我是子线程"];
    thread2.name = @"线程2";
    [thread2 setThreadPriority:0.1];
    //开启线程
    [thread2 start];
    
 
}
-(void)run:(NSString *)str
{
    for (NSInteger i = 0; i<1000; i++) {
            NSLog(@"-%zd--run---%@--%@",i,[NSThread currentThread],str);
    }
}

#pragma mark ------- 线程安全（互斥锁）---------
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //启动线程
    [self.thread01 start];
    [self.thread02 start];
    [self.thread03 start];
}

//售票
-(void)saleTicket
{
    while (1) {
        
        //2.加互斥锁
        @synchronized(self) {
            [NSThread sleepForTimeInterval:0.03];
            //1.先查看余票数量
            NSInteger count = self.totalticket;
            
            if (count >0) {
                self.totalticket = count - 1;
                NSLog(@"%@卖出去了一张票,还剩下%zd张票",[NSThread currentThread].name,self.totalticket);
            }else
            {
                NSLog(@"%@发现当前票已经买完了--",[NSThread currentThread].name);
                break;
            }
        }
        
    }
}



@end
