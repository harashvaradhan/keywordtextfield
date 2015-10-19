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
    keywords = [[NSMutableSet alloc]init];
    
    scrollKeyword = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, self.viewKeyword.frame.size.width, 60)];
    scrollKeyword.backgroundColor = [UIColor blackColor];
    scrollKeyword.delegate = self;
    
    txtKeyword = [[UITextField alloc]initWithFrame:CGRectMake(0, 10, self.viewKeyword.frame.size.width, 40)];
    txtKeyword.backgroundColor = [UIColor yellowColor];
    txtKeyword.delegate = self;
    txtKeyword.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [scrollKeyword addSubview:txtKeyword];
    [self.viewKeyword addSubview:scrollKeyword];
    //for Demo not related with actual project
//    NSString *apiTime = @"14:30:00";
    NSString *apiTime = @"00:30:00";
    NSLog(@"API Time : %@",apiTime);
    NSString *finalTime;
    
    NSArray *amArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11"];
    
    NSArray *pmArray = @[@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
   
    NSArray *timeArray = [apiTime componentsSeparatedByString:@":"];
    NSLog(@"TimeArray : %@",timeArray);
    
    if([amArray containsObject:[timeArray objectAtIndex:0]]){
        if([amArray indexOfObject:[timeArray objectAtIndex:0]] == 0){
            finalTime = [NSString stringWithFormat:@"12:%@ AM",[timeArray objectAtIndex:1]];
        }else{
            finalTime = [NSString stringWithFormat:@"%@:%@ AM",[timeArray objectAtIndex:0],[timeArray objectAtIndex:1]];
        }
    }else{
        NSUInteger index = [pmArray indexOfObject:[timeArray objectAtIndex:0]];
        NSLog(@"Index : %lu",(unsigned long)index);
        finalTime = [NSString stringWithFormat:@"%@:%@ PM",[amArray objectAtIndex:index],[timeArray objectAtIndex:1]];
    }
    
    NSLog(@"Final Time : %@",finalTime);
    
    /*NSDateFormatter *formatterTime = [[NSDateFormatter alloc]init];
    [formatterTime setDateFormat:@"HH:mm:ss's'"];
    NSDate *time24hr = [formatterTime dateFromString:[NSString stringWithFormat:@"%@s",apiTime]];
    [formatterTime setDateFormat:@"h:mm a"];
    NSString *time12hr = [formatterTime stringFromDate:time24hr];
    NSLog(@"TwelveHour : %@",time12hr);*/
    //for Demo not related with actual project
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
