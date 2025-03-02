//
//  CustomSVGDecoder.swift
//  CoinRankApp
//
//  Created by Aniket Patil on 02/03/25.
//

import Foundation
import UIKit
import SDWebImage

class CustomSVGDecoder: NSObject, SDImageCoder {

    let fallbackDecoder: SDImageCoder?

    init(fallbackDecoder: SDImageCoder?) {
        self.fallbackDecoder =  fallbackDecoder
    }

    static var regex: NSRegularExpression = {
        let pattern = "<image.*xlink:href=\"data:image\\/(png|jpg);base64,(.*)\"\\/>"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        return regex
    }()

    func canDecode(from data: Data?) -> Bool {
        guard let data = data, let string = String(data: data, encoding: .utf8) else { return false }
        guard Self.regex.firstMatch(in: string, range: NSRange(location: 0, length: string.utf16.count)) == nil else {
            print("CustomSVGDecoder: We can decode")
            return true //It self should decode
        }
        guard let fallbackDecoder = fallbackDecoder else {
            print("CustomSVGDecoder: Can't decode and there is no fallBack decoder")
            return false
        }
        print("CustomSVGDecoder: Will rely on fallback decoder to decode")
        return fallbackDecoder.canDecode(from: data)
    }

    func decodedImage(with data: Data?, options: [SDImageCoderOption : Any]? = nil) -> UIImage? {
        guard let data = data,
                let string = String(data: data, encoding: .utf8) else { return nil }
        guard let match = Self.regex.firstMatch(in: string, range: NSRange(location: 0, length: string.utf16.count)) else {
            print("CustomSVGDecoder: Will rely on fallback decoder to decode because of no match")
            return fallbackDecoder?.decodedImage(with: data, options: options)
        }
        guard let rawBase64DataRange = Range(match.range(at: 2), in: string) else {
            print("CustomSVGDecoder: Will rely on fallback decoder to decode because we didn't fiund the base64 part")
            return fallbackDecoder?.decodedImage(with: data, options: options)
        }
        let rawBase64Data = String(string[rawBase64DataRange])
        guard let imageData = Data(base64Encoded: Data(rawBase64Data.utf8), options: .ignoreUnknownCharacters) else {
            print("CustomSVGDecoder: Will rely on fallback decoder to decode because of invalid base64")
            return fallbackDecoder?.decodedImage(with: data, options: options)
        }
        return UIImage(data: imageData)
    }

    //You might need to implement these methods, I didn't check their meaning yet
    func canEncode(to format: SDImageFormat) -> Bool {
        print("CustomSVGDecoder: canEncode(to:)")
        return true
    }

    func encodedData(with image: UIImage?, format: SDImageFormat, options: [SDImageCoderOption : Any]? = nil) -> Data? {
        print("CustomSVGDecoder: encodedData(with:format:options:)")
        return nil
    }
}
