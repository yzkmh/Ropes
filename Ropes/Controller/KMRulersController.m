//
//  KMRulersController.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/5/3.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMRulersController.h"

@interface KMRulersController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *touchView;


@end

@implementation KMRulersController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = KMMainScreenBounds;
    NSString *context = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"userRulers" ofType:@".txt"] encoding:0x80000632 error:nil];
    textView.scrollEnabled = YES;
    [textView setTextColor:[UIColor blackColor]];
    [textView setEditable:NO];
    [textView setFont:[UIFont systemFontOfSize:15.0f]];
    [textView setText:context];
    
    
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.touchView addGestureRecognizer:singleRecognizer];
    [self.touchView addSubview:textView];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)tap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
