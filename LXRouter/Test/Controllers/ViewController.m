//
//  ViewController.m
//  LXRouter
//
//  Created by 58 on 2018/1/15.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "ViewController.h"
#import "LXRouterTools.h"
#import "JSTestWebViewController.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface ViewController ()<MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UITableView * tableView;
@property (nonatomic,retain)NSArray * dataSource;
@property (nonatomic,retain) UIActivityIndicatorView * activeIndicator ;
@property (nonatomic,retain)UIView * darkLoadView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self showdarkLoadView];
    [LXRouterTools genJavaScriptBridge];
    [LXRouterTools genjsValidateHtml];
    [self hidedarkLoadView];
}

#pragma mark - UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * title = self.dataSource[indexPath.row];
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    cell.textLabel.text = title;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            [self showdarkLoadView];
            [LXRouterTools genJavaScriptBridge];
            [LXRouterTools genjsValidateHtml];
            [self hidedarkLoadView];
        }
            break;
        case 1:
        {
            JSTestWebViewController * webVC = [JSTestWebViewController new];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 2:
        {
            [self sendMailInApp];
        }
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sendMailInApp
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
        return;
    }
    if (![mailClass canSendMail]) {
        [self alertWithMessage:@"用户没有设置邮件账户"];

        return;
    }
    [self displayMailPicker];
}

- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"LXRouter JSbridge"];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString * filePath = [NSString stringWithFormat:@"%@/sjt_appBridge.js",docDir];
    NSString * releaseFilePath =[NSString stringWithFormat:@"%@/sjt_appBridge_release.js",docDir];
    
    NSString * htmlPath = [NSString stringWithFormat:@"%@/sjt_JSTestRun.html",docDir];
    NSData *jsTest = [NSData dataWithContentsOfFile:htmlPath];
    [mailPicker addAttachmentData: jsTest mimeType: @"" fileName: @"sjt_JSTestRun.html"];
    
    NSData *js = [NSData dataWithContentsOfFile:filePath];
    [mailPicker addAttachmentData: js mimeType: @"" fileName: @"sjt_appBridge.js"];
    
    NSData *releaseJs = [NSData dataWithContentsOfFile:releaseFilePath];
    [mailPicker addAttachmentData: releaseJs mimeType: @"" fileName: @"sjt_appBridge_release.js"];
    
    NSString *emailBody = @"<font color='red'>详看附件</font> sjt_appBridge.js是bridge文件，sjt_JSTestRun.html是js测试文件";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailPicker animated:YES completion:nil];

}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"发送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    
    [self alertWithMessage:msg];

}

-(NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@"脚本生成",@"脚本校验",@"脚本发送"];
    }
    return _dataSource;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

-(void)alertWithMessage:(NSString *)message
{
    UIAlertController* alertController =   [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Action");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)showdarkLoadView
{
    [self.darkLoadView addSubview:self.activeIndicator];
    self.activeIndicator.center = self.darkLoadView.center;
    [self.activeIndicator startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:self.darkLoadView];
    
}

-(void)hidedarkLoadView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self.darkLoadView removeFromSuperview];
    });
 
}

-(UIActivityIndicatorView *)activeIndicator
{
    if (!_activeIndicator) {
        
        _activeIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activeIndicator.hidden = NO;
        _activeIndicator.hidesWhenStopped = NO;
    }
    return _activeIndicator;
}

-(UIView *)darkLoadView
{
    if (!_darkLoadView) {
        _darkLoadView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _darkLoadView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
    }
    return _darkLoadView;
}
@end
