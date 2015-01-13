//
//  ViewController.m
//  Chameleon
//
//  Created by Volchik on 22.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "ViewController.h"
#import "ExtendedHitAreaViewContainer.h"
#import "Application.h"
#import "BankList.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainView.backgroundColor=[UIColor colorWithRed:0.5 green:1 blue:0 alpha:0.5];
    
    self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0,_mainView.frame.size.height-50,100,50)];
    self.pageControl.numberOfPages=10;
    [_mainView addSubview:self.pageControl];
    int subViewWidth=400;
    int subViewHeight=600;
    int subViewDistance=50;
    int subViewOverlap=50;
    if (subViewHeight>_mainView.frame.size.height)
        subViewHeight=_mainView.frame.size.height;
    if (subViewWidth+2*subViewDistance+2*subViewOverlap>_mainView.frame.size.width)
    {
        subViewWidth=_mainView.frame.size.width;
        subViewDistance=0;
        subViewOverlap=0;
    }
    int scrollWidth=subViewWidth+2*subViewDistance+2*subViewOverlap;
    
    self.bankScrollViewContainer=[[ExtendedHitAreaViewContainer alloc]
                                  initWithFrame:CGRectMake((_mainView.frame.size.width-scrollWidth)/2,
                                                           (_mainView.frame.size.height-subViewHeight)/2,
                                                            scrollWidth,
                                                            subViewHeight)];
    self.bankScrollView = [[UIScrollView alloc]
                         initWithFrame:CGRectMake(subViewOverlap+subViewDistance,
                                                  0,
                                                  subViewWidth+subViewDistance,
                                                  subViewHeight)];
    //set the paging to yes
    self.bankScrollView.clipsToBounds = NO;
    self.bankScrollViewContainer.clipsToBounds=YES;
    self.bankScrollView.pagingEnabled = YES;
    self.bankScrollView.showsHorizontalScrollIndicator = NO;
    //[self.bankScrollView setContentInset:UIEdgeInsetsMake(0,200,0.0,200)];
    
    NSInteger numberOfViews = APP.banks.count;
    
    //lets create 10 views
//    NSInteger numberOfViews = 10;
    for (int i = 0; i < numberOfViews; i++) {
        
        //set the origin of the sub view
        CGFloat myOrigin = (i)*(subViewWidth+subViewDistance);
        
        //create the sub view and allocate memory
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(myOrigin, 0, subViewWidth, subViewHeight)];
        //set the background to white color
        myView.backgroundColor = [UIColor whiteColor];
        
        //create a label and add to the sub view
        CGRect myFrame = CGRectMake(10.0f, 10.0f, 200.0f, 25.0f);
        UILabel *myLabel = [[UILabel alloc] initWithFrame:myFrame];
        myLabel.text = [NSString stringWithFormat:@"This is page number %d", i];
        myLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        myLabel.textAlignment =  NSTextAlignmentLeft;
        [myView addSubview:myLabel];
        
        //create a text field and add to the sub view
        myFrame.origin.y += myFrame.size.height + 10.0f;
        UITextField *myTextField = [[UITextField alloc] initWithFrame:myFrame];
        myTextField.borderStyle = UITextBorderStyleRoundedRect;
        myTextField.placeholder = [NSString stringWithFormat:@"Enter data in field %i", i];
        myTextField.tag = i+1;
        myTextField.enabled=YES;
        [myView addSubview:myTextField];
        
        //set the scroll view delegate to self so that we can listen for changes
        //self.bankScrollView.delegate = self;
        //add the subview to the scroll view
        [self.bankScrollView addSubview:myView];
    }
    
    //set the content size of the scroll view, we keep the height same so it will only
    //scroll horizontally
    self.bankScrollView.contentSize = CGSizeMake(subViewWidth+(subViewWidth+subViewDistance) * (numberOfViews-1)+subViewDistance,
                                               subViewHeight);
    
    //we set the origin to the 3rd page
    //CGPoint scrollPoint = CGPointMake(self.view.frame.size.width * 2, 0);
    //change the scroll view offset the the 3rd page so it will start from there
    //[self.bankScrollView setContentOffset:scrollPoint animated:YES];
    
    [_mainView addSubview:self.bankScrollViewContainer];
    
    [self.bankScrollViewContainer addSubview:self.bankScrollView];
    
    /*int i=[self.view subviews].count;
    NSLog(@"%d",i);
    NSMutableArray* constraints=[[NSMutableArray alloc] init];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:input attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:input attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:1]];
    [self.view addConstraints:constraints];*/
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%f",_mainView.frame.size.width);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"%f",_mainView.frame.size.width);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
