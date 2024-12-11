//
//  DataFetched.swift
//  CDSession
//
//  Created by mobile1 on 27/11/24.
//

import UIKit
import CoreData
class DataFetched: UIViewController {

    @IBOutlet weak var id: UILabel!
    
    
    @IBOutlet weak var type: UILabel!
    
    
    @IBOutlet weak var setup: UILabel!
    
    
    @IBOutlet weak var punchline: UILabel!
    
    var jokeId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = jokeId {
            fetchJokeById(id: id)
        }
    }
    
    func fetchJokeById(id: Int){
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return  }
        
        let managedContext = delegate.persistentContainer.viewContext
        
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: "JokeEntity")
        fetchData.predicate = NSPredicate(format: "id == %d", id)
        
        do{
            let res = try managedContext.fetch(fetchData)
            print("Fetch Data")
            for data in res.first as! [NSManagedObject]{
                let vid=data.value(forKey: "id") as! Int
                let vtype=data.value(forKey: "type") as! String
                let vsetup=data.value(forKey: "setup") as! String
                let vpunch=data.value(forKey: "punchline") as! String
                
                self.id.text="\(vid)"
                self.type.text=vtype
                self.setup.text=vsetup
                self.punchline.text=vpunch
            }
        }
        catch let err as NSError{
            print("Failed to Fetch Data \(err)")
        }
    }

}
