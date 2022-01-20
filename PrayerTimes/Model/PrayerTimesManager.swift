//
//  PrayerTimesManager.swift
//  Pryer Times
//
//  Created by Hivzi on 7/12/21.
//

import Foundation
import CoreLocation
import UIKit

protocol PrayerTimesDelegate {
    func updatePrayerTime(time: PrayerTimesModel)
    func showAlert()
}

struct PrayerTimesManager {
    let apiURL = "https://api.pray.zone/v2/times/today.json?"
    
    var delegate: PrayerTimesDelegate?
    
    func getPrayerTimes(cityName: String) {
        let stringURL = "\(apiURL)city=\(cityName)"
         request(path: stringURL)
    }
    
    func  getPrayerTimes(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDegrees) {
        let stringURL = "\(apiURL)longitude=\(longitude)&latitude=\(latitude)&elevation=\(altitude)"
        request(path: stringURL)
    }
    
    
    
        func request(path: String){
        guard let url = URL(string: path) else { return }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data: Data?, respense: URLResponse?, error: Error?) in
            if error != nil {
                
            }
            guard let safeData = data else { return }
//            guard let stringData = String(data: safeData, encoding: .utf8) else {return}
            
            if let prayerTimes =   parseJSON(prayerData: safeData) {
                self.delegate?.updatePrayerTime(time: prayerTimes)
            }
}
        task.resume()
}
    
     func parseJSON(prayerData: Data) -> PrayerTimesModel? {
     do {
        let decodedData =  try JSONDecoder().decode(PrayerTimesData.self, from: prayerData)
    
             let imask = decodedData.results.datetime[0].times.Imsak
            let sunrise = decodedData.results.datetime[0].times.Sunrise
            let dhuhr = decodedData.results.datetime[0].times.Dhuhr
            let asr = decodedData.results.datetime[0].times.Asr
             let sunset = decodedData.results.datetime[0].times.Sunset
            let  isha = decodedData.results.datetime[0].times.Isha
            
           let prayerTimes = PrayerTimesModel(imsakTime: imask, sunriseTime: sunrise, dhuhrTime: dhuhr, asrTime: asr, sunsetTime: sunset, ishaTime: isha)
         return prayerTimes
         }
     catch {
        self.delegate?.showAlert()
          return nil
          }
     }
    
}
