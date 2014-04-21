//
//  BPJMainMenuViewController.m
//  EasySideBarMenu
//
//  Created by Brad on 1/6/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import "BPJMainMenuViewController.h"
#import "BPJTestTopViewController.h"

@interface BPJMainMenuViewController ()

@property (nonatomic) BOOL menuIsOpen;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;

@property (strong,nonatomic) UIViewController *topViewController;
@property (strong,nonatomic) NSArray *viewControllersForMenu;

@property (strong,nonatomic) UITapGestureRecognizer *topVCTapRecognizer;
@property BOOL topVCIsOnRight;

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation BPJMainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViewControllers];
    [self setupSlideGesture];
    self.tableView.userInteractionEnabled = NO;
    //adds our first default view controller as the top view controller
    [self addChildViewController:self.topViewController];
    self.topViewController.view.frame = self.view.frame;
    [self.view addSubview:self.topViewController.view];
    [self.topViewController didMoveToParentViewController:self];
}

-(void)setupViewControllers
{
   BPJTestTopViewController *firstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"demoVCOne"];
    
   
    firstViewController.burgerDelegate = self;
    
    firstViewController.title = @"First VC";
    
    BPJTestTopViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"demoVCTwo"];
    
    secondViewController.burgerDelegate = self;
    
    secondViewController.title = @"Second VC";
    
    self.viewControllersForMenu = @[firstViewController, secondViewController];
    
    self.topViewController = firstViewController;
}

- (void)setupSlideGesture
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.delegate = self;

    [self.view addGestureRecognizer:panRecognizer];
}

-(void)addTapRecognizerToTopViewController
{
    self.topVCTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu)];
    
    [self.topViewController.view addGestureRecognizer:self.topVCTapRecognizer];
}

-(void)movePanel:(id)sender
{
    //clear out any animations from our view's layer
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    //grab the point of the gesture and velocity
    CGPoint translatedPoint = [(UIPanGestureRecognizer *)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer *)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x) {
            //NSLog(@"gesture went right");
            
            //move the view controller with our pan, buy only if its going right (velocity.x >0)
            self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translatedPoint.x,self.topViewController.view.center.y);
            
            [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0,0) inView:self.view];
            
            //NSLog(@" %f",self.topViewController.view.frame.origin.x)
        }
    }
    
    if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded)
    {
        if (self.topViewController.view.frame.origin.x > self.view.frame.size.width/4)
        {
            [UIView animateWithDuration:.3 animations:^{
                self.topViewController.view.frame = CGRectMake(self.topViewController.view.frame.size.width * .75, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
            }];
            self.menuIsOpen = YES;
            
            self.tableView.userInteractionEnabled = YES;
            self.topViewController.view.userInteractionEnabled = YES;
            
            [self addTapRecognizerToTopViewController];
        }
        
        else
        {
            [UIView animateWithDuration:.3 animations:^{
                self.topViewController.view.frame = CGRectMake(0, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
            }];
             self.menuIsOpen = NO;
            self.tableView.userInteractionEnabled = NO;
        }
    }
    
}

-(void)switchToViewControllerAtIndex:(NSInteger)index
{
    [self.topViewController.view removeGestureRecognizer:self.topVCTapRecognizer];
    self.tableView.userInteractionEnabled = NO;
    
    //grab a weak pointer to self to avoid a retain cycle in our blocks
     __weak BPJMainMenuViewController *weakSelf = self;
    
    [UIView animateWithDuration:.4 animations:^{
        //slide the view controller that is being removed all the way to the right off screen
        weakSelf.topViewController.view.frame = CGRectMake(weakSelf.view.frame.size.width, weakSelf.topViewController.view.frame.origin.y, weakSelf.topViewController.view.frame.size.width, weakSelf.topViewController.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        //upon completion of that animation, remove the current top view controller and replace it with the selected view controller from the table view
        [weakSelf.topViewController.view removeFromSuperview];
        
        [weakSelf.topViewController removeFromParentViewController];
        
        weakSelf.topViewController = weakSelf.viewControllersForMenu[index];
        
        [weakSelf addChildViewController:weakSelf.topViewController];
        
        weakSelf.topViewController.view.frame = CGRectMake(weakSelf.view.frame.size.width, weakSelf.view.frame.origin.y, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
        
        [weakSelf.view addSubview:weakSelf.topViewController.view];
        
        [weakSelf.topViewController didMoveToParentViewController:weakSelf];
        
        weakSelf.topVCIsOnRight = NO;
        
        [weakSelf closeMenu];
    }];
}

-(void)closeMenu
{
    [UIView animateWithDuration:.7 delay:0 usingSpringWithDamping:2 initialSpringVelocity:.2 options:UIViewAnimationCurveEaseOut animations:^{
        self.topViewController.view.frame = CGRectMake(0, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        self.menuIsOpen = NO;
    }];
    
//    [UIView animateWithDuration:.4 animations:^{
//        //animate the new top view controller to slide from the right
//        self.topViewController.view.frame = CGRectMake(0, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
//    }];

}

# pragma mark - Main Menu protocol method
-(void)handleBurgerButton
{
    __weak BPJMainMenuViewController *weakSelf = self;
    self.topViewController.view.userInteractionEnabled = NO;
    
    if (self.menuIsOpen)
    {
        weakSelf.tableView.userInteractionEnabled = NO;
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.topViewController.view.frame = CGRectMake(0, weakSelf.topViewController.view.frame.origin.y, weakSelf.topViewController.view.frame.size.width, weakSelf.topViewController.view.frame.size.height);
            
        } completion:^(BOOL finished) {
            self.menuIsOpen = NO;
            [self.topViewController.view removeGestureRecognizer:self.topVCTapRecognizer];
            self.topViewController.view.userInteractionEnabled = YES;
            
        }];

        
    }
    else {
        
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.topViewController.view.frame = CGRectMake(250, weakSelf.topViewController.view.frame.origin.y, weakSelf.topViewController.view.frame.size.width, weakSelf.topViewController.view.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            [self addTapRecognizerToTopViewController];
            self.menuIsOpen = YES;
            weakSelf.tableView.userInteractionEnabled = YES;
            self.topViewController.view.userInteractionEnabled = YES;
        }];
        
        
    }
    
}

#pragma mark - Table view code

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewControllersForMenu.count; // number of rows in tableview corresponds to how many view controllers you want in the menu.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UIViewController *VC = self.viewControllersForMenu[indexPath.row];
    
    cell.textLabel.text = VC.title;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self switchToViewControllerAtIndex:indexPath.row];
}


@end
