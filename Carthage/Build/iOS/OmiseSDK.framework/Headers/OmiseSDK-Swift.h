// Generated by Apple Swift version 4.0 (swiftlang-900.0.65 clang-900.0.37)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_attribute(external_source_symbol)
# define SWIFT_STRINGIFY(str) #str
# define SWIFT_MODULE_NAMESPACE_PUSH(module_name) _Pragma(SWIFT_STRINGIFY(clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in=module_name, generated_declaration))), apply_to=any(function, enum, objc_interface, objc_category, objc_protocol))))
# define SWIFT_MODULE_NAMESPACE_POP _Pragma("clang attribute pop")
#else
# define SWIFT_MODULE_NAMESPACE_PUSH(module_name)
# define SWIFT_MODULE_NAMESPACE_POP
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR __attribute__((enum_extensibility(open)))
# else
#  define SWIFT_ENUM_ATTR
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
@import UIKit;
@import CoreGraphics;
@import ObjectiveC;
@import Foundation;
@import WebKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

SWIFT_MODULE_NAMESPACE_PUSH("OmiseSDK")
typedef SWIFT_ENUM_NAMED(NSInteger, OMSCardBrand, "CardBrand") {
  OMSCardBrandAMEX = 0,
  OMSCardBrandDiners = 1,
  OMSCardBrandJCB = 2,
  OMSCardBrandLaser = 3,
  OMSCardBrandVisa = 4,
  OMSCardBrandMasterCard = 5,
  OMSCardBrandMaestro = 6,
  OMSCardBrandDiscover = 7,
};

@class NSCoder;

/// Base UITextField subclass for SDK’s text fields.
SWIFT_CLASS("_TtC8OmiseSDK14OmiseTextField")
@interface OmiseTextField : UITextField
@property (nonatomic, copy) NSString * _Nullable text;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// UITextField subclass for entering card’s CVV number.
SWIFT_CLASS("_TtC8OmiseSDK16CardCVVTextField")
@interface CardCVVTextField : OmiseTextField
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic, getter=isSecureTextEntry) BOOL secureTextEntry;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


/// UIPickerView subclass pre-configured for picking card expiration month and year.
SWIFT_CLASS("_TtC8OmiseSDK20CardExpiryDatePicker")
@interface CardExpiryDatePicker : UIPickerView
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface CardExpiryDatePicker (SWIFT_EXTENSION(OmiseSDK)) <UIPickerViewDelegate>
- (NSString * _Nullable)pickerView:(UIPickerView * _Nonnull)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component SWIFT_WARN_UNUSED_RESULT;
- (void)pickerView:(UIPickerView * _Nonnull)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end


@interface CardExpiryDatePicker (SWIFT_EXTENSION(OmiseSDK)) <UIPickerViewDataSource>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView * _Nonnull)pickerView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)pickerView:(UIPickerView * _Nonnull)pickerView numberOfRowsInComponent:(NSInteger)component SWIFT_WARN_UNUSED_RESULT;
@end


/// UITextField subclass used for entering card’s expiry date.
/// <code>CardExpiryDatePicker</code> will be set as the default input view.
SWIFT_CLASS("_TtC8OmiseSDK23CardExpiryDateTextField")
@interface CardExpiryDateTextField : OmiseTextField
@property (nonatomic, readonly) NSInteger selectedMonth;
@property (nonatomic, readonly) NSInteger selectedYear;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


/// UITextField subclass for entering card holder’s name.
SWIFT_CLASS("_TtC8OmiseSDK17CardNameTextField")
@interface CardNameTextField : OmiseTextField
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


