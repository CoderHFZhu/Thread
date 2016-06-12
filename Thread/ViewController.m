//
//  ViewController.m
//  Thread
//
//  Created by zack on 16/6/12.
//  Copyright © 2016年 HF. All rights reserved.
//

#import "ViewController.h"
static NSString * const kCellID = @"kCellID";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray<NSString *> *threadNames;
@property (nonatomic ,strong) NSString *titleStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
      self.threadNames = @[@"pthread", @"NSThread", @"GCD", @"NSOperation"];
}
#pragma mark - TableView DataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.threadNames? self.threadNames.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    cell.textLabel.text = self.threadNames[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Finish Click Action
    self.titleStr = self.threadNames[indexPath.row];
    [self performSegueWithIdentifier:self.threadNames[indexPath.row] sender:nil];
    
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue destinationViewController].title = self.titleStr;
}

@end
