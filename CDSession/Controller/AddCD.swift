//
//  AddCD.swift
//  CDSession
//
//  Created by mobile1 on 29/11/24.
//

import UIKit
import CoreData
class AddCD: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrjoke:[JokeModel]=[]
    
    @IBOutlet weak var tableVC: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        setupTable()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        readCD()
//        deleteCD()
        // Do any additional setup after loading the view.
    }
    
    func setupTable(){
        tableVC.register(UINib(nibName: "JokeCell", bundle: nil), forCellReuseIdentifier: "JokeCell")
        tableVC.delegate=self
        tableVC.dataSource=self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "NavigateCD", sender: arrjoke[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrjoke.count
    }
    func reloadTable(){
            DispatchQueue.main.async{
                self.tableVC.reloadData()
            }
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokeCell", for: indexPath) as! JokeCell
        cell.id.text="\(arrjoke[indexPath.row].id)"
        cell.type.text=arrjoke[indexPath.row].type
        cell.setup.text=arrjoke[indexPath.row].setup
        cell.punchline.text=arrjoke[indexPath.row].punchline
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func readCD(){
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return  }
        
        let managedContext = delegate.persistentContainer.viewContext
        
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: "JokeEntity")
        do{
            let result = try managedContext.fetch(fetchData)
            for data in result as! [NSManagedObject]{
                let vid=data.value(forKey: "id") as! Int
                let vtype=data.value(forKey: "type") as! String
                let vsetup=data.value(forKey: "setup") as! String
                let vpunch=data.value(forKey: "punchline") as! String
                
                arrjoke.append(JokeModel(id: vid, type: vtype, setup: vsetup, punchline: vpunch))
            }
            tableVC.reloadData()
        }catch let err as NSError{
            print("Failed to Fetch Data \(err)")
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, sourceView, completionHandler in
                self.deleteCD(jokes: self.arrjoke[indexPath.row])
                self.arrjoke.remove(at: indexPath.row)
                self.reloadTable()
            }
            
            let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
            swipeConfig.performsFirstActionWithFullSwipe = false
            return swipeConfig
        }
        
    func deleteCD(jokes:JokeModel){
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = delegate.persistentContainer.viewContext
            
            // Create a fetch request to retrieve the joke by id
        
        let a = NSFetchRequest<NSFetchRequestResult>(entityName: "JokeEntity")
        
        print(jokes)
        
        a.predicate = NSPredicate(format: "id == %d", jokes.id)
            
            do {
                let results = try managedContext.fetch(a)
                guard let fetchedJoke = results.first else {
                    print("Joke Not Found")
                    return  }
//                for data in results as [NSManagedObject]{
//                    managedContext.delete(data)
//                }
                managedContext.delete(fetchedJoke as! NSManagedObject)
                try managedContext.save()
            } catch let error as NSError {
                print("Failed to delete joke: \(error)")
            }
        }
}
