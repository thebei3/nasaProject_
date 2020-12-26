//
//  ViewController.swift
//  nasaProject
//
//  Created by orhun akmil on 24.12.2020.
//

import UIKit
import Alamofire
import SwiftyJSON


class mainScreenViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    
    //Outlets
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelLoading: UILabel!
    @IBOutlet weak var tabItem: UITabBarItem!
    @IBOutlet weak var collectionViewNasaImage: UICollectionView!
    
    //Variables
    let popUpViewInfo = popUpView()
    let filterViewPopUp = filterView()
    var selectedUrl = ""
    var data = JSON()
    var nasaObjectArray = [nasaObject]()
    var ShowingArray = [nasaObject]()
    var elementCount = Int()
    var downloaded = false
    let key = keys()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if tabItem.title == key.Opportunity {
            selectedUrl = key.urlOpportunity
        } else if tabItem.title == key.Curiosity {
            selectedUrl = key.urlCuriosity
        } else if tabItem.title == key.Spirit {
            selectedUrl = key.urlSpirit
        }
        
        setViews()
        collectionViewNasaImage.delegate = self
        collectionViewNasaImage.dataSource = self
        collectionViewNasaImage.isHidden = true
        getDataFromNasa()
        setPopUpView()
        setFilterView()
    }
    
    func setFilterView() {
        
        
        view.addSubview(filterViewPopUp)
        filterViewPopUp.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([filterViewPopUp.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
            ,filterViewPopUp.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ,filterViewPopUp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ,filterViewPopUp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)])


        filterViewPopUp.viewHeader.addBottomBorderWithColor(color: .black, width: 0.5)
        filterViewPopUp.button1.addTarget(self, action: #selector(filterButtonClicked(sender:)), for:UIControl.Event.touchUpInside)
        filterViewPopUp.button2.addTarget(self, action: #selector(filterButtonClicked(sender:)), for:UIControl.Event.touchUpInside)
        filterViewPopUp.button3.addTarget(self, action: #selector(filterButtonClicked(sender:)), for:UIControl.Event.touchUpInside)
        filterViewPopUp.button4.addTarget(self, action: #selector(filterButtonClicked(sender:)), for:UIControl.Event.touchUpInside)
        filterViewPopUp.button5.addTarget(self, action: #selector(filterButtonClicked(sender:)), for:UIControl.Event.touchUpInside)
        filterViewPopUp.button6.addTarget(self, action: #selector(filterButtonClicked(sender:)), for:UIControl.Event.touchUpInside)
        filterViewPopUp.button7.addTarget(self, action: #selector(filterButtonClicked(sender:)), for:UIControl.Event.touchUpInside)
        filterViewPopUp.button8.addTarget(self, action: #selector(filterButtonClicked(sender:)), for:UIControl.Event.touchUpInside)
        filterViewPopUp.button9.addTarget(self, action: #selector(filterButtonClicked(sender:)), for:UIControl.Event.touchUpInside)
        filterViewPopUp.button10.addTarget(self, action: #selector(filterButtonClicked(sender:)), for:UIControl.Event.touchUpInside)

        filterViewPopUp.alpha = 0
        filterViewPopUp.layer.borderWidth = 0.5
        filterViewPopUp.layer.borderColor = UIColor.lightGray.cgColor
        filterViewPopUp.backgroundColor = .black
        filterViewPopUp.layer.cornerRadius = 10
        
    }
    
    func setViews() {
        buttonFilter.isUserInteractionEnabled = false
        progressView.transform = CGAffineTransform(scaleX: 1, y: 4)
        labelLoading.layer.zPosition = 2
        popUpViewInfo.layer.zPosition = 3
    }
    
    func setPopUpView() {
        
        view.addSubview(popUpViewInfo)
        popUpViewInfo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([popUpViewInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
            ,popUpViewInfo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ,popUpViewInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ,popUpViewInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)])

        
        popUpViewInfo.closeButton.addTarget(self, action: #selector(closeClicked(sender:)), for:UIControl.Event.touchUpInside)
        popUpViewInfo.alpha = 0
        popUpViewInfo.layer.borderWidth = 0.5
        popUpViewInfo.layer.borderColor = UIColor.lightGray.cgColor
        popUpViewInfo.backgroundColor = .black
        popUpViewInfo.layer.cornerRadius = 10
        
    }
    
    @IBAction func filterClicked(_ sender: Any) {
        collectionViewNasaImage.isUserInteractionEnabled = false
        filterViewPopUp.alpha = 1
        popUpViewInfo.alpha = 0
        labelLoading.isHidden = true
        labelLoading.text = "Yükleniyor.."
    }
    
    
    @objc func filterButtonClicked(sender:Any) {
        let button = sender as! UIButton
        collectionViewNasaImage.isUserInteractionEnabled = true
        filterViewPopUp.alpha = 0
        
        ShowingArray.removeAll()
        
        if button.titleLabel?.text == "Hepsi" {
            ShowingArray=nasaObjectArray
            collectionViewNasaImage.reloadData()
        } else {
            for element in nasaObjectArray where element.cameraName == button.titleLabel?.text {
                ShowingArray.append(element)
                collectionViewNasaImage.reloadData()
            }
            
            if ShowingArray.isEmpty {
                labelLoading.text = "Aradığınız Filtre için sonuç bulunamadı."
                labelLoading.isHidden = false
            }
            collectionViewNasaImage.reloadData()

        }
    }
    
    @objc func closeClicked(sender:Any) {
        popUpViewInfo.alpha = 0
    }
    
    func initializeObjects() {

        var index = 0
        DispatchQueue.global(qos: .utility).async { [self] in

        repeat {
            let nasa = nasaObject()
            nasa.imageUrl = data[key.photos][index][key.img_src].string ?? ""
            DispatchQueue.main.async {
                nasa.imageView = UIImageView()
                downloadImage(from: URL(string: nasa.imageUrl)!, imageView: nasa.imageView!)
            }
            nasa.dateOfPhotoCapture = data[key.photos][index][key.earth_date].string ?? ""
            nasa.cameraName = data[key.photos][index][key.camera][key.name].string ?? ""
            nasa.missionStatus = data[key.photos][index][key.rover][key.status].string ?? ""
            nasa.name = data[key.photos][index][key.rover][key.name].string ?? ""
            nasa.launchDate = data[key.photos][index][key.rover][key.launch_date].string ?? ""
            nasa.landingDate = data[key.photos][index][key.rover][key.landing_date].string ?? ""

            nasaObjectArray.append(nasa)
            ShowingArray.append(nasa)
            index+=1

        } while index != data[key.photos].count

        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ShowingArray.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: key.reuseIdentifier, for: indexPath) as! nasaImageCollectionViewCell
        cell.imageView.image = ShowingArray[indexPath.row].imageView?.image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let clickedItem = ShowingArray[indexPath.row]
        popUpViewInfo.imageView.image = clickedItem.imageView?.image
        popUpViewInfo.name.text = "isim: " + clickedItem.name
        popUpViewInfo.dateOfPhotoCapture.text = "Çekilme tarihi: " + clickedItem.dateOfPhotoCapture
        popUpViewInfo.missionStatus.text = "Görev durumu: " + clickedItem.missionStatus
        popUpViewInfo.cameraName.text = "Kamera adı: " + clickedItem.cameraName
        popUpViewInfo.launchDate.text = "Fırlatma tarihi: " + clickedItem.launchDate
        popUpViewInfo.landingDate.text = "İniş tarihi: " + clickedItem.landingDate
        popUpViewInfo.alpha = 1
    }
    
    func downloadImage(from url: URL,imageView:UIImageView) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { [self] in
                imageView.image = UIImage(data: data)
                elementCount+=1
                collectionViewNasaImage.reloadData()
                print(Float(elementCount) / Float(self.data[key.photos].count))
                progressView.progress = Float(elementCount) / Float(self.data[key.photos].count)

                if elementCount > 10 {
                    collectionViewNasaImage.isHidden = false
                }
                if elementCount == self.data[key.photos].count {
                    buttonFilter.alpha = 1
                    buttonFilter.isUserInteractionEnabled = true
                    downloaded = true
                    labelLoading.isHidden = true
                    collectionViewNasaImage.isHidden = false
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getDataFromNasa() {
        
        AF.request(selectedUrl).responseJSON { response in
            debugPrint(response)

            if response.response?.statusCode == 200 {
            if let json = response.data {
                
                do {
                    self.data = try JSON(data: json)
                    
                    self.initializeObjects()
                    
                } catch _ {
                    
                }
            }
            } else {
                self.labelLoading.text = "Bir hata oluştu..\nError code: \(response.response?.statusCode ?? 0)"
            }
        }
    }
}
