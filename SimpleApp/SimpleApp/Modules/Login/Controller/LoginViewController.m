//
//  LoginViewController.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/15.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "LoginViewController.h"
#import <RTRootNavigationController/RTRootNavigationController.h>
#import "MBProgressHUD.h"
#import "LoginViewModel.h"
#import "NSString+isEmpty.h"
#import "LoginManager.h"
#import "Simpletoast.h"
#import "IndexViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) UIImageView *phoneLeftView;

@property (strong, nonatomic) UIImageView *passwordLeftView;

@property (strong, nonatomic) LoginViewModel *loginViewModel;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    
    @weakify(self)
    self.loginViewModel = [[LoginViewModel alloc] init];
    
    [self.loginViewModel.requestLoginCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        } else {
            [self.hud hideAnimated:YES];
        }
        
    }];
    
    [self.loginViewModel.requestLoginCommand.executionSignals subscribeNext:^(RACSignal *execution) {
        [[execution dematerialize] subscribeNext:^(LoginNetRespondBean *respondBean) {
            [[LoginManager sharedInstance] updateLoginUserInfo:respondBean];
            IndexViewController *indexVC = [[IndexViewController alloc] init];
            [self.navigationController pushViewController:indexVC animated:YES];
            
        } error:^(NSError *error) {
            [self.hud hideAnimated:YES];
            [Simpletoast showWithText:error.localizedDescription duration:2.0f];
        }];
        
    }];
    
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if ([NSString isEmpty:self.phoneText.text] || [NSString isEmpty:self.passwordText.text]) {
            return;
        }
        self.loginViewModel.phone = self.phoneText.text;
        self.loginViewModel.password = self.passwordText.text;
        [self.loginViewModel.requestLoginCommand execute:nil];
        
    }];
    
  self.loginViewModel.phone = @"admin";
  self.loginViewModel.password = @"1";
  [self.loginViewModel.requestLoginCommand execute:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.rt_navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)createUI {
    [self.phoneLeftView setFrame:CGRectMake(0, 5, 30, 30)];
    [self.passwordLeftView setFrame:CGRectMake(0, 5, 30, 30)];
    
    self.phoneText.leftViewMode = UITextFieldViewModeAlways;
    self.passwordText.leftViewMode = UITextFieldViewModeAlways;
    
    self.phoneText.leftView = self.phoneLeftView;
    self.passwordText.leftView = self.passwordLeftView;
}


-(UIImageView *)phoneLeftView {
    if (!_phoneLeftView) {
        _phoneLeftView = [UIImageView new];
        _phoneLeftView.contentMode = UIViewContentModeCenter;
        _phoneLeftView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_phoneLeftView setImage:[UIImage imageNamed:@"dengluye-zhanghao"]];
        
    }
    return _phoneLeftView;
}

-(UIImageView *)passwordLeftView {
    if (!_passwordLeftView) {
        _passwordLeftView = [UIImageView new];
        _passwordLeftView.contentMode = UIViewContentModeCenter;
        _passwordLeftView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_passwordLeftView setImage:[UIImage imageNamed:@"dengluye-mima"]];
    }
    return _passwordLeftView;
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
