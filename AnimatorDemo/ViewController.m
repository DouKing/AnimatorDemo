//
//  ViewController.m
//  AnimatorDemo
//
//  Created by WuYikai on 2017/10/25.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import "ViewController.h"

// __weak
#ifndef    __weakly
#define __weakly( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")
#endif

// __strong
#ifndef    __strongly
#define __strongly( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")
#endif


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *ball;
@property (nonatomic, strong) UIViewPropertyAnimator *animator;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
  [self.view addGestureRecognizer:pan];
}

- (void)panAction:(UIPanGestureRecognizer *)gesture {
  UIGestureRecognizerState state = gesture.state;
  switch (state) {
    case UIGestureRecognizerStateBegan: {
      [self.animator pauseAnimation];
    }
      break;
    case UIGestureRecognizerStateChanged: {
      CGFloat distance = self.view.bounds.size.height - self.view.safeAreaInsets.bottom - self.ball.frame.size.height - self.view.safeAreaInsets.top;
      CGPoint point = [gesture locationInView:self.view];
      self.animator.fractionComplete = (self.view.bounds.size.height - self.view.safeAreaInsets.bottom - self.ball.frame.size.height - point.y) / distance;
    }
      break;
    case UIGestureRecognizerStateCancelled:
    case UIGestureRecognizerStateEnded: {
      __weakly(self);
      [self.animator addAnimations:^{
        __strongly(self);
        self.ball.backgroundColor = [UIColor orangeColor];
      }];
      UISpringTimingParameters *param = [[UISpringTimingParameters alloc] initWithDampingRatio:0.1];
      [self.animator continueAnimationWithTimingParameters:param durationFactor:0];
    }
      break;
    case UIGestureRecognizerStateFailed: {

    }
      break;
    case UIGestureRecognizerStatePossible: {

    }
      break;
    default:
      break;
  }
}

- (IBAction)startAnimating:(UIButton *)sender {
  if (self.animator.isReversed) {
    return;
  }
  __weakly(self);
  self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:5 dampingRatio:0.8 animations:^{
    __strongly(self);
    self.ball.frame = CGRectOffset(self.ball.frame, 0, self.view.safeAreaInsets.top - self.ball.frame.origin.y);
  }];
  [self.animator startAnimationAfterDelay:1];
}

- (IBAction)reset:(UIButton *)sender {
  if (self.animator.isRunning) {
    self.animator.reversed = YES;
  } else {
    self.ball.frame = CGRectOffset(self.ball.frame, 0,
                                   self.view.bounds.size.height - self.view.safeAreaInsets.bottom - self.ball.frame.origin.y - self.ball.frame.size.height);
    self.ball.backgroundColor = [UIColor greenColor];
  }
}

@end
