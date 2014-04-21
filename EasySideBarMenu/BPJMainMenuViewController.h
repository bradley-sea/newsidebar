//
//  BPJMainMenuViewController.h
//  EasySideBarMenu
//
//  Created by Brad on 1/6/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPJMenuBurgerHandler.h"

@interface BPJMainMenuViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource,UITableViewDelegate,BPJMenuBurgerHandler>

@end
