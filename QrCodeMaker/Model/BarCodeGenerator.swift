//
//  BarCodeGenerator.swift
//  QrCode&BarCodeMizan
//
//  Created by Macbook pro 2020 M1 on 31/3/23.
//

import UIKit
import EANBarcodeGenerator
import RSBarcodes_Swift
import AVFoundation
import ZXingObjC
import BarCodeKit


class BarCodeGenerator {
    
    
    static func getBarCodeImage(type:String, value:String)->UIImage? { 
        
        if type.containsIgnoringCase(find: "EAN-13") {
            do {
                
                let barCode = try  BCKEAN13Code.init(content: value)
                let image = UIImage(barCode: barCode, options: nil)
                
                return image
            } catch {
                print(error)
            }
            
        }
        

        
        if type.containsIgnoringCase(find: "EAN-8") {
            do {
                
                let barCode = try  BCKEAN8Code.init(content: value)
                let image = UIImage(barCode: barCode, options: nil)
                return image
            } catch {
                print(error)
            }
            
        }

        if type.containsIgnoringCase(find: "upc-a") {
            do {
                
                let barCode = try  BCKUPCACode.init(content: value)
                let image = UIImage(barCode: barCode, options: nil)
                return image
            } catch {
                print(error)
            }
            
        }

        if type.containsIgnoringCase(find: "upc-e") {
            do {
                
                let barCode = try  BCKUPCECode.init(content: value)
                let image = UIImage(barCode: barCode, options: nil)
                return image
            } catch {
                print(error)
            }
            
        }

        if type.containsIgnoringCase(find: "39") {
            do {
                var imageValue =  RSUnifiedCodeGenerator.shared.generateCode(value, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue)
                Store.sharedInstance.shouldShowLabel = true
                if imageValue != nil {
                    if imageValue != nil {
                        imageValue =  RSAbstractCodeGenerator.resizeImage(imageValue!, scale: 5.0)
                        return imageValue!
                    }else{
                        return UIImage()
                    }
                }
                
            } catch {
                print(error)
            }
            
        }
        
        if  type.containsIgnoringCase(find:"128") {
            do {
                Store.sharedInstance.shouldShowLabel = true
                return generateBarCode(value)
            } catch {
                print(error)
            }
            
        }
        
        if type.containsIgnoringCase(find:"itf") ||   type.containsIgnoringCase(find:"2of5"){
            do {
                Store.sharedInstance.shouldShowLabel = true
                var imageValue =  RSUnifiedCodeGenerator.shared.generateCode(value, machineReadableCodeObjectType: AVMetadataObject.ObjectType.itf14.rawValue)
                if imageValue != nil {
                    if imageValue != nil {
                        imageValue =  RSAbstractCodeGenerator.resizeImage(imageValue!, scale: 5.0)
                        return imageValue!
                    }else{
                        return UIImage()
                    }
                }
                
                
            } catch {
                print(error)
            }
            
        }
        

        if type.containsIgnoringCase(find: "Matrix"),type.containsIgnoringCase(find: "data") {
            
            do {
                Store.sharedInstance.shouldShowLabel = true
                let writer = ZXMultiFormatWriter()
                let hints = ZXEncodeHints() as ZXEncodeHints
                let result = try writer.encode(value, format: kBarcodeFormatDataMatrix, width: 600, height: 600, hints: hints)
                
                if let imageRef = ZXImage.init(matrix: result) {
                    if let image = imageRef.cgimage {
                        return UIImage.init(cgImage: image)
                    }
                }
            }
            catch {
                print(error)
            }
            return nil
            
        }

        if type.containsIgnoringCase(find: "Aztec")  {
            do {
                Store.sharedInstance.shouldShowLabel = true
                return generateBarCodeAztech(value)
            } catch {
                print(error)
            }
        }

        if type.containsIgnoringCase(find: "417") {
            do {
                Store.sharedInstance.shouldShowLabel = true
                return generateBar417Barcode(value)
            } catch {
                print(error)
            }
        }
        return nil
        
    }
    
    
    static func generateDataMatrixQRCode(string: String, format: ZXBarcodeFormat) -> UIImage? {
        do {
            let writer = ZXMultiFormatWriter()
            let hints = ZXEncodeHints() as ZXEncodeHints
            let result = try writer.encode(string, format: format, width: 1000, height: 1000, hints: hints)
            
            if let imageRef = ZXImage.init(matrix: result) {
                if let image = imageRef.cgimage {
                    return UIImage.init(cgImage: image)
                }
            }
        }
        catch {
            print(error)
        }
        return nil
    }
    
    
}
