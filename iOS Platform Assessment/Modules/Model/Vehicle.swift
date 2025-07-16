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
    let year: Int
    let make: String
    let vehicleStatusName: String?
    let location: String?
    let customName: String?
}

// MARK: - VehicleListData

struct VehicleListData: Codable {
    let startCursor: String
    let nextCursor: String
    let perPage: Int
    let estimatedRemainingCount: Int
    let records: [Vehicle]
}

// MARK: - VehicleListData

struct VehicleListQuery: Codable {
    let startCursor: String?
    let perPage: Int?
}
