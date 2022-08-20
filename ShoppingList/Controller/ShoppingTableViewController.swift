//
//  ShoppingTableViewController.swift
//  ShoppingList
//
//  Created by juris.katkovskis on 18/08/2022.
//

import UIKit
import CoreData
class ShoppingTableViewController: UITableViewController {

//    var shopping = [String]()
    var shopping = [Shopping]()
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        loadData()
    }
    
    
    func loadData(){
        let request: NSFetchRequest<Shopping> = Shopping.fetchRequest()
        do{
            if let result = try managedObjectContext?.fetch(request) {
                shopping = result
                tableView.reloadData()
            }
        }catch{
            print("error in saving core data items")
        }
    }
    
    func saveData(){
        do{
            try managedObjectContext?.save()
        }catch{
            print("error in loading core data items")
        }
        loadData()
    }

    
    @IBAction func deleteAllItems(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Delete items", message: "Delete all items from the list?", preferredStyle: .alert)
        let addDeleteButton = UIAlertAction(title: "Delete", style: .destructive)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try self.managedObjectContext?.execute(batchDeleteRequest)
        } catch {
            print("Error in batch delete!")
        }
        
        self.saveData()
    }
    

        
    
    
    @IBAction func addNewItem(_ sender: Any) {
        let alertController = UIAlertController(title: "Shopping Item", message: "What do you want to add?", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter the title of your item"
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .sentences
            
            
    }
   
        
        alertController.addTextField{textField in
            
            textField.placeholder = "Enter the amount you would like to add"
            textField.autocorrectionType = .no
            textField.autocapitalizationType = . sentences
}
        
        
        
        let addActionButton = UIAlertAction(title: "Add", style: .default) { action in
            let textField = alertController.textFields?.first
            let countTextField = alertController.textFields?.last
            if let entity = NSEntityDescription.entity(forEntityName: "Shopping", in: self.managedObjectContext!){
                let shop = NSManagedObject(entity: entity, insertInto: self.managedObjectContext)
                
                shop.setValue(textField?.text, forKey: "item")
                shop.setValue(countTextField?.text, forKey: "count")
                 
                
                
                
                
            }
                
            self.saveData()
        }//add
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(addActionButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
        
    }
    
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shopping.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath)

        let shop = shopping[indexPath.row]
        cell.textLabel?.text = "Item: \(shop.value(forKey: "item") ?? "")"
        cell.detailTextLabel?.text = "Count: "
        cell.accessoryType = shop.completed ? .checkmark : .none
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

//MARK: - Table View delegate
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            managedObjectContext?.delete(shopping[indexPath.row])
        }
        saveData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shopping[indexPath.row].completed = !shopping[indexPath.row].completed
        saveData()
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }
    */

 
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
