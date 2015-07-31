//
//  ViewController.m
//  KeywordDemo
//
//  Created by GNR solution PVT.LTD on 31/07/15.
//  Copyright (c) 2015 Harshavardhan Edke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate,UIScrollViewDelegate>{
    int keywordCount;
    float xForNewKeyword;
    NSMutableSet *keywords;
}

@end

@implementation ViewController
@synthesize scrollKeyword;
@synthesize txtKeyword;
- (void)viewDidLoad {
    [super viewDidLoad];
    keywords = [[NSMutableArray alloc]init];
    
    scrollKeyword = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, self.viewKeyword.frame.size.width, 60)];
    scrollKeyword.backgroundColor = [UIColor blackColor];
    scrollKeyword.delegate = self;
    
    txtKeyword = [[UITextField alloc]initWithFrame:CGRectMake(0, 10, self.viewKeyword.frame.size.width, 40)];
    txtKeyword.backgroundColor = [UIColor yellowColor];
    txtKeyword.delegate = self;
    txtKeyword.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [scrollKeyword addSubview:txtKeyword];
    [self.viewKeyword addSubview:scrollKeyword];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 
#pragma mark - UITextField Delegate
#pragma mark -

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if ([string isEqual:@" "]) {
        NSLog(@"Space bar pressed");
        NSString *someString = [txtKeyword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![someString isEqual:@""]) {
            UIFont *yourFont = [UIFont systemFontOfSize:14.0];
            CGSize frameSize = [someString sizeWithFont:yourFont];
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(xForNewKeyword, 10, frameSize.width, txtKeyword.frame.size.height)];
            lbl.text = someString;
            lbl.font = [UIFont systemFontOfSize:13.0];
            lbl.backgroundColor = [UIColor redColor];

            keywordCount = keywordCount + 1;
            xForNewKeyword = xForNewKeyword + frameSize.width + 5;
//            NSLog(@"keywordCount : %d, xForNewKeyword : %f",keywordCount,xForNewKeyword);
            [scrollKeyword addSubview:lbl];
            txtKeyword.text = nil;
            [keywords addObject:someString];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeLabel:)];
            tap.numberOfTapsRequired = 1;
            [lbl addGestureRecognizer:tap];
            lbl.userInteractionEnabled = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"change text frame CGRectMake(%f,%f,%f, %f)",xForNewKeyword, txtKeyword.frame.origin.y, txtKeyword.frame.size.width, txtKeyword.frame.size.height);
            
            [txtKeyword setFrame:CGRectMake(xForNewKeyword, txtKeyword.frame.origin.y, txtKeyword.frame.size.width, txtKeyword.frame.size.height)];
        });
        scrollKeyword.contentSize = CGSizeMake(xForNewKeyword+txtKeyword.frame.size.width, scrollKeyword.frame.size.height);
    }
    return YES;
}


#pragma mark -
#pragma mark - Gesture recognizer edkeevents
#pragma mark -

-(void)removeLabel:(UIGestureRecognizer *)gesture{
    UILabel *lbl = (UILabel *)gesture.view;
    [keywords removeObject:lbl.text];
    for (UIView *view in scrollKeyword.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    xForNewKeyword = 0;
    keywordCount = 0;
    for (NSString *word in keywords) {
//        NSLog(@"Word : %@",word);
        UIFont *yourFont = [UIFont systemFontOfSize:14.0];
        CGSize frameSize = [word sizeWithFont:yourFont];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(xForNewKeyword, 10, frameSize.width, txtKeyword.frame.size.height)];
        lbl.text = word;
        lbl.font = [UIFont systemFontOfSize:13.0];
        lbl.backgroundColor = [UIColor redColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeLabel:)];
        tap.numberOfTapsRequired = 1;
        [lbl addGestureRecognizer:tap];
        lbl.userInteractionEnabled = YES;

        keywordCount = keywordCount + 1;
        xForNewKeyword = xForNewKeyword + frameSize.width + 5;
        [scrollKeyword addSubview:lbl];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [txtKeyword setFrame:CGRectMake(xForNewKeyword, txtKeyword.frame.origin.y, txtKeyword.frame.size.width, txtKeyword.frame.size.height)];
    });
    scrollKeyword.contentSize = CGSizeMake(xForNewKeyword+txtKeyword.frame.size.width, scrollKeyword.frame.size.height);
    NSLog(@"Remaining Keywords : %@",keywords);
}

@end
