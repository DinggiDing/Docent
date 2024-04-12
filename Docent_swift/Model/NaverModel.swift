//
//  NaverModel.swift
//  Docent_swift
//
//  Created by 성재 on 2022/10/19.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable, Identifiable, Hashable {
    let id = UUID()
    let title: String       // 제목
    let link: String        // 링크
    let image: String       // 썸네일 이미지
    let lprice, hprice: String      // 가격
    let mallName: String
    let productID, productType, brand: String
    let maker: String
    let category1, category2, category3, category4: String

    enum CodingKeys: String, CodingKey {
        case title, link, image, lprice, hprice
        case productID = "productId"
        case productType, brand
        case mallName, maker
        case category1, category2, category3, category4
    }
}

