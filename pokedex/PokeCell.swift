//
//  PokeCell.swift
//  pokedex
//
//  Created by Devin on 6/2/16.
//  Copyright © 2016 hantian. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    func settingCell(pokemon: Pokemon) {
        
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalizedString
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
}