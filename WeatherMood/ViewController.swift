//
//  ViewController.swift
//  WeatherMood
//
//  Created by hyunsu on 2021/07/21.
//

import UIKit
import RxSwift
import RxCocoa
//import RxRelay

class ViewController: UIViewController {
    var button: UIButton = UIButton()
    var label: UILabel = UILabel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        label.backgroundColor = .green
        view.addSubview(label)
        view.addSubview(button)
        
        button.frame = CGRect(x: 200, y: 150, width: 100, height: 100)
        button.setTitle("버튼", for: .normal)
        button.rx.tap
          .subscribe(onNext: { [weak self] in
            self?.label.text = "dfnkajsndfk"
          }).disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
