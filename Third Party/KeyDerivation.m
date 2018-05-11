//
//  KeyDerivation.m
//  AEAccordion
//
//  Created by Alexey Sidorov on 11/05/2018.
//

#import "KeyDerivation.h"
#import <openssl/sha.h>
#import <openssl/ripemd.h>
#import <openssl/hmac.h>
#import <openssl/ec.h>

@implementation KeyDerivation

- (instancetype)initWithPrivateKey:(NSData *)privateKey publicKey:(NSData *)publicKey chainCode:(NSData *)chainCode depth:(uint8_t)depth fingerprint:(uint32_t)fingerprint childIndex:(uint32_t)childIndex {
	self = [super init];
	if (self) {
		_privateKey = privateKey;
		_publicKey = publicKey;
		_chainCode = chainCode;
		_depth = depth;
		_fingerprint = fingerprint;
		_childIndex = childIndex;
	}
	return self;
}

- (KeyDerivation *)derivedAtIndex:(uint32_t)index hardened:(BOOL)hardened {
	BN_CTX *ctx = BN_CTX_new();
	
	NSMutableData *data = [NSMutableData data];
	if (hardened) {
		uint8_t padding = 0;
		[data appendBytes:&padding length:1];
		[data appendData:self.privateKey];
	} else {
		[data appendData:self.publicKey];
	}
	
	uint32_t childIndex = OSSwapHostToBigInt32(hardened ? (0x80000000 | index) : index);
	[data appendBytes:&childIndex length:sizeof(childIndex)];
	
	NSData *digest = [CryptoHash hmacsha512:data key:self.chainCode];
	NSData *derivedPrivateKey = [digest subdataWithRange:NSMakeRange(0, 32)];
	NSData *derivedChainCode = [digest subdataWithRange:NSMakeRange(32, 32)];
	
	BIGNUM *curveOrder = BN_new();
	BN_hex2bn(&curveOrder, "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141");
	
	BIGNUM *factor = BN_new();
	BN_bin2bn(derivedPrivateKey.bytes, (int)derivedPrivateKey.length, factor);
	// Factor is too big, this derivation is invalid.
	if (BN_cmp(factor, curveOrder) >= 0) {
		return nil;
	}
	
	NSMutableData *result;
	if (self.privateKey) {
		BIGNUM *privateKey = BN_new();
		BN_bin2bn(self.privateKey.bytes, (int)self.privateKey.length, privateKey);
		
		BN_mod_add(privateKey, privateKey, factor, curveOrder, ctx);
		// Check for invalid derivation.
		if (BN_is_zero(privateKey)) {
			return nil;
		}
		
		int numBytes = BN_num_bytes(privateKey);
		result = [NSMutableData dataWithLength:numBytes];
		BN_bn2bin(privateKey, result.mutableBytes);
		
		BN_free(privateKey);
	} else {
		BIGNUM *publicKey = BN_new();
		BN_bin2bn(self.publicKey.bytes, (int)self.publicKey.length, publicKey);
		EC_GROUP *group = EC_GROUP_new_by_curve_name(NID_secp256k1);
		
		EC_POINT *point = EC_POINT_new(group);
		EC_POINT_bn2point(group, publicKey, point, ctx);
		EC_POINT_mul(group, point, factor, point, BN_value_one(), ctx);
		// Check for invalid derivation.
		if (EC_POINT_is_at_infinity(group, point) == 1) {
			return nil;
		}
		
		BIGNUM *n = BN_new();
		result = [NSMutableData dataWithLength:33];
		
		EC_POINT_point2bn(group, point, POINT_CONVERSION_COMPRESSED, n, ctx);
		BN_bn2bin(n, result.mutableBytes);
		
		BN_free(n);
		BN_free(publicKey);
		EC_POINT_free(point);
		EC_GROUP_free(group);
	}
	
	BN_free(factor);
	BN_free(curveOrder);
	BN_CTX_free(ctx);
	
	uint32_t *fingerPrint = (uint32_t *)[CryptoHash sha256ripemd160:self.publicKey].bytes;
	return [[KeyDerivation alloc] initWithPrivateKey:result publicKey:result chainCode:derivedChainCode depth:self.depth + 1 fingerprint:*fingerPrint childIndex:childIndex];
}
@end
