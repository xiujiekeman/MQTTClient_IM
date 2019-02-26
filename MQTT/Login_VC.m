//
//  Login_VC.m
//  MQTT
//
//  Created by 休杰克曼 on 2019/2/25.
//  Copyright © 2019 休杰克曼. All rights reserved.
//

#import "Login_VC.h"

@interface Login_VC ()
{
    NSArray *_arrData;
}
@end

@implementation Login_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _arrData = @[@"user1",@"user2",@"user3"];
    [self ChooseUser];
    
    // Do any additional setup after loading the view.
}


- (void)ChooseUser
{
    UILabel *labTitle = [[UILabel alloc]init];
    labTitle.text = @"选择用户身份";
    labTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labTitle];
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    
    for (int i = 0; i < _arrData.count; i++) {
        UIButton *btnChatPerson = [UIButton buttonWithType:UIButtonTypeSystem];
        btnChatPerson.backgroundColor = [UIColor orangeColor];
        btnChatPerson.tag = i;
        [btnChatPerson setTitle:_arrData[i] forState:UIControlStateNormal];
        [btnChatPerson setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnChatPerson addTarget:self action:@selector(selectUser:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnChatPerson];
        [btnChatPerson mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(i*50+150);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
    }
}


- (void)selectUser:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    _selectUserLoginB(_arrData[btn.tag]);
}


- (void)selectUserLogin:(selectUserLoginBlock)block
{
    _selectUserLoginB = block;
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
