#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BarCodeKit.h"
#import "BCKBarString.h"
#import "BCKBarStringFunctions.h"
#import "BCKCodabarCode.h"
#import "BCKCodabarCodeCharacter.h"
#import "BCKCodabarContentCodeCharacter.h"
#import "BCKCode.h"
#import "BCKCode11Code.h"
#import "BCKCode11CodeCharacter.h"
#import "BCKCode11ContentCodeCharacter.h"
#import "BCKCode128Code.h"
#import "BCKCode128CodeCharacter.h"
#import "BCKCode128ContentCodeCharacter.h"
#import "BCKCode39Code.h"
#import "BCKCode39CodeCharacter.h"
#import "BCKCode39CodeModulo43.h"
#import "BCKCode39ContentCodeCharacter.h"
#import "BCKCode39FullASCII.h"
#import "BCKCode39FullASCIIModulo43.h"
#import "BCKCode93Code.h"
#import "BCKCode93CodeCharacter.h"
#import "BCKCode93ContentCodeCharacter.h"
#import "BCKCodeCharacter.h"
#import "BCKCodeFunctions.h"
#import "BCKEAN13Code.h"
#import "BCKEAN2SupplementCode.h"
#import "BCKEAN5SupplementCode.h"
#import "BCKEAN8Code.h"
#import "BCKEANCodeCharacter.h"
#import "BCKEANDigitCodeCharacter.h"
#import "BCKFacingIdentificationMarkCode.h"
#import "BCKFacingIdentificationMarkCodeCharacter.h"
#import "BCKGTINCode.h"
#import "BCKGTINSupplementCodeCharacter.h"
#import "BCKGTINSupplementDataCodeCharacter.h"
#import "BCKInterleaved2of5Code.h"
#import "BCKInterleaved2of5CodeCharacter.h"
#import "BCKInterleaved2of5DigitPairCodeCharacter.h"
#import "BCKISBNCode.h"
#import "BCKISMNCode.h"
#import "BCKISSNCode.h"
#import "BCKMSICode.h"
#import "BCKMSICodeCharacter.h"
#import "BCKMSIContentCodeCharacter.h"
#import "BCKMutableBarString.h"
#import "BCKPharmacodeOneTrack.h"
#import "BCKPharmaOneTrackContentCodeCharacter.h"
#import "BCKPOSTNETCode.h"
#import "BCKPOSTNETCodeCharacter.h"
#import "BCKPOSTNETContentCodeCharacter.h"
#import "BCKStandard2of5Code.h"
#import "BCKStandard2of5CodeCharacter.h"
#import "BCKStandard2of5ContentCodeCharacter.h"
#import "BCKUPCACode.h"
#import "BCKUPCCodeCharacter.h"
#import "BCKUPCECode.h"
#import "NSError+BCKCode.h"
#import "NSImage+BarCodeKit.h"
#import "NSString+BCKCode128Helpers.h"
#import "UIImage+BarCodeKit.h"

FOUNDATION_EXPORT double BarCodeKitVersionNumber;
FOUNDATION_EXPORT const unsigned char BarCodeKitVersionString[];