/// Utility class for working with credit card numbers.
SWIFT_CLASS_NAMED("CardNumber")
@interface OMSCardNumber : NSObject
/// Normalize credit card number by removing all non-number characters.
///
/// returns:
/// String of normalized credit card number. eg. <em>4242424242424242</em>
+ (NSString * _Nonnull)normalize:(NSString * _Nonnull)pan SWIFT_WARN_UNUSED_RESULT;
+ (NSInteger)brandForPan:(NSString * _Nonnull)pan SWIFT_WARN_UNUSED_RESULT;
/// Formats given credit card number into a human-friendly string by inserting spaces
/// after every 4 digits. ex. <code>4242 4242 4242 4242</code>
///
/// returns:
/// Formatted credit card number string.
+ (NSString * _Nonnull)format:(NSString * _Nonnull)pan SWIFT_WARN_UNUSED_RESULT;
/// Validate credit card number using the Luhn algorithm.
///
/// returns:
/// <code>true</code> if the Luhn check passes, otherwise <code>false</code>.
+ (BOOL)luhn:(NSString * _Nonnull)pan SWIFT_WARN_UNUSED_RESULT;
/// Validate credit card number by using the Luhn algorithm and checking that the length
/// is within credit card brand’s valid range.
///
/// returns:
/// <code>true</code> if the given credit card number is valid for all available checks, otherwise <code>false</code>.
+ (BOOL)validate:(NSString * _Nonnull)pan SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


/// UITextField subclass for entering the credit card number.
/// Automatically formats entered number into groups of four.
SWIFT_CLASS("_TtC8OmiseSDK19CardNumberTextField")
@interface CardNumberTextField : OmiseTextField
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@protocol OMSCreditCardFormDelegate;
@class NSBundle;

/// Drop-in credit card input form view controller that automatically tokenizes credit
/// card information.
SWIFT_CLASS("_TtC8OmiseSDK24CreditCardFormController")
@interface CreditCardFormController : UITableViewController
/// Omise public key for calling tokenization API.
@property (nonatomic, copy) NSString * _Nullable publicKey;
/// Delegate to receive CreditCardFormController result.
@property (nonatomic, weak) id <OMSCreditCardFormDelegate> _Nullable delegate;
/// A boolean flag to enables/disables automatic error handling. Defaults to <code>true</code>.
@property (nonatomic) BOOL handleErrors;
/// A boolean flag that enables/disables Card.IO integration.
@property (nonatomic) BOOL cardIOEnabled;
/// Factory method for creating CreditCardFormController with given public key.
/// \param publicKey Omise public key.
///
+ (CreditCardFormController * _Nonnull)makeCreditCardFormWithPublicKey:(NSString * _Nonnull)publicKey SWIFT_WARN_UNUSED_RESULT;
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UITableView;
@class UIView;

@interface CreditCardFormController (SWIFT_EXTENSION(OmiseSDK))
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForFooterInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UIView * _Nullable)tableView:(UITableView * _Nonnull)tableView viewForFooterInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (NSIndexPath * _Nullable)tableView:(UITableView * _Nonnull)tableView willSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@end

@class OMSToken;

/// Delegate to receive card tokenization events.
SWIFT_PROTOCOL_NAMED("CreditCardFormDelegate")
@protocol OMSCreditCardFormDelegate
/// Delegate method for receiving token data when card tokenization succeeds.
/// seealso:
/// <a href="https://www.omise.co/tokens-api">Tokens API</a>
/// \param token <code>OmiseToken</code> instance created from supplied credit card data.
///
- (void)creditCardForm:(CreditCardFormController * _Nonnull)controller didSucceedWithToken:(OMSToken * _Nonnull)token;
/// Delegate method for receiving error information when card tokenization failed.
/// This allows you to have fine-grained control over error handling when setting
/// <code>handleErrors</code> to <code>false</code>.
/// note:
/// This delegate method will <em>never</em> be called if <code>handleErrors</code> property is set to <code>true</code>.
/// \param error The error that occurred during tokenization.
///
- (void)creditCardForm:(CreditCardFormController * _Nonnull)controller didFailWithError:(NSError * _Nonnull)error;
@end

@class OMSTokenRequest;
@class NSError;

SWIFT_PROTOCOL("_TtP8OmiseSDK23OMSTokenRequestDelegate_")
@protocol OMSTokenRequestDelegate
- (void)tokenRequest:(OMSTokenRequest * _Nonnull)request didSucceedWithToken:(OMSToken * _Nonnull)token;
- (void)tokenRequest:(OMSTokenRequest * _Nonnull)request didFailWithError:(NSError * _Nonnull)error;
@end

