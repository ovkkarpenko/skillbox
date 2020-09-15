//
//  Obj2ViewController.m
//  lesson_8
//
//  Created by Oleksandr Karpenko on 15.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

#import "Obj2ViewController.h"

@interface Obj2ViewController ()

@end

@implementation Obj2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)okButtonClick:(id)sender {
    int number = [_textfield.text doubleValue];
    
    if (number == 0) {
        _resultLabel.text = @"Enter an integer";
        return;
    }
    
    _resultLabel.text = [NSString stringWithFormat:@"%.2f", pow(2, number)];
}

@end
