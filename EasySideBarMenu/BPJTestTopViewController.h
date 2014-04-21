//
//  BPJTestTopViewController.h
//  EasySideBarMenu
//
//  Created by Brad on 1/7/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPJMainMenuViewController.h"
#import "BPJMenuBurgerHandler.h"

@interface BPJTestTopViewController : UIViewController

@property (nonatomic,assign) id <BPJMenuBurgerHandler> burgerDelegate;

@end