@protocol OmiseAuthorizingPaymentViewControllerDelegate;
@class UINavigationController;

SWIFT_CLASS("_TtC8OmiseSDK37OmiseAuthorizingPaymentViewController")
@interface OmiseAuthorizingPaymentViewController : UIViewController
/// A factory method for creating a authorizing payment view controller comes in UINavigationController stack.
/// \param authorizedURL The authorized URL given in <code>Charge</code> object that will be set to <code>OmiseAuthorizingPaymentViewController</code>
///
/// \param expectedReturnURLPatterns The expected return URL patterns.
///
/// \param delegate A delegate object that will recieved authorizing payment events.
///
///
/// returns:
/// A UINavigationController with <code>OmiseAuthorizingPaymentViewController</code> as its root view controller
+ (UINavigationController * _Nonnull)makeAuthorizingPaymentViewControllerNavigationWithAuthorizedURL:(NSURL * _Nonnull)authorizedURL expectedReturnURLPatterns:(NSArray<NSURLComponents *> * _Nonnull)expectedReturnURLPatterns delegate:(id <OmiseAuthorizingPaymentViewControllerDelegate> _Nonnull)delegate SWIFT_WARN_UNUSED_RESULT;
/// A factory method for creating a authorizing payment view controller comes in UINavigationController stack.
/// \param authorizedURL The authorized URL given in <code>Charge</code> object that will be set to <code>OmiseAuthorizingPaymentViewController</code>
///
/// \param expectedReturnURLPatterns The expected return URL patterns.
///
/// \param delegate A delegate object that will recieved authorizing payment events.
///
///
/// returns:
/// An <code>OmiseAuthorizingPaymentViewController</code> with given authorized URL and delegate.
+ (OmiseAuthorizingPaymentViewController * _Nonnull)makeAuthorizingPaymentViewControllerWithAuthorizedURL:(NSURL * _Nonnull)authorizedURL expectedReturnURLPatterns:(NSArray<NSURLComponents *> * _Nonnull)expectedReturnURLPatterns delegate:(id <OmiseAuthorizingPaymentViewControllerDelegate> _Nonnull)delegate SWIFT_WARN_UNUSED_RESULT;
- (void)loadView;
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class WKWebView;
@class WKNavigationAction;

@interface OmiseAuthorizingPaymentViewController (SWIFT_EXTENSION(OmiseSDK)) <WKNavigationDelegate>
- (void)webView:(WKWebView * _Nonnull)webView decidePolicyForNavigationAction:(WKNavigationAction * _Nonnull)navigationAction decisionHandler:(void (^ _Nonnull)(WKNavigationActionPolicy))decisionHandler;
@end


/// Delegate to receive authorizing payment events.
SWIFT_PROTOCOL("_TtP8OmiseSDK45OmiseAuthorizingPaymentViewControllerDelegate_")
@protocol OmiseAuthorizingPaymentViewControllerDelegate
/// A delegation method called when the authorizing payment process is completed.
/// \param viewController The authorizing payment controller that call this method
///
/// \param redirectedURL A URL returned from the authorizing payment process.
///
- (void)omiseAuthorizingPaymentViewController:(OmiseAuthorizingPaymentViewController * _Nonnull)viewController didCompleteAuthorizingPaymentWithRedirectedURL:(NSURL * _Nonnull)redirectedURL;
/// A delegation method called when user cancel the authorizing payment process.
- (void)omiseAuthorizingPaymentViewControllerDidCancel:(OmiseAuthorizingPaymentViewController * _Nonnull)viewController;
@end


