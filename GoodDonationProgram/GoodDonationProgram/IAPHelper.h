//
//  IAHelper.h
//  BegNoMore
//
//  Created by Stacey Dao on 1/17/13.
//
//

#import <Foundation/Foundation.h>


typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

@end