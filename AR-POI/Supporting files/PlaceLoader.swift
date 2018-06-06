//
//  PlaceLoader.swift
//  AR-POI
//
//  Created by Jamie Perkins on 9/26/17.
//  Copyright © 2017 Inorganik Produce, Inc. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

struct PlaceLoader {

    // request POIs around user's location with google maps search
//    func requestPOIsWithGoogleSearch(term: String, location: CLLocation, completion: @escaping (_ items:[[String: Any]]?, _ errorMsg:String?) -> Void) {
//
//        let gMapsUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
//        let radiusMeters = 5000
//        let language = "en"
//
//        let params = [
//            "location": "\(location.coordinate.latitude),\(location.coordinate.longitude)",
//            "radius": radiusMeters,
//            "keyword": term,
//            "language": language,
//            "key": googleApiKey
//            ] as [String: Any]
//        var uri = gMapsUrl
//        let queryString = serializeParamsForRequest(params: params)
//        uri = uri + queryString
//        let url = URL(string: uri)!
//        let request = NSMutableURLRequest(url: url)
//
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
//
//            DispatchQueue.main.async(execute: {
//                if let err = error {
//                    print("request error:", err.localizedDescription)
//                }
//                else if let httpResponse = response as? HTTPURLResponse {
//                    if httpResponse.statusCode == 200 {
//                        do {
//                            let responseObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//                            guard let responseDict = responseObject as? NSDictionary else {
//                                return
//                            }
//                            if let respDict = responseDict as? [String: Any], let status = respDict["status"] as? String {
//                                if status == "OK", let results = respDict["results"] as? [[String: Any]] {
//                                    completion(results, nil)
//                                }
//                                else {
//                                    completion(nil, status)
//                                }
//                            }
//                            else {
//                                let errMsg = "request  empty response"
//                                print("\(errMsg)")
//                                completion(nil, errMsg)
//                            }
//                        }
//                        catch {
//                            completion(nil, error.localizedDescription)
//                        }
//                    }
//                    else {
//                        let errMsg = "request failed with code: \(httpResponse.statusCode)"
//                        print(errMsg)
//                        completion(nil, errMsg)
//                    }
//                }
//            })
//        }
//        dataTask.resume()
//    }

    // static POIs for testing
    func getStaticPOIsFor(location: CLLocation, completion: @escaping (_ items:[[String: Any]]?, _ errorMsg:String?) -> Void) {

        var returnPOIs = [[String: Any]]()

        // let galvanize = generatePOIDictFor(title: "Galvanize", location: CLLocation(latitude: 40.016862, longitude: -105.281685))
        // returnPOIs.append(galvanize)
        // let home = generatePOIDictFor(title: "Home", location: CLLocation(latitude: 40.016322, longitude: -105.272385))
        // returnPOIs.append(home)
        let bwaymaxwell = generatePOIDictFor(title: "Broadway & Maxwell Ave", location: CLLocation(latitude: 40.021498, longitude: -105.281295))
        returnPOIs.append(bwaymaxwell)
        let bwayspruce = generatePOIDictFor(title: "Broadway & Spruce St", location: CLLocation(latitude: 40.018459, longitude: -105.280279))
        returnPOIs.append(bwayspruce)
        let bwaywalnut = generatePOIDictFor(title: "Broadway & Walnut Blvd", location: CLLocation(latitude: 40.017152, longitude: -105.27965))
        returnPOIs.append(bwaywalnut)
        let bwaycanyon = generatePOIDictFor(title: "Broadway & Canyon Blvd", location: CLLocation(latitude: 40.016322, longitude: -105.278986))
        returnPOIs.append(bwaycanyon)
        let bwayarapahoe = generatePOIDictFor(title: "Broadway & Arapahoe", location: CLLocation(latitude: 40.016322, longitude: -105.278986))
        returnPOIs.append(bwayarapahoe)
        let bwayuniversity = generatePOIDictFor(title: "Broadway & University Ave", location: CLLocation(latitude: 40.009841, longitude: -105.27658))
        returnPOIs.append(bwayuniversity)
        let bwaycollege = generatePOIDictFor(title: "Broadway & College Ave", location: CLLocation(latitude: 40.007812, longitude: -105.275329))
        returnPOIs.append(bwaycollege)
        let bwayeuclid = generatePOIDictFor(title: "Broadway & Euclid Ave", location: CLLocation(latitude: 40.016322, longitude: -105.278986))
        returnPOIs.append(bwayeuclid)
        let bway20 = generatePOIDictFor(title: "Broadway & 20th St", location: CLLocation(latitude: 40.003173, longitude: -105.267222))
        returnPOIs.append(bway20)
        let bwaybaseline = generatePOIDictFor(title: "Broadway & Baseline Rd", location: CLLocation(latitude: 39.999344, longitude: -105.263297))
        returnPOIs.append(bwaybaseline)


        if returnPOIs.count > 0 {
            completion(returnPOIs, nil)
        }
        else {
            completion(nil, "no POIs")
        }
    }

    // MARK: - Utility methods

    func generatePOIDictFor(title: String, location: CLLocation) -> [String: Any] {
        let poi = [
            "name": title,
            "geometry": [
                "location": [
                    "lat": location.coordinate.latitude,
                    "lng": location.coordinate.longitude
                    ] as [String: Any]
                ] as [String: Any]
            ] as [String: Any]
        return poi
    }

    // extract CLLocation from dict
    func getLocationFrom(dict: [String: Any]) -> CLLocation? {

        if let locObj = dict["location"] {
            let locDict = locObj as! [String: Any]
            let latNum = locDict["lat"] as! NSNumber
            let lat = latNum.doubleValue
            let longNum = locDict["lng"] as! NSNumber
            let long = longNum.doubleValue
            let location = CLLocation(latitude: lat, longitude: long)
            return location
        }
        else {
            return nil
        }
    }

    func serializeParamsForRequest(params: [String: Any]) -> String {
        var paramArray = [String]()
        for (key, val) in params {
            let stringifiedVal = "\(val)"
            if key.isEmpty {
                paramArray.append(stringifiedVal)
            }
            else if let escaped: String = stringifiedVal.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                let pair = "\(key)=\(escaped)"
                paramArray.append(pair)
            }
        }
        return paramArray.joined(separator: "&")
    }

    // turn meters into relatable distance
    func metersToRecognizableString(meters: Double) -> (String, String) {

        let METERS_TO_FEET: Double = 3.2808399
        let FEET_TO_MILES: Double = 5280
        let FOOTBALL_FIELD: Double = 300

        let distance: Double = meters * METERS_TO_FEET;
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if (distance < FOOTBALL_FIELD) {
            formatter.maximumFractionDigits = 0
            let formatted = formatter.string(from: NSNumber(value:distance));
            return (String(format: "%@", formatted!), "feet")
        }
        else {
            formatter.maximumFractionDigits = 1
            let miles = distance / FEET_TO_MILES
            let formatted = formatter.string(from: NSNumber(value:miles))
            return (String(format: "%@", formatted!), "miles")
        }
    }
}