/// Represents saved credit card information.
/// seealso:
/// <a href="https://www.omise.co/cards-api">Cards API</a>
SWIFT_CLASS_NAMED("OmiseCard")
@interface OMSCard : NSObject
/// Card’s ID.
@property (nonatomic, copy) NSString * _Nullable cardId;
/// Boolean flag indicating wether this card is a live card or a test card.
@property (nonatomic) BOOL livemode;
/// Resource URL that can be used to re-load card information.
@property (nonatomic, copy) NSString * _Nullable location;
/// ISO3166 Country code based on the card number.
/// note:
/// This is informational only and may not always be 100% accurate.
@property (nonatomic, copy) NSString * _Nullable country;
/// Issuing city.
/// note:
/// This is informational only and may not always be 100% accurate.
@property (nonatomic, copy) NSString * _Nullable city;
/// Postal code.
@property (nonatomic, copy) NSString * _Nullable postalCode;
/// Credit card financing type. (debit or credit)
@property (nonatomic, copy) NSString * _Nullable financing;
/// Last 4 digits of the card number.
@property (nonatomic, copy) NSString * _Nullable lastDigits;
/// Card brand. (e.g. Visa, Mastercard, …)
@property (nonatomic, copy) NSString * _Nullable brand;
/// Unique card-based fingerprint. Allows detection of identical cards without
/// exposing card numbers directly.
@property (nonatomic, copy) NSString * _Nullable fingerprint;
/// Card holder’s full name.
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic) BOOL securityCodeCheck;
/// Card’s creation time.
@property (nonatomic, copy) NSDate * _Nullable created;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface OMSCard (SWIFT_EXTENSION(OmiseSDK))
/// Card expiration month (1-12)
@property (nonatomic) NSInteger expirationMonth;
/// Card expiration year (in Gregrorian calendar)
@property (nonatomic) NSInteger expirationYear;
@end


/// An input accessory view that provides next and previous buttons for moving between form fields.
SWIFT_CLASS_NAMED("OmiseFormAccessoryView")
@interface OMSFormAccessoryView : UIToolbar
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
/// Attach this accessory view to a set of text fields and view controller.
/// \param textFields Array of <code>UITextField</code> instances to attach to. Text fields
/// navigation order will be defined by the order in this array.
///
/// \param viewController A <code>UIViewController</code> that houses the supplied text fields.
/// The view controller’s view will be used as target for <code>endEditing</code> calls when
/// the <code>Done</code> button is tapped.
///
- (void)attachTo:(NSArray<UITextField *> * _Nonnull)textFields in:(UIViewController * _Nonnull)viewController;
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
@end

@class NSDateFormatter;

/// Utility class for parsing JSON data returned from Omise API.
SWIFT_CLASS_NAMED("OmiseJsonParser")
@interface OMSJSONParser : NSObject
/// Date formatter used for formatting the date fields returned from Omise API.
/// Dates from Omise API follows the ISO8601 standard.
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) NSDateFormatter * _Nonnull dateFormatter;)
+ (NSDateFormatter * _Nonnull)dateFormatter SWIFT_WARN_UNUSED_RESULT;
/// Parses Token data returned from Omise API.
/// \param data <code>NSData</code> with Token JSON returned from Omise API.
///
///
/// throws:
/// <code>OmiseError.Unexpected</code> if JSON parsing failed.
///
/// returns:
/// An <code>OmiseToken</code> instance parsed from JSON data.
+ (OMSToken * _Nullable)parseTokenFrom:(NSData * _Nonnull)data error:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
/// Parses an API error object returned from Omise API.
/// \param data <code>NSData</code> with Error JSON returned from Omise API.
///
///
/// throws:
/// <code>OmiseError.Unexpected</code> if JSON parsing failed.
///
/// returns:
/// <code>OmiseError</code> value.
+ (NSError * _Nullable)parseError:(NSData * _Nonnull)data error:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSOperationQueue;
@class NSURLSession;

