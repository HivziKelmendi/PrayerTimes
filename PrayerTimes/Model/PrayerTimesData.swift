//
//  PrayerTimesData.swift
//  Pryer Times
//
//  Created by Hivzi on 7/16/21.
//

import Foundation
struct PrayerTimesData: Decodable {
    let status: String
    let results: Results
}

struct Results: Decodable {
    let datetime: [DateTime]
}

struct DateTime: Decodable {
     let times: Times
}

struct Times: Decodable {
    let Imsak: String
    let Sunrise: String
    let Dhuhr: String
    let Asr: String
    let Sunset: String
    let Isha: String
}
