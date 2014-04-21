//
//  BPJTestTopViewController.m
//  EasySideBarMenu
//
//  Created by Brad on 1/7/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import "BPJTestTopViewController.h"

@interface BPJTestTopViewController ()

@end

@implementation BPJTestTopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)burgerPressed:(id)sender {
    
    [self.burgerDelegate handleBurgerButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (IBAction)handleMenuButtonPressed:(id)sender {
    
    //
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