/// Client object as the main entry point for performing Omise API calls.
SWIFT_CLASS_NAMED("OmiseSDKClient")
@interface OMSSDKClient : NSObject
/// Initializes OmiseSDKClient with default settings.
/// note:
/// Default settings use the default <code>NSOperationQueue</code> initializer and ephemeral
/// <code>NSURLSessionConfiguration</code>.
/// seealso:
/// init(publicKey:queue:session:)
/// \param publicKey Omise public key.
///
- (nonnull instancetype)initWithPublicKey:(NSString * _Nonnull)publicKey;
/// Initializes OmiseSDKClient with custom <code>NSOperationQueue</code> and <code>NSURLSession</code>.
/// seealso:
/// init(publicKey:)
/// \param publicKey Omise public key.
///
/// \param queue <code>NSOperationQueue</code> for performing API calls. Callbacks will always
/// be done on the main queue.
///
/// \param session <code>NSURLSession</code> for performing API calls.
///
- (nonnull instancetype)initWithPublicKey:(NSString * _Nonnull)publicKey queue:(NSOperationQueue * _Nonnull)queue session:(NSURLSession * _Nonnull)session OBJC_DESIGNATED_INITIALIZER;
/// Send a tokenization request to the Omise API.
/// seealso:
/// OmiseTokenRequest
/// seealso:
/// <a href="https://www.omise.co/tokens-api">Tokens API</a>
/// \param request <code>OmiseTokenRequest</code> instance.
///
/// \param callback Completion callback that will be called when the request is finished.
///
- (void)sendRequest:(OMSTokenRequest * _Nonnull)request callback:(void (^ _Nullable)(OMSToken * _Nullable, NSError * _Nullable))callback;
/// Send a tokenization request to the Omise API
/// seealso:
/// OmiseTokenRequest
/// seealso:
/// <a href="https://www.omise.co/tokens-api">Tokens API</a>
/// \param request <code>OmiseTokenRequest</code> instance.
///
/// \param delegate An object that implements <code>OmiseTokenRequestDelegate</code> where
/// request events delegate methods will be called on.
///
- (void)sendRequest:(OMSTokenRequest * _Nonnull)request delegate:(id <OMSTokenRequestDelegate> _Nullable)delegate;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end



/// Represents Omise card tokens.
/// seealso:
/// <a href="https://www.omise.co/tokens-api">Tokens API</a>
SWIFT_CLASS_NAMED("OmiseToken")
@interface OMSToken : NSObject
/// Token’s ID.
@property (nonatomic, copy) NSString * _Nullable tokenId;
/// Boolean flag indicating wether this card is a live card or a test card.
@property (nonatomic) BOOL livemode;
/// Resource URL that can be used to re-load token information.
@property (nonatomic, copy) NSString * _Nullable location;
/// Boolean flag indicating whether the token has been used or not.
/// Tokens can only be used once to make create a Charge or to create a saved Card record.
@property (nonatomic) BOOL used;
/// Card information used to generate this token.
@property (nonatomic, strong) OMSCard * _Nullable card;
/// Token’s creation time.
@property (nonatomic, copy) NSDate * _Nullable created;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


/// Encapsulates information required to perform tokenization requests.
/// seealso:
/// <a href="https://www.omise.co/tokens-api">Tokens API</a>
SWIFT_CLASS_NAMED("OmiseTokenRequest")
@interface OMSTokenRequest : NSObject
/// Card holder’s full name.
@property (nonatomic, readonly, copy) NSString * _Nonnull name;
/// Card number.
@property (nonatomic, readonly, copy) NSString * _Nonnull number;
/// Card expiration month (1-12)
@property (nonatomic, readonly) NSInteger expirationMonth;
/// Card expiration year (Gregorian)
@property (nonatomic, readonly) NSInteger expirationYear;
/// Security code (CVV, CVC, etc) printed on the back of the card.
@property (nonatomic, readonly, copy) NSString * _Nonnull securityCode;
/// Issuing city.
@property (nonatomic, readonly, copy) NSString * _Nullable city;
/// Postal code.
@property (nonatomic, readonly, copy) NSString * _Nullable postalCode;
/// Initializes new token request.
- (nonnull instancetype)initWithName:(NSString * _Nonnull)name number:(NSString * _Nonnull)number expirationMonth:(NSInteger)expirationMonth expirationYear:(NSInteger)expirationYear securityCode:(NSString * _Nonnull)securityCode city:(NSString * _Nullable)city postalCode:(NSString * _Nullable)postalCode OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS_NAMED("__OMSCardBrand")
@interface OMSCardBrandHelper : NSObject
+ (NSString * _Nonnull)patternForBrand:(enum OMSCardBrand)brand SWIFT_WARN_UNUSED_RESULT;
+ (NSRange)validLengthsForBrand:(enum OMSCardBrand)brand SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

SWIFT_MODULE_NAMESPACE_POP
#pragma clang diagnostic pop
