//
//  NoteViewController.swift
//  Create Note App - Core Data
//
//  Created by Buğra Özuğurlu on 29.09.2022.
//

import UIKit
import CoreData

class NoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Create TableView :
    let tableView:UITableView = {
        
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
        
    }()
    
    private var models = [Notes]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        getItems()
        
        //Delegate & Datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //Create Bar Button Item :
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewNote))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        // TableView Properties
        view.addSubview(tableView)
        title = "My Notes"
        tableView.frame = view.bounds
        
        
        
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit Menu", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Edit", style: UIAlertAction.Style.default, handler: { _ in
            
            let popUp = UIAlertController(title: "Change your notes", message: nil, preferredStyle: .alert)
            
            popUp.addTextField(configurationHandler: nil)
            popUp.textFields?.first?.text = item.name
            
            popUp.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive))
            
            popUp.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { _ in
                
                guard let field = popUp.textFields?.first, let newName = field.text, !newName.isEmpty else {
                
                    return
                }
                
                self.uptadeItem(item: item, newName: newName)
 
            }))
            
            
            
            self.present(popUp,animated: true)
            
            
            }))
        
       
        
        sheet.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive,handler: { _ in
            
            self.deleteItem(item: item)
            
            
        }))
        
        
        present(sheet, animated: true)
        
        
        
        
    }
    
    //Fetch Action :
    func getItems() {
        
        do{
            models = try! context.fetch(Notes.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }catch{
            print(error.localizedDescription)
        }
        
        
    }
    //Create Core Data Model :
    func createItems(name: String) {
        
        let newItem = Notes(context: context)
        newItem.name = name
        newItem.date = Date()
        
        try? context.save()
        getItems()
        
    }
    
    //Delete Note
    func deleteItem(item: Notes) {
        
        context.delete(item)
        try? context.save()
        getItems()
        
        
    }
    
    //Uptade Note
    func uptadeItem(item: Notes,newName: String) {
        
        item.name = newName
        try? context.save()
        getItems()
        
        
        
        
        
    }
    
    @objc func createNewNote() {
        
        let popUp = UIAlertController(title: "New Note", message: "You can create new notes", preferredStyle: UIAlertController.Style.alert)
        
        popUp.addTextField(configurationHandler: nil)
        
        popUp.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive))
        
        
        popUp.addAction(UIAlertAction(title: "Save", style: .default,handler: { _ in
           
            guard let field = popUp.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self.createItems(name: text)
        }))
                                      
        present(popUp, animated: true)
        
        
        
    }


}
