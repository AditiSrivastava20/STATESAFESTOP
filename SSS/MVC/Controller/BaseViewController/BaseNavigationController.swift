

import UIKit
import EZSwiftExtensions

class BaseNavigationController: ENSideMenuNavigationController, ENSideMenuDelegate {

    
    var viewBackground = UIView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewBackground.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        viewBackground.isHidden = true
        self.view.addSubview(viewBackground)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sideMenuVc = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
        
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: sideMenuVc!, menuPosition:.left)
        
        sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = UIScreen.main.bounds.width+2 // optional, default is 160
        sideMenu?.bouncingEnabled = false
        sideMenu?.allowPanGesture = true
        // make navigation bar showing over side menu
        //view.bringSubview(toFront: navigationBar)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
          changeDimView(isOpen: true)
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
         changeDimView(isOpen: false)
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
      
        
        
        
    }

    func changeDimView(isOpen : Bool){
        
        
      
        
        
        
        UIView.animate(withDuration: 1.0, animations: {
            self.viewBackground.isHidden = !isOpen
            
        })
        
    }

}
