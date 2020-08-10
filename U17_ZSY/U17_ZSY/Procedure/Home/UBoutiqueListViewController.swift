//
//  UBoutiqueListViewController.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/10.
//  Copyright © 2020 LEPU. All rights reserved.
/*
 推荐
 */

import UIKit

class UBoutiqueListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("推荐")
        view.backgroundColor = UIColor.random
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        navigationController?.pushViewController(TestVC(), animated: true)
        
    }
    
}
