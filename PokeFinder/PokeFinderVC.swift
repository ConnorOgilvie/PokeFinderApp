//
//  ViewController.swift
//  PokeFinder
//
//  Created by Connor - Udemy on 2017-04-04.
//  Copyright © 2017 ConnorOgilvie. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class PokeFinderVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var geoFire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    var pokemonToPost = [""]
    var pokemonID = Int()
    var postPokemon: Bool!
    var postLocation = CLLocation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        geoFireRef = FIRDatabase.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        
        parsePokemonCSV()
        
        postPokemon = false
        
        print("CONNOR: Global Variable: \(GlobalVariables.listOfPokemon) AND \(GlobalVariables.pokemonNameToPost)")
        
    }
    
    // CODE FOR MAP VIEW
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
        
        if GlobalVariables.pokemonNameToPost != "" {
            postPokemon = true
            pokemonID = GlobalVariables.pokemonID
        }
        
        if postPokemon {
            print("CONNOR: GOT HERE, SHOULD POST")
            createSighting(forLocation: postLocation, withPokemon: pokemonID)
            // now reset everything here
            GlobalVariables.pokemonNameToPost = ""
            GlobalVariables.pokemonID = 0
        }
        
        print("CONNOR: VIEW DID APPEAR CALLED, postPokemon is FALSE")
    }
    
    
    
    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            //print(rows)
            
            for row in rows {
                
               // let pokeId = Int(row["id"]!)!
                let pokemonName = row["identifier"]!
                
//                let poke = Pokemon(pokemonName: pokemonName, pokedexId: pokeId)
//                pokemon.append(poke)
                GlobalVariables.listOfPokemon.append(pokemonName)
            }
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }

    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        
    }
    
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if let location = userLocation.location {
            
            if !mapHasCenteredOnce {
                centerMapOnLocation(location: location)
                mapHasCenteredOnce = true
                
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annoIdentifier = "Pokemon"
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            
            annotationView?.image = UIImage(named: "ash")
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
            
            annotationView = deqAnno
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView, let anno = annotation as? PokeAnnotation {
            
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "\(anno.pokemonNumber)")
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
            // Put a button here that will say "view details". Pokemon details will then pop up via alamoFire. Need to learn more about annotations in apple maps
//            let btn1 = UIButton()
//            btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//            btn1.setImage(UIImage(named: "map"), for: .normal)
//            annotationView.leftCalloutAccessoryView = btn1
        }
        
        return annotationView
        
    }
    
    func createSighting(forLocation location: CLLocation, withPokemon pokeId: Int) {
        
        geoFire.setLocation(location, forKey: "\(pokeId)")
        
    }
    
    func showSightingsOnMap(location: CLLocation) {
        
        let circleQuery = geoFire.query(at: location, withRadius: 2.5)
        
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            
            if let key = key, let location = location {
                let anno = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
                self.mapView.addAnnotation(anno)
            }
        })
        
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        showSightingsOnMap(location: location)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // have 2 if lets, second one being if let anno = view.annotation as? PokemonDetails - Need to learn more about annotations in Apple Maps
        if let anno = view.annotation as? PokeAnnotation {
            
            var place: MKPlacemark!
            if #available(iOS 10.0, *) {
                place = MKPlacemark(coordinate: anno.coordinate)
            } else {
                place = MKPlacemark(coordinate: anno.coordinate, addressDictionary: nil)
            }
        
            let destination = MKMapItem(placemark: place)
            destination.name = "Pokemon Sighting"
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
            
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking] as [String : Any]
            
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPokedexVC" {
            
            if let pokedexVC = segue.destination as? PokedexVC {
                
                if let location = sender as? CLLocation {
                    
                    pokedexVC.location = location
                }
            }
        }
        
    }
    
    
    


    @IBAction func spotRandomPokemon(_ sender: UIButton) {
        
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        // Change below to bring up pokedex to select a pokemon to use
        
       // let rand = arc4random_uniform(151) + 1
       // createSighting(forLocation: location, withPokemon: Int(rand))
        
        postLocation = location
        
        //will send location
        performSegue(withIdentifier: "toPokedexVC", sender: location)
        
        
    }

}

