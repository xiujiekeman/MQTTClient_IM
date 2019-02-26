//
//  Login_VC.h
//  MQTT
//
//  Created by 休杰克曼 on 2019/2/25.
//  Copyright © 2019 休杰克曼. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^selectUserLoginBlock)(NSString *strUserName);

@interface Login_VC : UIViewController

@property (nonatomic,copy)selectUserLoginBlock selectUserLoginB;


- (void)selectUserLogin:(selectUserLoginBlock)block;

@end

NS_ASSUME_NONNULL_END
