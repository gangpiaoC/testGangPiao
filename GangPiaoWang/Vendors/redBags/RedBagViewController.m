//
//  ViewController.m
//  Snow
//
//  Created by 周 俊杰 on 13-9-16.
//  Copyright (c) 2013年 周 俊杰. All rights reserved.
//

#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#define IMAGE_X                      arc4random()%(int)Main_Screen_Width
#define IMAGE_ALPHA             ((float)(6 + (arc4random()%6)))/10
#define IMAGE_WIDTH              90 +  (arc4random() % 30)
#define PLUS_HEIGHT              Main_Screen_Height/25

#import "RedBagViewController.h"
#import "myImageView.h"
#import "XHColor.h"
#import "UIView+XH.h"
@interface RedBagViewController ()
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) NSTimer  *timer;

@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) NSMutableArray * arrayImage;

@end

@implementation RedBagViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _array=[[NSMutableArray alloc]init];
    _arrayImage=[[NSMutableArray alloc]init];
    self.view.backgroundColor = [XHColor colorWithHexString:@"000000" alpha:0.6];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.view addGestureRecognizer:self.tapGesture];
    _imagesArray = [[NSMutableArray alloc] init];
    [self addPics];
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(makeSnow) userInfo:nil repeats:YES];
    
    UIImageView *bottomImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height - 79 - 64, Main_Screen_Width, 79)];
    bottomImgView.image = [UIImage imageNamed:@"home_getbag_rbbottom"];
    [self.view addSubview:bottomImgView];
}

-(void)addPics{
    
    //红包
    for (int i = 0; i < 150; ++ i) {
        float temp = IMAGE_WIDTH;
        float temp1 = temp / 100;
        myImageView *imageView = [[myImageView alloc] initWithImage:[UIImage imageNamed:@"home_getbag_rb"]];
        imageView.frame = CGRectMake(IMAGE_X + 80, -136 * temp1, 95* temp1, 136* temp1);
        //imageView.alpha = IMAGE_ALPHA;
        imageView.indexPath=i;
        [_array addObject:imageView.layer];
        [_arrayImage addObject:imageView];
        [self.view addSubview:imageView];
        [_imagesArray addObject:imageView];
    }
    
    //pic1
    for (int i = 0; i < 20; ++ i) {
        int temp = IMAGE_WIDTH;
         float temp1 = 1;
        myImageView *imageView = [[myImageView alloc] initWithImage:[UIImage imageNamed:@"home_getbag_pic1"]];
        imageView.frame = CGRectMake(IMAGE_X, -32*temp1, 32*temp1, 18*temp1);
        imageView.alpha = IMAGE_ALPHA;
        imageView.indexPath=10000 + i;
        int tempNum = arc4random() % (_arrayImage.count - 1);
         [_array insertObject:imageView.layer atIndex:tempNum];
         [_arrayImage insertObject:imageView atIndex:tempNum];
        [self.view addSubview:imageView];
         [_imagesArray insertObject:imageView atIndex:tempNum];
    }
    
    //pic2
    for (int i = 0; i < 20; ++ i) {
        myImageView *imageView = [[myImageView alloc] initWithImage:[UIImage imageNamed:@"home_getbag_pic2"]];
        imageView.frame = CGRectMake(IMAGE_X, -46, 46, 25);
        //imageView.alpha = IMAGE_ALPHA;
        imageView.indexPath=10000 + i;
        int tempNum = arc4random() % (_arrayImage.count - 1);
        [_array insertObject:imageView.layer atIndex:tempNum];
        [_arrayImage insertObject:imageView atIndex:tempNum];
        [self.view addSubview:imageView];
        [_imagesArray insertObject:imageView atIndex:tempNum];
    }
    
    //pic3
    for (int i = 0; i < 20; ++ i) {
        myImageView *imageView = [[myImageView alloc] initWithImage:[UIImage imageNamed:@"home_getbag_pic3"]];
        imageView.frame = CGRectMake(IMAGE_X, -46, 16, 16);
        imageView.alpha = IMAGE_ALPHA;
        imageView.indexPath=10000 + i;
        int tempNum = arc4random() % (_arrayImage.count - 1);
        [_array insertObject:imageView.layer atIndex:tempNum];
        [_arrayImage insertObject:imageView atIndex:tempNum];
        [self.view addSubview:imageView];
        [_imagesArray insertObject:imageView atIndex:tempNum];
    }
    
    //pic4
    for (int i = 0; i < 20; ++ i) {
        float temp = IMAGE_WIDTH;
        float temp1 = temp / 100;
        myImageView *imageView = [[myImageView alloc] initWithImage:[UIImage imageNamed:@"home_getbag_pic4"]];
        imageView.frame = CGRectMake(IMAGE_X, -99*temp1, 43*temp1, 99*temp1);
        //imageView.alpha = IMAGE_ALPHA;
        imageView.indexPath=10000 + i;
        int tempNum = arc4random() % (_arrayImage.count - 1);
        [_array insertObject:imageView.layer atIndex:tempNum];
        [_arrayImage insertObject:imageView atIndex:tempNum];
        [self.view addSubview:imageView];
        [_imagesArray insertObject:imageView atIndex:tempNum];
    }
}

-(void)click:(UITapGestureRecognizer *)tapGesture {
    CGPoint touchPoint = [tapGesture locationInView:self.view];
    for (myImageView * imgView in _arrayImage) {
        if ([imgView.layer .presentationLayer hitTest:touchPoint]) {
            if (imgView.tag < 10000) {
                if(_ButtonBlock){
                    [_timer invalidate];
                    self.ButtonBlock();
                }
                return;
            }
        }
    }
}

static int i = 0;
- (void)makeSnow{
    i = i + 1;
    if ([_imagesArray count] > 0) {
        UIImageView *imageView = [_imagesArray objectAtIndex:0];
        imageView.tag = i;
        [_imagesArray removeObjectAtIndex:0];
        [self snowFall:imageView];
    }
}

- (void)snowFall:(UIImageView *)aImageView{
    //CGAffineTransform transform=         CGAffineTransformMakeRotation(M_PI/2);
    [UIView beginAnimations:[NSString stringWithFormat:@"%i",aImageView.tag] context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelegate:self];
    aImageView.frame = CGRectMake(aImageView.frame.origin.x - 250, Main_Screen_Height, aImageView.frame.size.width, aImageView.frame.size.height);
    [UIView commitAnimations];
}

- (void)addImage{
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:[animationID intValue]];
    int temp = IMAGE_WIDTH;
    imageView.frame = CGRectMake(IMAGE_X + 80, -imageView.height, imageView.width, imageView.height);
    [_imagesArray addObject:imageView];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
