//
//  GCDViewController.m
//  Thread
//
//  Created by zack on 16/6/12.
//  Copyright © 2016年 HF. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage  *image1; /**< 图片1 */
@property (nonatomic, strong) UIImage  *image2; /**< 图片2 */
@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self group2];
    
}
#pragma mark --- 执行方式，执行队列------

//同步函数+主队列:死锁
/** 这种方式会造成程序死锁执行完第一个nslog后就不能向下执行了*/
-(void)syncMain
{
    NSLog(@"----");
    //1.获得主队列
    dispatch_queue_t queue =  dispatch_get_main_queue();
    
    //2.同步函数
    dispatch_sync(queue, ^{
        NSLog(@"---download1---%@",[NSThread currentThread]);
    });
    NSLog(@"----");

}


//异步函数+主队列:不会开线程,任务串行执行
-(void)asyncMain
{
    //1.获得主队列
    dispatch_queue_t queue =  dispatch_get_main_queue();
    
    //2.异步函数
    dispatch_async(queue, ^{
        NSLog(@"---download1---%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"---download2---%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"---download3---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"---download4---%@",[NSThread currentThread]);
    });
    
}

//同步函数+串行队列:不会开线程,任务串行执行
/** 后面的任务会在前面的任务执行完毕之后执行*/
-(void)syncSerial
{
    
    //创建串行队列
    /*
     第一个参数:C语言字符串,标签
     第二个参数:
     DISPATCH_QUEUE_CONCURRENT:并发队列
     DISPATCH_QUEUE_SERIAL:串行队列
     */
    dispatch_queue_t queue =  dispatch_queue_create("com.thread", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        NSLog(@"---download1---%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"---download2---%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"---download3---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"---download4---%@",[NSThread currentThread]);
    });
    NSLog(@"---syncSerial---%@",[NSThread currentThread]);

}
//同步函数+并发队列:不会开线程,任务串行执行
-(void)syncConcurrent
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    /** 官方给我们提供了全局的并发队列，不过你也可以自己创建一个*/
//    dispatch_queue_t queue = dispatch_queue_create("com.thread", DISPATCH_QUEUE_CONCURRENT);

    NSLog(@"--syncConcurrent--start-");
    
    dispatch_sync(queue, ^{
        NSLog(@"---download1---%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"---download2---%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"---download3---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"---download4---%@",[NSThread currentThread]);
    });
    
    NSLog(@"--syncConcurrent--end-");
}
//异步函数+串行队列:会开启一条线程,任务串行执行
-(void)asyncSerial
{
    //创建串行队列
    /*
     第一个参数:C语言字符串,标签
     第二个参数:
     DISPATCH_QUEUE_CONCURRENT:并发队列
     DISPATCH_QUEUE_SERIAL:串行队列
     */
    dispatch_queue_t queue =  dispatch_queue_create("com.thread", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        NSLog(@"---download1---%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"---download2---%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"---download3---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"---download4---%@",[NSThread currentThread]);
    });
    NSLog(@"--asyncSerial--end-");

}
//异步函数+并发队列:会开启新的线程,并发执行
-(void)asyncCONCURRENT
{
    //创建并发队列
    /*
     第一个参数:C语言字符串,标签
     第二个参数:
     DISPATCH_QUEUE_CONCURRENT:并发队列
     DISPATCH_QUEUE_SERIAL:串行队列
     */
    //    dispatch_queue_t queue =  dispatch_queue_create("com.thread", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"--asyncCONCURRENT--start-");
    //获得全局并发队列
    /*
     第一个参数:队列的优先级DISPATCH_QUEUE_PRIORITY_DEFAULT
     第二个参数:永远传0
     */
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //异步函数
    /*
     第一个参数:队列
     第二个参数:block,在里面封装任务
     */
    dispatch_async(queue, ^{
        NSLog(@"---download1---%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"---download2---%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"---download3---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"---download4---%@",[NSThread currentThread]);
    });
    
    NSLog(@"--asyncCONCURRENT--end-");
}
#pragma mark ------------- 线程切换 -------------

-(void)dowmImage
{
    
    //1.开子线程下载图片
    //创建队列(并发)
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    //异步函数
    dispatch_async(queue, ^{
        
        //1.获取url地址
        NSURL *url = [NSURL URLWithString:@"http://image.tianjimedia.com/uploadImages/2015/129/56/J63MI042Z4P8.jpg"];
        
        //2.下载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        //3.把二进制数据转换成图片
        UIImage *image = [UIImage imageWithData:data];
        
        NSLog(@"----%@",[NSThread currentThread]);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            NSLog(@"+++%@",[NSThread currentThread]);
        });
    });
}
#pragma mark ------ GCD group 任务依赖 ----------------
-(void)group
{
    //下载图片1
    
    //创建队列组
    dispatch_group_t group =  dispatch_group_create();
    
    //1.开子线程下载图片
    //创建队列(并发)
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, queue, ^{
        //1.获取url地址
        NSURL *url = [NSURL URLWithString:@"http://image.tianjimedia.com/uploadImages/2015/129/56/J63MI042Z4P8.jpg"];
        
        //2.下载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        //3.把二进制数据转换成图片
        self.image1 = [UIImage imageWithData:data];
        
        NSLog(@"1---%@",self.image1);
    });
    
    //下载图片2
    dispatch_group_async(group, queue, ^{
        //1.获取url地址
        NSURL *url = [NSURL URLWithString:@"http://img1.3lian.com/img2011/w12/1202/19/d/88.jpg"];
        
        //2.下载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        //3.把二进制数据转换成图片
        self.image2 = [UIImage imageWithData:data];
        NSLog(@"2---%@",self.image2);
        
    });
    
    //合成
    dispatch_group_notify(group, queue, ^{
        
        //开启图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        
        //画1
        [self.image1 drawInRect:CGRectMake(0, 0, 200, 100)];
        
        //画2
        [self.image2 drawInRect:CGRectMake(0, 100, 200, 100)];
        
        //根据图形上下文拿到图片
        UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
        
        //关闭上下文
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            NSLog(@"%@--刷新UI",[NSThread currentThread]);
        });
    });
}
-(void)group2
{
    //下载图片1
    
    //创建队列组
    dispatch_group_t group =  dispatch_group_create();
    
    //1.开子线程下载图片
    //创建队列(并发)
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_enter(group);

    dispatch_group_async(group, queue, ^{
        //1.获取url地址
        NSURL *url = [NSURL URLWithString:@"http://image.tianjimedia.com/uploadImages/2015/129/56/J63MI042Z4P8.jpg"];
        
        //2.下载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        //3.把二进制数据转换成图片
        self.image1 = [UIImage imageWithData:data];
        
        NSLog(@"1---%@",self.image1);
        dispatch_group_leave(group);

    });
    dispatch_group_enter(group);
    //下载图片2
    dispatch_group_async(group, queue, ^{
        //1.获取url地址
        NSURL *url = [NSURL URLWithString:@"http://img1.3lian.com/img2011/w12/1202/19/d/88.jpg"];
        
        //2.下载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        //3.把二进制数据转换成图片
        self.image2 = [UIImage imageWithData:data];
        NSLog(@"2---%@",self.image2);
        dispatch_group_leave(group);

    });
    
    //合成
    dispatch_group_notify(group, queue, ^{
        
        //开启图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        
        //画1
        [self.image1 drawInRect:CGRectMake(0, 0, 200, 100)];
        
        //画2
        [self.image2 drawInRect:CGRectMake(0, 100, 200, 100)];
        
        //根据图形上下文拿到图片
        UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
        
        //关闭上下文
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            NSLog(@"%@--刷新UI",[NSThread currentThread]);
        });
    });
}

@end
