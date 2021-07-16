//
//  UIImage+Extension.swift
//  BSBDJ
//
//  Created by apple on 2017/11/6.
//  Copyright © 2017年 incich. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 根据UIColor创建UIImage
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 图片大小
    /// - Returns: 图片
    static func creatImage(color: UIColor, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        let size = (size == CGSize.zero ? CGSize.init(width: 100, height: 100): size)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 获得圆图
    ///
    /// - Returns: cicleImage
    public func cicleImage() -> UIImage {
        
        // 开启图形上下文 false代表透明
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        // 获取上下文
        let ctx = UIGraphicsGetCurrentContext()
        // 添加一个圆
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        ctx?.addEllipse(in: rect)
        // 裁剪
        ctx?.clip()
        // 将图片画上去
        draw(in: rect)
        // 获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    func scaleImage(scaleSize:CGFloat) -> UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        let image = makeSizeImage(reSize)
        return image
    }
    
    /// img 尺寸
    ///
    /// - Returns: cicleImage
    func makeSizeImage(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size,false,UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
    func jpegDataValue(quality: CGFloat = 1.0) -> NSData? {
        return jpegData(compressionQuality: quality) as NSData?
    }
    
    /// 更改图片颜色
    public func changeColor(_ color : UIColor) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        color.setFill()
        
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIRectFill(bounds)
        
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = tintedImage else {
            return UIImage()
        }
        
        return image
    }
}

// MARK: Image转换
extension UIImage {
    
    /// Base64转UIImage
    ///
    /// - Parameter imageStr : Base64
    /// - returns: UIImage
    static func convertStrToImage(_ imageStr: String) -> UIImage?{
        if let data: NSData = NSData(base64Encoded: imageStr, options:NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        {
            if let image: UIImage = UIImage(data: data as Data)
            {
                return image
            }
        }
        return nil
    }
    
    /// UIImage转Base64
    ///
    /// - Parameter imageStr :
    static func getStrFromImage(_ imageStr: String) -> String{
        let imageOrigin = UIImage.init(named: imageStr)
        if let image = imageOrigin {
            let dataTmp = image.pngData()
            if let data = dataTmp {
                let imageStrTT = data.base64EncodedString()
                return imageStrTT
            }
        }
        return ""
    }
    
    /// CIImage转UIImage
    ///
    /// - Parameter ciImage: CIImage
    /// - returns: UIImage
    func convertCIImageToUIImage(ciImage: CIImage) -> UIImage {
        let uiImage = UIImage.init(ciImage: ciImage)
        return uiImage
    }
    
    /// CGImage转UIImage
    ///
    /// - Parameter cgImage: CGImage
    /// - returns: UIImage
    func convertCGImageToUIImage(cgImage: CGImage) -> UIImage {
        let uiImage = UIImage.init(cgImage: cgImage)
        return uiImage
    }
    
    /// CGImage转CIImage
    ///
    /// - Parameter cgImage: input CGImage
    /// - Returns: CIImage
    func convertCGImageToCIImage(cgImage: CGImage) -> CIImage{
        return CIImage.init(cgImage: cgImage)
    }
    
    /// CIImage转CGImage
    ///
    /// - Parameter ciImage: input CIImage
    /// - Returns: CGImage
    func convertCIImageToCGImage(ciImage: CIImage) -> CGImage{
        let ciContext = CIContext.init()
        let cgImage:CGImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
        return cgImage
    }
    
    /// UIImage转为CIImage
    ///
    /// - Parameter uiImage: input UIImage
    /// - Returns: CIImage
    func convertUIImageToCIImage(uiImage: UIImage) -> CIImage {
        
        var ciImage = uiImage.ciImage
        if ciImage == nil {
            let cgImage = uiImage.cgImage
            ciImage = self.convertCGImageToCIImage(cgImage: cgImage!)
        }
        return ciImage!
    }
    
    /// UIImage转为CGImage
    ///
    /// - Parameter uiImage: input UIImage
    /// - Returns: CGImage
    func convertUIImageToCGImage(uiImage: UIImage) -> CGImage {
        var cgImage = uiImage.cgImage
        
        if cgImage == nil {
            let ciImage = uiImage.ciImage
            cgImage = self.convertCIImageToCGImage(ciImage: ciImage!)
        }
        return cgImage!
    }
    
    /// UIImage转为Data
    ///
    /// - Parameter uiImage: input UIImage
    /// - Returns: Data
    func convertUIImageToData(uiImage: UIImage) -> Data {
        var data = uiImage.pngData()
        if data == nil {
            let cgImage = self.convertUIImageToCGImage(uiImage: uiImage)
            let uiImage_ = UIImage.init(cgImage: cgImage)
            data = uiImage_.pngData()
        }
        return data!
    }
    
    
}
