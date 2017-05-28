//
//  PokemonDetailVC.swift
//  PokeFinder
//
//  Created by Connor - Udemy on 2017-05-26.
//  Copyright © 2017 ConnorOgilvie. All rights reserved.
//

import UIKit
import AVFoundation

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var pokemonMusic: UIButton!
    
    //var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.pokemonName.capitalized
        
        let img = UIImage(named: String(pokemon.pokedexId))
        
        mainImg.image = img
        currentEvoImg.image = img
        pokedexLbl.text = String(pokemon.pokedexId)
        
        pokemon.downloadPokemonDeatils {
            
            // Whatever we write here will only be called after the network call is complete
            
            self.updateUI()
            
        }
        
        
        if GlobalVariables.musicPlayer.isPlaying {
            pokemonMusic.alpha = 1.0
        } else {
            pokemonMusic.alpha = 0.2
        }
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if GlobalVariables.musicPlayer.isPlaying {
            pokemonMusic.alpha = 1.0
        } else {
            pokemonMusic.alpha = 0.2
        }
        
    }
    
    func updateUI() {
        
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.pokemonDescription
        
        if pokemon.nextEvolutionID == "" {
            
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
            
        } else {
            
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionID)
            let str = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            evoLbl.text = str
        }
        
        
        
        
    }
    
    
    
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if GlobalVariables.musicPlayer.isPlaying {
            
            GlobalVariables.musicPlayer.pause()
            sender.alpha = 0.2
            
            //GlobalVariables.musicPlaying = false
            
        } else {
            
            GlobalVariables.musicPlayer.play()
            sender.alpha = 1.0
            
            //GlobalVariables.musicPlaying = true
        }
        
        
    }
    
    
    
    
}


