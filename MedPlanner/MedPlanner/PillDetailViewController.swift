//
//  PillDetailViewController.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 13.5.20.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//

import UIKit
import Foundation

/*
    Detail view bunky, detailnejsi pohlad na objekt Pill
 */
class PillDetailViewController: UITableViewController {

    var pill: Pill!
//    var pillID: [String] = []

    /*
        jednotlive odkazy na objekty s informaciami v TableView
     */
    @IBOutlet weak var PillImage: UIImageView!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Start: UITextField!
    @IBOutlet weak var End: UITextField!
    @IBOutlet weak var When: UITextField!


    private var datePicker: UIDatePicker? // na vyber datumu pociatku uzivania lieku a koniec
    private var timePicker: UIDatePicker? // na vyber casu, kedy je potrebne liek uzit
 
    /*
         aktualizuje obsah objektu a posiela notifikaciu databaze o zmene objektu
     */
    func updateModel() {
        if let _name = Name.text, let _start = Start.text,
            let _end = End.text, let _when = When.text{
            //ulozenie zadanych hodnot uzivatelom do objektu Pill
            pill.name = _name
            pill.dateBegin = _start
            pill.dateEnd = _end
            pill.whenTake = _when
            //notifikacia
            AppDelegate.shared.pillsDatabase.updated(setNew: pill)
        }
    }
    
    /*
        lave navratove tlacitko so "Save"
        posiela sa signal o zmene
     */
    @objc func backButton(_ sender: Any) {
        updateModel()
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
        datum pociatku uzivania lieku
        konverzia z datePicker.date do stringu
        v tvare "yyyy/MM/dd"
     */
    @objc func startDateChanged(datePicker: UIDatePicker) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd"
        Start.text = dateFormat.string(from: datePicker.date)
        view.endEditing(true)
    }
    /*
        datum konca uzivania lieku
        konverzia z datePicker.date do stringu
        v tvare "yyyy/MM/dd"
     */
    @objc func endDateChanged(datePicker: UIDatePicker) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd"
        End.text = dateFormat.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    /*
        cas kedy je potrebne liek uzit
        konverzia z timePicker.date do stringu
        v tvare "HH:mm" -> HH je 24hodinvy format
     */
    @objc func timeChanged(timePicker: UIDatePicker) {
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm"
        When.text = timeFormat.string(from: timePicker.date)
        view.endEditing(true)
    }
    
    /*
        pri zaregistrovani gesta tuknutia uskutocni koniec/zrusenie upravy pri zadavani vstupu
     */
    @objc func viewTap(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // nastavenie gesta tuknutia
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap(gestureRecognizer:)))
        view.addGestureRecognizer(tap)
        
        // spravne nastavenie funkcionality datePicker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(startDateChanged(datePicker:)), for: .valueChanged)
        Start.inputView = datePicker
        datePicker = UIDatePicker()     // potrebne zresetovat nakolko by sa pouzil ten isty datum aj pre End
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(endDateChanged(datePicker:)), for: .valueChanged)
        End.inputView = datePicker
        // spravne nastavenie funkcionality pre ziskanie casu
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.addTarget(self, action: #selector(timeChanged(timePicker:)), for: .valueChanged)
        When.inputView = timePicker
        
        
        PillImage.image = pill.showImage
        Name.text = pill.name
        Start.text = pill.dateBegin
        End.text = pill.dateEnd
        When.text = pill.whenTake
        
        // nastavenie back -> "save" tlacitka
        let _back = UIBarButtonItem(barButtonSystemItem: .save,
                                    target: self,
                                    action: #selector(PillDetailViewController.backButton(_:)))
        
        navigationItem.leftBarButtonItem = _back
    }
}
