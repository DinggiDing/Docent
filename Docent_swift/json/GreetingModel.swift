//
//  GreetingModel.swift
//  Docent_swift
//
//  Created by 성재 on 2022/10/23.
//

import Foundation

// MARK: - WelcomeElement
struct GreetingModel: Codable {
    let tone, sent: String
}

typealias Greeting = [GreetingModel]
