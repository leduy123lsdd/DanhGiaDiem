//
//  ViewController.swift
//  test
//
//  Created by Lê Duy on 7/24/19.
//  Copyright © 2019 Lê Duy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    //MARK: - Variables
    var diem_mieng:String = ""
    var diem_giuaKi:String = ""
    var diem_cuoiKi:String = ""
    
    let diemMieng: UITextField = {
        let textField = UITextField()
        textField.setupStyleAndLayout()
        textField.placeholder = "Nhập điểm miệng. Ví dụ: 8.5  9  10"
        return textField
    }()
    
    let diemGiuaKi: UITextField = {
        let textField = UITextField()
        textField.setupStyleAndLayout()
        textField.placeholder = "Nhập điểm giữa kỳ"
        return textField
    }()
    
    let diemCuoiKi: UITextField = {
        let textField = UITextField()
        textField.setupStyleAndLayout()
        textField.placeholder = "Nhập điểm cuôi kỳ"
        return textField
    }()
    
    let validateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Ấn để đánh giá", for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor  = UIColor(red: 190/255, green: 9/255, blue: 38/255, alpha: 1)
        button.titleLabel?.font  = UIFont(name: "AvenirNext-DemiBold", size: 18)
        button.layer.cornerRadius = 10
        button.layer.borderWidth  = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    let renewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Xóa", for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor  = UIColor(red: 40/255, green: 157/255, blue: 64/255, alpha: 1)
        button.titleLabel?.font  = UIFont(name: "AvenirNext-DemiBold", size: 18)
        button.layer.cornerRadius = 10
        button.layer.borderWidth  = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    let result: UITextView = {
        let rs = UITextView()
        rs.translatesAutoresizingMaskIntoConstraints = false
        rs.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        rs.text = "Kết quả đánh giá.."
        rs.layer.cornerRadius = 8
        rs.layer.borderWidth = 2
        rs.font = UIFont.systemFont(ofSize: 20)
        rs.layer.borderColor = UIColor.white.cgColor
        rs.isEditable = false
        rs.textAlignment = NSTextAlignment.justified
        rs.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 10)
        
        return rs
    }()
    
    //MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        [diemMieng,diemCuoiKi,diemGiuaKi,validateButton,result,renewButton].forEach {view.addSubview($0)}
        setupLayout()
        
        diemMieng.delegate = self
        diemCuoiKi.delegate = self
        diemGiuaKi.delegate = self
        
        validateButton.addTarget(self, action: #selector(validateTapped), for: .touchUpInside)
        renewButton.addTarget(self, action: #selector(renewTapped), for: .touchUpInside)
        
    }
    
    //MARK: - Button function
    @objc func renewTapped() {
        diemGiuaKi.text = ""
        diemCuoiKi.text = ""
        diemMieng.text = ""
        result.text = "Kết quả đánh giá."
        
        diemGiuaKi.endEditing(true)
        diemCuoiKi.endEditing(true)
        diemMieng.endEditing(true)
        
    }
    
    @objc func validateTapped() {
        var alertString: String = ""
        view.endEditing(true)
        
        diem_giuaKi = diemGiuaKi.text ?? ""
        diem_mieng = diemMieng.text ?? ""
        diem_cuoiKi = diemCuoiKi.text ?? ""
        
        if diem_mieng == "" || diem_giuaKi == "" || diem_cuoiKi == "" {
            if diem_mieng == "" { alertString += "Chưa nhập điểm miệng.\n" }
            if diem_giuaKi == "" { alertString += "Chưa nhập điểm giữa kỳ.\n" }
            if diem_cuoiKi == "" { alertString += "Chưa nhập điểm cuối kỳ.\n" }
            result.text = alertString
            return
        }
        
        var listMieng = [Float]()
        var miengTB : Float = 0.0
        var hs1: Float = 0.0
        
        var listGiuaKy = [Float]()
        var giuakyTB : Float = 0.0
        var hs2: Float = 0.0
        
        var listCuoiKy = [Float]()
        var cuoikyTB : Float = 0.0
        var hs3: Float = 0.0
        
        for index in diem_mieng.split(separator: " ") {
            let score = Float(index) ?? 0.0
            listMieng.append(score)
            miengTB += score
            hs1+=1
        }
        
        for index in diem_giuaKi.split(separator: " ") {
            let score = Float(index) ?? 0.0
            listGiuaKy.append(score)
            giuakyTB += score
            hs2+=1
        }
        
        for index in diem_cuoiKi.split(separator: " ") {
            let score = Float(index) ?? 0.0
            listCuoiKy.append(score)
            cuoikyTB += score
            hs3+=1
        }
        
        miengTB = miengTB / hs1
        giuakyTB = (giuakyTB * 2.0) / hs2
        cuoikyTB = (cuoikyTB * 3.0) / hs3
    
        let averageCoreResult = (miengTB + giuakyTB + cuoikyTB) / 6.0
        
        //danh gia hoc sinh
        if averageCoreResult >= 8.5 && hs1 >= 1 && hs2 >= 2 && miengTB >= 7 && giuakyTB >= 7 && cuoikyTB >= 7 {
            result.text = "Điểm trung bình: \(averageCoreResult)\nXếp loại: Giỏi."
        } else if averageCoreResult >= 7 && giuakyTB >= 8 && cuoikyTB >= 8 {
            result.text = "Điểm trung bình: \(averageCoreResult)\nXếp loại: Khá."
        } else {
            result.text = "Điểm trung bình: \(averageCoreResult)\nXếp loại: Trung bình."
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: " ")
        return string == numberFiltered
    }
    
    //MARK: - setup layout
    func setupLayout() {
        
        self.view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: diemMieng)
        self.view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: diemGiuaKi)
        self.view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: diemCuoiKi)
        self.view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: result)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-[v1(100)]-10-|", views: validateButton,renewButton)
        
        self.view.addConstraintsWithFormat(format: "V:|-50-[v0(50)]-20-[v1(50)]-20-[v2(50)]-25-[v3(60)]-25-[v4]-50-|", views: diemMieng, diemGiuaKi, diemCuoiKi, validateButton, result)
        self.view.addConstraintsWithFormat(format: "V:[v0]-25-[v1(60)]", views: diemCuoiKi, renewButton)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index,view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: format,
            options: NSLayoutConstraint.FormatOptions.init(),
            metrics: nil, views: viewsDictionary)
        )
    }
}


extension UITextField {
    func setupStyleAndLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.2
        layer.cornerRadius = 10
        tintColor = .black
        backgroundColor = .white
        keyboardType = .numbersAndPunctuation
        font = UIFont.systemFont(ofSize: 20)
        text = ""
        clearButtonMode = UITextField.ViewMode.whileEditing
    }
    
}

