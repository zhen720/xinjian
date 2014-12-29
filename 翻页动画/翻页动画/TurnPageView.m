//
//  TurnPageView.m
//  翻页动画
//
//  Created by lkk on 14-12-26.
//  Copyright (c) 2014年 lkk. All rights reserved.
//

#import "TurnPageView.h"
#import "POP.h"
typedef  NS_ENUM(NSUInteger, LayerSection){
    LayerSectionTop,
    LayerSectionBottom
};

@interface TurnPageView()
{
    UIImageView *_topImageView;
    UIImageView *_bottomImageView;
    UIImage *_image;
    CGFloat _loctionY;
}
@property(nonatomic,strong)UIImage *image;
@end

@implementation TurnPageView

+(instancetype)tutnPageViewWithFrame:(CGRect)frame image:(UIImage *)image{
    TurnPageView *turnPageView = [[TurnPageView alloc]initWithFrame:frame withImage:image];
    return turnPageView;
}
-(instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image{
    if (self = [super initWithFrame:frame]) {
        self.image = image;
        [self addTopImage];
        [self addBottomImage];
        [self addGestureRecognizer];
    }
    return self;

}
-(void)addTopImage{
    UIImage * topImage = [self imageForLayerSection:LayerSectionTop withImage:self.image];
    _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), CGRectGetMidY(self.bounds))];
    NSLog(@"%@",NSStringFromCGRect(_topImageView.frame));
    _topImageView.image = topImage;
    _topImageView.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
    _topImageView.layer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    _topImageView.userInteractionEnabled = YES;
    _topImageView.layer.mask = [self maskWithRect:_topImageView.bounds];
    _topImageView.layer.transform = [self transForm3D];
    [self addSubview:_topImageView];
}
-(void)addGestureRecognizer{
    UIPanGestureRecognizer *topPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(topPan:)];
    [_topImageView addGestureRecognizer:topPan];
    UITapGestureRecognizer *topTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_topImageView addGestureRecognizer:topTap];
    UITapGestureRecognizer *bottomTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_bottomImageView addGestureRecognizer:bottomTap];
    UIPanGestureRecognizer *bottomPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(bottomPan:)];
    [_bottomImageView addGestureRecognizer:bottomPan];
    
}
-(void)tap:(UITapGestureRecognizer *)tap{
    [self rotateToOriginWithVelocity:5 WithView:tap.view];
}
-(BOOL)isLocation:(CGPoint)location inView:(UIView*)View{
    if (location.x > 0 && location.x < CGRectGetWidth(self.bounds) && location.y > 0 && location.y < CGRectGetHeight(self.bounds)) {
        return YES;
    }
    return NO;
}
-(void)topPan:(UIPanGestureRecognizer *)pan{
    CGPoint location = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _loctionY = location.y;
        [self bringSubviewToFront:_topImageView];
    }
    if ([self isLocation:location inView:self]) {
        CGFloat conversionBase = - M_PI / (CGRectGetHeight(self.bounds) - _loctionY);
         POPBasicAnimation *rotation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotationX];
        rotation.duration = 0.01;
        rotation.toValue = @(conversionBase * (location.y - _loctionY));
        NSLog(@"%@",rotation.toValue);
        [_topImageView.layer pop_addAnimation:rotation forKey:@"rotationAnimation"];
        
    }else{
        pan.enabled = NO;
        pan.enabled = YES;
    }
   
    if(pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded){
        [self rotateToOriginWithVelocity:0 WithView:_topImageView];
    }

}

-(void)bottomPan:(UIPanGestureRecognizer *)pan{
    CGPoint location = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _loctionY = location.y;
        [self bringSubviewToFront:_bottomImageView];
    }
    if ([self isLocation:location inView:self]) {
        CGFloat conversionBase = - M_PI / (CGRectGetHeight(self.bounds) - _loctionY);
        POPBasicAnimation *rotation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotationX];
        rotation.duration = 0.01;
        rotation.toValue = @(conversionBase * (location.y - _loctionY));
        NSLog(@"%@",rotation.toValue);
        [_bottomImageView.layer pop_addAnimation:rotation forKey:@"rotationAnimation"];
        
    }else{
        pan.enabled = NO;
        pan.enabled = YES;
    }
    
    if(pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded){
        [self rotateToOriginWithVelocity:0 WithView:_bottomImageView];
    }
}
- (void)rotateToOriginWithVelocity:(CGFloat)velocity WithView:(UIView *)view
{
    POPSpringAnimation *rotationAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotationX];
    if (velocity > 0) {
        rotationAnimation.velocity = @(velocity);
    }
    rotationAnimation.springBounciness = 18.0f;
    rotationAnimation.dynamicsMass = 2.0f;
    rotationAnimation.dynamicsTension = 200;
    rotationAnimation.toValue = @(0);
    rotationAnimation.delegate = self;
    [view.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)addBottomImage{
    UIImage * topImage = [self imageForLayerSection:LayerSectionBottom withImage:self.image];
    _bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f,  CGRectGetMidY(self.bounds), CGRectGetWidth(self.bounds), CGRectGetMidY(self.bounds))];
    NSLog(@"%@",NSStringFromCGRect(_bottomImageView.frame));
    _bottomImageView.image = topImage;
    _bottomImageView.layer.anchorPoint = CGPointMake(0.5f, 0.0f);
    _bottomImageView.layer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bottomImageView.userInteractionEnabled = YES;
    _bottomImageView.layer.mask = [self maskWithRect:_bottomImageView.bounds];
    _bottomImageView.layer.transform = [self transForm3D];
    [self addSubview:_bottomImageView];
}

-(CATransform3D)transForm3D{
    /*
     {
     CGFloat m11（x缩放）, m12（y切变）, m13（）, m14（）;
     CGFloat m21（x切变）, m22（y缩放）, m23（）, m24（）;
     CGFloat m31（）, m32（）, m33（）, m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果。当然,z方向上得有变化才会有透视效果）;
     CGFloat m41（x平移）, m42（y平移）, m43（z平移）, m44（）;
     };
     */
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 2.5 / -2000;
    return transform;
}
-(UIImage *)imageForLayerSection:(LayerSection)section withImage:(UIImage *)image{
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height/2);
    if (section == LayerSectionBottom) {
        rect.origin.y = image.size.height / 2;
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *imagePart = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return imagePart;
}
-(CAShapeLayer *)maskWithRect:(CGRect)rect{
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:3 cornerRadii:CGSizeMake(0, 0)].CGPath;
    return mask;
}
@end
