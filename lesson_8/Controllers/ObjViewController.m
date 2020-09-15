//
//  ObjViewController.m
//  lesson_8
//
//  Created by Oleksandr Karpenko on 15.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

#import "ObjViewController.h"

@interface ObjViewController ()

@end

@implementation ObjViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)okButtonClick:(id)sender {
    if ([_textfield.text  isEqual: @""]) {
        return;
    }
    
    _resultLabel.text = [NSString stringWithFormat:@"%@ %@", _resultLabel.text, _textfield.text];
    _textfield.text = @"";
}

@end
