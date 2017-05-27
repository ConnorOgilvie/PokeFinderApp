//
//  PokedexVC.swift
//  PokeFinder
//
//  Created by Connor - Udemy on 2017-05-26.
//  Copyright © 2017 ConnorOgilvie. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class PokedexVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var showDetailsBtn: RoundButton!
    @IBOutlet weak var dropPokemonBtn: RoundButton!
    
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    var selectedRow = Int()
    var pokemonID = Int()
    var location: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
        
        print("CONNOR TEST: \(GlobalVariables.listOfPokemon)")
        
        print("CONNOR: \(location)")
    }
    
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 //means it will loop continuously
            musicPlayer.play()
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }
    
    // might be able to edit this/remove this being that I can do this in VDL of PokeFinderVC
    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            //print(rows)
            
            for row in rows {
                
                let pokeId = Int(row["id"]!)!
                let pokemonName = row["identifier"]!
                
                let poke = Pokemon(pokemonName: pokemonName, pokedexId: pokeId)
                pokemon.append(poke)
                GlobalVariables.listOfPokemon.append(pokemonName)
            }
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            
            if inSearchMode {
                
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
                
            } else {
                
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
                
            }
            
            
            return cell
            
        } else {
            
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        showDetailsBtn.isHidden = false
        dropPokemonBtn.isHidden = false
        
        var pokemonName: String!
        
        
        if inSearchMode {
            
            pokemonName = filteredPokemon[selectedRow].pokemonName.capitalized
            pokemonID = filteredPokemon[selectedRow].pokedexId
            
        } else {
            
            pokemonName = pokemon[selectedRow].pokemonName.capitalized
            pokemonID = pokemon[selectedRow].pokedexId
            
        }
        
        showDetailsBtn.setTitle("\(pokemonName!) Details", for: .normal)
        dropPokemonBtn.setTitle("Drop \(pokemonName!)", for: .normal)
        
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            
            return filteredPokemon.count
            
        }
        return pokemon.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 105, height: 105)
    }
    
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            
            musicPlayer.pause()
            sender.alpha = 0.2
            
        } else {
            
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
            
        } else {
            
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({$0.pokemonName.range(of: lower) != nil})
            collection.reloadData()
        }
        
    }
    
    @IBAction func showPokemonDetailsTapped(_ sender: RoundButton) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            
            poke = filteredPokemon[selectedRow]
            
        } else {
            
            poke = pokemon[selectedRow]
            
        }
        
        performSegue(withIdentifier: "toPokemonDetailVC", sender: poke)
        
    }
    
    @IBAction func choosePokemonToDropToMapTapped(_ sender: RoundButton) {
        
        // START OFF HERE: TODO: PASS BACK LOCATION AND ID OF POKEMON TO POST. ALSO, NEED TO SOMEHOW MERGE POKEANNOTATION AND POKEMON MODEL CLASSES. USE SOME SORT OF BOOLEAN VALUE TO POST AUTOMATICALLY FROM POKEFINDERVC WHEN IT LOADS BY CALLING CREATESIGHTNG METHOD IN VIEWDIDLOAD AND ONLY PASS IN VALUES IF POKEMON HAS BEEN SELECTED, NOTIFIED BY BOOLEAN VALUE
        
        
        //performSegue(withIdentifier: "toPokeFinderVC", sender: pokemonID)
        
        // NEED TO FIND A WAY TO SET THE postPOKEMON to TRUE.
        let pokePost = PokeFinderVC()
        pokePost.pokemonID = self.pokemonID
        pokePost.postPokemon = true
        
        print("Connor: Pokedex: \(pokePost.pokemonID), \(pokePost.postPokemon)")
        
      dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPokemonDetailVC" {
            
            if let detailsVC = segue.destination as? PokemonDetailVC {
                
                if let poke = sender as? Pokemon {
                    
                    detailsVC.pokemon = poke
                }
            }
        }
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "toPokeFinderVC" {
//            
//            if let postPoke = segue.destination as? PokeFinderVC {
//                
//                if let pokemonID = sender as? Int {
//                    
//                    postPoke.pokemonID = pokemonID
//                }
//            }
//        }
//        
//    }
    
    
    
    
    
    
}
