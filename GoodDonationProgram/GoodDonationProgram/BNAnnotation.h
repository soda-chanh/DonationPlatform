//
//  BNAnnotation.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 4/14/14.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol BNAnnotationProtocol <NSObject>
@end


@interface BNAnnotation : NSObject <MKAnnotation, BNAnnotationProtocol>
@end
