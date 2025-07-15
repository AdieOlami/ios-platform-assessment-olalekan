//
//  Vehicle.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-15.
//

// MARK: - Vehicle

struct Vehicle: Codable, Equatable {
    let id: Int
    let name: String
    let model: String
    let year: String
    let make: String
    let status: String
    let location: String
    let customName: String
}
