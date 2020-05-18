//
//  PillsTableViewController.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 13.5.20.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//

import UIKit
import CoreData


/*
  Table view controller zobrazujuci zoznam jednotlivych ulozenych liekov
  dedi z UITableViewController a PillsDSDelegate (kvoli spracovaniu eventov)
 */
class PillsTableViewController: UITableViewController, PillsDSDelegate {
    
    // pre potreby CoreData pre pristup k persistentContainer
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    /*
        pole objektov PillsDataSource - k samotnemu "Pill" je mozne sa dostat pomocou referencie:
        medications[indexPath.section][indexPath.row]
     */
    var medications: [PillsDataSource] = []
    
    //vrati objekt Pill z medications
    func pill(atIndexPath: IndexPath) -> Pill {
        return medications[atIndexPath.section][atIndexPath.row]
    }
    
    
    /*
        pri viewDidLoad sa instancuje jedna sekcia do medications,
        DataSource spusta zistovanie dat, posiela sa notifikacia
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        medications.append(PillsDataSource.All(delegate: self, section: 0))
    }
    

    /*
        reload dat
     */
    func reloadFrom(pillsDS: PillsDataSource) {
        tableView.reloadData()
    }
    
    /*
        update dat pricom sa posiela aj objekt Pill a obnovia sa aj sekcie
     */
    func updateFrom(pillsDS: PillsDataSource, onPill: Pill) {
        tableView.reloadSections(IndexSet(integer: pillsDS.section),
                                 with: .automatic)
    }
    
    /*
        spristupni upravu tableView na bunke indexPath.row
        aby bolo mozne po tahu s nou vykonat upravy
        V konkretnom pripade umoznuje vymazanie danej bunky
     */
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*
        vymazanie danej bunky aj z tableView, z medication[].selection a  aj z CoreData
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //ziskanie unikatneho ID na ziskanie referencie daneho objetku v CD
            let removePillID =  medications[indexPath.section][indexPath.row].pillID
            //zmazanie objektu Pill z medications
            medications[indexPath.section].selection.remove(at: indexPath.row)
            // najdenie NSManagedObject s danym unikatnymID pillID
            let getData = NSFetchRequest<NSFetchRequestResult>(entityName: "Medications")
            getData.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(getData)
                for data in result as! [NSManagedObject] {
                    let pillID = data.value(forKey: "pillID") as! String
                    if pillID == removePillID {
                        context.delete(data)
                        break
                    }
                }
            } catch {
                print("Data Loading Failed")
            }
            appDelegate.saveContext()   //ulozenie zmien
            do  {
               try context.save()
            } catch {
               print ("Failed saving data")
            }
            // aktualizacia tableView
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    /*
        pocet sekcii v medications
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return medications.count
    }
    
    /*
        vrati nazov danej sekcie
     */
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pill"
    }

    /*
        vrati pocet rows v danej sekcii
     */
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int
    {
        //
        return medications[section].count
    }
    
    /*
        na zabezpecenie "recyklacie" jednotlivych buniek pri scrolovani
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PillCell") as! PillTableViewCell
        cell.setPill(pill(atIndexPath: indexPath))
        return cell
    }
    
    /*
        outlety na umoznenie editovania buniek, t.j. zmena poradia pripadne zmazanie bunky
     */
    @IBOutlet weak var pillView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editAction(_ sender: Any) {
        pillView.isEditing = !pillView.isEditing
        if pillView.isEditing {
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
        }
    }
    // umozni zmenu poradia buniek
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // umozni zmenu poradia buniek
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = medications[sourceIndexPath.section][sourceIndexPath.row]    // presuvam zo source.row do destination.row
        medications[sourceIndexPath.section].selection.remove(at: sourceIndexPath.row)
        medications[sourceIndexPath.section].selection.insert(item, at: destinationIndexPath.row)
        
    }
    

    /*
        priprava storyboardu pred uskutovnenim zmien v navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // tento segue spusti detail view uz existujucej bunky a tym umozni zmenu obsahu
        if segue.identifier == "pillDetail",
            let _dest = segue.destination as? PillDetailViewController,
            let _selRow = tableView.indexPathForSelectedRow
        {
            //
            _dest.pill = pill(atIndexPath: _selRow)
        }
        // pridanie novej bunky
        if segue.identifier == "addNew",
            let _dest = segue.destination as? PillDetailViewController
        {
            //
            _dest.pill = Pill(newPill: "", start: "", end: "", when: "", id: "")
        }
    }
 

}

