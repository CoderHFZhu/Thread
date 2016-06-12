//
//  NSOperationViewController.m
//  Thread
//
//  Created by zack on 16/6/12.
//  Copyright © 2016年 HF. All rights reserved.
//

#import "NSOperationViewController.h"

@interface NSOperationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;
@end

@implementation NSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self downImage];

}

-(void)invocation
{
    
    /*
     第一个参数:目标对象
     第二个参数:选择器,要调用的方法
     第三个参数:方法要传递的参数
     */
    /** 这个线程是在主线程*/
    NSInvocationOperation *op  = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download) object:nil];

    //启动操作
    [op start];
}

-(void)blockOperation
{
    //1.封装操作
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        //在主线程
        NSLog(@"1------%@",[NSThread currentThread]);
        
    }];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        //在主线程
        NSLog(@"2------%@",[NSThread currentThread]);
    }];
    
    //2.追加操作
    //在子线程中执行
    [op1 addExecutionBlock:^{
        NSLog(@"3------%@",[NSThread currentThread]);
    }];
    [op1 addExecutionBlock:^{
        NSLog(@"4------%@",[NSThread currentThread]);
    }];
    
    [op1 addExecutionBlock:^{
        NSLog(@"5------%@",[NSThread currentThread]);
    }];
    
    
    //3.启动操作执行
    [op start];
    [op1 start];
    
}
-(void)download
{
    NSLog(@"---%s---%@",__func__,[NSThread currentThread]);
}


#pragma mark ---NSOperationQueue---------
-(void)invocationQueue
{
    //1.创建队列
    /*
     并发:全局并发队列,自己创建(concurrent)
     串行:主队列,自己创建(serial)
     */
    
    //    NSOperationQueue
    /*
     主队列:凡是放到主队列里面的任务都在主线程执行[NSOperationQueue mainQueue]
     非主队列:alloc int,同时具备了并发和串行的功能,默认是并发队列
     */
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    //2.封装操作
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download1) object:nil];
    
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download2) object:nil];
    
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download3) object:nil];
    
    //3.添加操作到队列
    [queue addOperation:op1];   //[op1 start]
    [queue addOperation:op2];
    [queue addOperation:op3];
}


-(void)blockOperationQueue
{
    //1.创建队列
    /*
     并发:全局并发队列,自己创建(concurrent)
     串行:主队列,自己创建(serial)
     */
    
    //    NSOperationQueue
    /*
     主队列:凡是放到主队列里面的任务都在主线程执行[NSOperationQueue mainQueue]
     非主队列:alloc int,同时具备了并发和串行的功能,默认是并发队列
     */
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    //2.封装操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3----%@",[NSThread currentThread]);
    }];
    
    [op3 addExecutionBlock:^{
        NSLog(@"4----%@",[NSThread currentThread]);
    }];
    
    [op3 addExecutionBlock:^{
        NSLog(@"5----%@",[NSThread currentThread]);
    }];
    
    
    [op3 addExecutionBlock:^{
        NSLog(@"6----%@",[NSThread currentThread]);
    }];
    
    
    //3.添加操作到队列
    [queue addOperation:op1];   //[op1 start]
    [queue addOperation:op2];
    [queue addOperation:op3];
    
    //简便方法
    [queue addOperationWithBlock:^{
        NSLog(@"7----%@",[NSThread currentThread]);
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"8----%@",[NSThread currentThread]);
    }];
    
}


-(void)download1
{
    NSLog(@"download1---%@",[NSThread currentThread]);
}

-(void)download2
{
    NSLog(@"download2---%@",[NSThread currentThread]);
}

-(void)download3
{
    NSLog(@"download3---%@",[NSThread currentThread]);
}


-(void)downImage {
    //1.创建队列
    NSOperationQueue *queue= [[NSOperationQueue alloc]init];
    
    NSBlockOperation *download1 = [NSBlockOperation blockOperationWithBlock:^{
        //2.1.确定要下载网络图片的url地址，一个url唯一对应着网络上的一个资源
        NSURL *url = [NSURL URLWithString:@"http://p6.qhimg.com/t01d2954e2799c461ab.jpg"];
        
        //2.2.根据url地址下载图片数据到本地（二进制数据)
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        //2.3.把下载到本地的二进制数据转换成图片
        self.image1 = [UIImage imageWithData:data];
        
    }];
    
    NSBlockOperation *download2 = [NSBlockOperation blockOperationWithBlock:^{
        //2.1.确定要下载网络图片的url地址，一个url唯一对应着网络上的一个资源
        NSURL *url = [NSURL URLWithString:@"http://p6.qhimg.com/t01d2954e2799c461ab.jpg"];
        
        //2.2.根据url地址下载图片数据到本地（二进制数据)
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        //2.3.把下载到本地的二进制数据转换成图片
        self.image2 = [UIImage imageWithData:data];
        
    }];
    
    NSBlockOperation *combie = [NSBlockOperation blockOperationWithBlock:^{
        
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        
        [self.image1 drawInRect:CGRectMake(0, 0, 200, 100)];
        [self.image2 drawInRect:CGRectMake(0, 100, 200, 100)];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        //刷新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = image;
            NSLog(@"%@----",[NSThread currentThread]);
        }];
        
    }];
    /** 依赖可以同一队列的  也可以不同队列的*/
    [combie addDependency:download1];
    [combie addDependency:download2];
    
    [queue addOperation:download1];
    [queue addOperation:download2];
    [queue addOperation:combie];
}





#pragma mark ------相互依赖--------------
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSOperationQueue *queue1 = [[NSOperationQueue alloc]init];
    //2.封装操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1----%@",[NSThread currentThread]);
        
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2----%@",[NSThread currentThread]);
        
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3----%@",[NSThread currentThread]);
        
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"4----%@",[NSThread currentThread]);
        
    }];
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i=0; i<10000; i++) {
            NSLog(@"5-%zd---%@",i,[NSThread currentThread]);
        }
        
        
    }];
    
    op4.completionBlock = ^{
        NSLog(@"op4已经完成了---%@",[NSThread currentThread]);
    };
    
    //添加操作依赖,注意不能循环依赖
    [op1 addDependency:op5];
    [op1 addDependency:op4];
    
    //添加操作到队列
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue1 addOperation:op5];
}

@end
