//
//  KeyDerivation.h
//  AEAccordion
//
//  Created by Alexey Sidorov on 11/05/2018.
//

#import <Foundation/Foundation.h>


@interface KeyDerivation : NSObject

@property (nonatomic, readonly, nullable) NSData *privateKey;
@property (nonatomic, readonly, nullable) NSData *publicKey;
@property (nonatomic, readonly) NSData *chainCode;
@property (nonatomic, readonly) uint8_t depth;
@property (nonatomic, readonly) uint32_t fingerprint;
@property (nonatomic, readonly) uint32_t childIndex;

- (instancetype)initWithPrivateKey:(nullable NSData *)privateKey publicKey:(nullable NSData *)publicKey chainCode:(NSData *)chainCode depth:(uint8_t)depth fingerprint:(uint32_t)fingerprint childIndex:(uint32_t)childIndex;
- (nullable KeyDerivation *)derivedAtIndex:(uint32_t)childIndex hardened:(BOOL)hardened;

@end
