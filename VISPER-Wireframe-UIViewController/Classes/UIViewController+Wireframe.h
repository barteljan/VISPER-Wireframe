//
//  UIViewController+NVMDummy__Wireframe.h
//  VISPER-Wireframe
//
//  Created by Jan Bartel on 20.11.17.
//

#import <UIKit/UIKit.h>
@import VISPER_Wireframe_Core;

@interface UIViewController (Wireframe)

-(void)willRoute: (WireframeObjc*) wireframe
    routePattern: (NSString*) routePattern
          option: (RoutingOptionObjc*)option
      parameters: (NSDictionary*)parameters;
    
-(void) didRoute: (WireframeObjc*) wireframe
    routePattern: (NSString*) routePattern
          option: (RoutingOptionObjc*)option
      parameters: (NSDictionary*)parameters;

@end



