//
//  Hex.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 28/03/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation


//A bit of overengineered fun for manageing bytes as hex strings
struct HexPairSequence: Sequence, IteratorProtocol {
	
	enum Error: Swift.Error {
		case invalidCharacter
		case incompletePair
	}
	
	static func verify(string: String, numberOfPairs: Int? = nil) throws {
		guard string.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789abcdefABCDEF").inverted) == nil,
			string.characters.count % 2 == 0 else {
				throw Error.invalidCharacter
		}
		if let numberOfPairs = numberOfPairs {
			guard string.characters.count / 2 == numberOfPairs else {
				throw Error.incompletePair
			}
		}
	}
	
	struct Pair {
		let raw: UInt8
		init(raw: UInt8) {
			self.raw = raw
		}
		init(string: Swift.String) throws {
			try HexPairSequence.verify(string: string, numberOfPairs: 1)
			raw = UInt8(string, radix: 16)!
		}
		init(_ a: Character, _ b: Character) throws {
			try self.init(string: "\(a)\(b)")
		}
	}
	
	struct HexString {
		let string: String
		init(string: String) throws {
			try HexPairSequence.verify(string: string)
			self.string = string
		}
	}
	
	let hexPairString: HexString
	private var position = 0
	
	init(hexPairString: HexString) {
		self.hexPairString = hexPairString
	}
	
	init(string: String) throws {
		self.init(hexPairString: try HexString(string: string))
	}
	
	init(bytes: [UInt8]) {
		try! self.init(string: bytes.reduce("") {
			$0 + Swift.String(format: "%.2x", $1)
		})
	}
	
	func makeIterator() -> HexPairSequence.Iterator {
		return HexPairSequence(hexPairString: hexPairString)
	}
	
	mutating func next() -> Pair? {
		guard position < hexPairString.string.characters.count else {
			return nil
		}
		//At this point we know our string is a hex string so we can dispense with utf worries and treat as an array
		let chars = Array(hexPairString.string.characters)
		let pair = try! Pair(chars[position], chars[position + 1])
		position += 2
		return pair
	}
	
	func bytes() -> [UInt8] {
		return self.map { $0.raw }
	}
	
}
extension Array { //where Element: UInt8 {
	var hexString: String {
		return HexPairSequence(bytes: self as! [UInt8]).hexPairString.string
	}
}

extension String {
	func toHexBytes() throws -> [UInt8] {
		return try HexPairSequence(string: self).bytes()
	}
}


