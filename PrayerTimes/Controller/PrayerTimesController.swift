//
//  ViewController.swift
//  Pryer Times
//
//  Created by Hivzi on 7/5/21.
//

import UIKit
import CoreLocation

class PrayerTimesController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var imsakuTimeLabel: UILabel!
    @IBOutlet weak var lindjaeDiellitTimeLabel: UILabel!
    @IBOutlet weak var drekaTimeLabel: UILabel!
    @IBOutlet weak var ikindiaTimeLabel: UILabel!
    @IBOutlet weak var akshamiTimeLabel: UILabel!
    @IBOutlet weak var jaciaTimeLabel: UILabel!
    
    
    var prayerTimesManager = PrayerTimesManager()
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        prayerTimesManager.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
//        showAlert()

    }
    
    
}
//MARK: - UITextFieldDelegate
extension PrayerTimesController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: Any) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "nuk keni shkruar asgje"
            return false  }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let city = searchTextField.text else { return }
        let s = city
        let modified = s.replacingOccurrences(of: " ", with: "-")
        prayerTimesManager.getPrayerTimes(cityName: modified)
        searchTextField.text = ""
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                do {
                    let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                    if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                        return false
                    }
                }
                catch {
                    print("ERROR")
                }
            return true
    }
}


//MARK: - PrayerTimesDelegate

extension PrayerTimesController: PrayerTimesDelegate {
    func updatePrayerTime(time: PrayerTimesModel) {
        
        DispatchQueue.main.async
        { 
           self.imsakuTimeLabel.text = time.imsakTime
           self.lindjaeDiellitTimeLabel.text = time.sunriseTime
           self.drekaTimeLabel.text = time.dhuhrTime
           self.ikindiaTimeLabel.text = time.asrTime
           self.akshamiTimeLabel.text = time.sunsetTime
           self.jaciaTimeLabel.text = time.ishaTime
       }
         
        }
    func showAlert() {
        DispatchQueue.main.async {

            let alert = UIAlertController(title: "Verejtje", message: "Nuk kemi te dhena per kete lokacion", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
}
}

    
    }


//MARK: - CLLocationManagerDelegate

extension PrayerTimesController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let alt = location.altitude
            
            prayerTimesManager.getPrayerTimes(latitude: lat, longitude: lon, altitude: alt)
            }
        }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                showAlert()
    }
    
    
    
}




    
    
