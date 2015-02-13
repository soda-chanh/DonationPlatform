//
//  BNConstants.h
//  BegNoMore
//
//  Created by Stacey Dao on 12/21/12.
//
//



// Vendor IDs

#define kParseAppId      @"lo32BYbVAyu4woj8RxoNBY2OH6qcc5xqTzCPIukV"
#define kParseClientId   @"E2uNxmgCslDXtegvrm0pcUdRAwGzTx5dOAEc45ZH"
#define kParseFacebookId @"535920663087642"

#define kFlurryAppId     @"KRSRYT5GMX9SSJJ3Z2YV"

// Paypal

#define kPayPalIsSandbox                    1
#define kPayPalSandboxAppId                 @"APP-80W284485P519543T"
#define kPayPalLiveAppId                    @""

#ifdef kPayPalIsSandbox
#define kPayPalClientId @"Ac7OJxAtL_w1a34l6njiaqbI9WtE6mNm_0MJNH67-WXCAmlQwZrJrBiNiaNJ"
#define kPayPalSecret   @"EJGqjxChPDkWBhV4VajI7r0S_Y-DQ75o-wblOTm3SrilQ8j5e9k30M3_FMuQ"
#else
#define kPayPalClientId @"AfMLTxCnzGg1NGvDJ7On6YV0-mK96zy3AO8Dp8Uw2XQjeUGVGaoNZcbs5qVa"
#define kPayPalSecret   @"EN9zYhAtJVqyKcjaYFxVxHHJMdexsyTBHDUuMnsm-WKmfEcp6MWGfU_QkK3I"
#endif

#define kPayPaylTestEmail     @"deanyar-facilitator@gooddonationprogram.org"
#define kPayPalReceiverEmail  @"deanyar@gooddonationprogram.org"


// Stripe

#if DEBUG
    #define HOST STAGING
    #define kStripePublishableKey @"pk_test_6b02Ene22AdK34Od6GtcT2OF"
#else
    #define HOST PROD
    #define kStripePublishableKey @"pk_live_HMdckM3axHteZB6J97fpqqYo"
#endif




#define kGoodDonationProgramRecipientEmail  @"stacey@gooddonationprogram.org"

#define kEncryptionPassword                 @"p4ssw0rd"

// Entities

#define kUserKey          @"User"
#define kFavorite         @"Favorite"
#define kOrganization     @"Organization"
#define kOrganizationType @"OrganizationType"



#define kCategoryButtonHeight 75
#define kCategoryButtonWidth  75

// Parse Models






// Category

#define kCategoryImageButtonName @"imageButtonName"
#define kCategoryName            @"name"
#define kCategoryTypeId          @"organizationTypeId"

// Organization

#define kOrganizationName         @"name"
#define kOrganizationTypeId       @"organizationTypeId"
#define kOrganizationImageName    @"imageName"
#define kOrganizationBlurb        @"blurb"