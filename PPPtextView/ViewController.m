//
//  ViewController.m
//  PPPtextView
//
//  Created by 张朋 on 16/9/15.
//  Copyright © 2016年 张朋. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = @"中国网是国务院新闻办公室和国家互联网信息办公室领导，中国外文出版发行事业局管理的国家重点新闻网站。自2000年成立以来，陆续实现了用中、英、法、西、德、日、俄、阿、韩、世界语10个语种11个文版，24小时对外发布信息，访问用户覆盖全球200多个国家和地区，成为中国进行国际传播、信息交流的重要窗口。中国网坚持以新闻为前导，以国情为基础，通过精心整合的即时新闻、详实的背景资料和网上独家的深度报道，以多语种、多媒体形式，向世界及时全面地介绍中国。";
    
    UIFont *font = [UIFont fontWithName:@"helvetica" size:16.0f];

    PPtextView *label = [[PPtextView alloc]initWithFrame:[PPtextView getStringFrameWithString:str xValue:20 yValue:100 widthVaule:320-40 useFont:font]];

    [label setText:str];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setTextFont:font];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
