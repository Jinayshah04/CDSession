//
//  ViewController.swift
//  CDSession
//
//  Created by mobile1 on 27/11/24.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
   
    @IBOutlet weak var btnNavigate: UIButton!
    @IBOutlet weak var tableVC: UITableView!
    private var jokeArr:[JokeModel]=[]
    
    override func viewWillAppear(_ animated: Bool) {
        loadApi()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
//        deleteCD()
        // Do any additional setup after loading the view.
    }
    
    func reloadTable(){
            DispatchQueue.main.async{
                self.tableVC.reloadData()
            }
        }
    
    func setupTable(){
        tableVC.register(UINib(nibName: "JokeCell", bundle: nil), forCellReuseIdentifier: "JokeCell")
        tableVC.delegate=self
        tableVC.dataSource=self
    }
    
    @IBAction func btnRedirect(_ sender: Any) {
        print("------------")
        performSegue(withIdentifier: "NavigateToCD", sender: nil)
    }
    
    func loadApi(){
        ApiManager().fetchAF (completionHandler: { result in
            switch result{
            case .success(let data):
                self.jokeArr.append(contentsOf: data)
                self.tableVC.reloadData()
            
            case .failure(let error):
                print("\(error)")
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return  }
        
        let managedContext = delegate.persistentContainer.viewContext
        
        guard let jokeEntity = NSEntityDescription.entity(forEntityName: "JokeEntity", in: managedContext) else { return }
        
        let joke = NSManagedObject(entity: jokeEntity, insertInto: managedContext)
        
        joke.setValue(jokeArr[indexPath.row].id, forKey: "id")
        joke.setValue(jokeArr[indexPath.row].type, forKey: "type")
        joke.setValue(jokeArr[indexPath.row].setup, forKey: "setup")
        joke.setValue(jokeArr[indexPath.row].punchline, forKey: "punchline")
        
        do{
            try managedContext.save()
            
            print("Saved to Core Data")
        }catch let err as NSError{
            print("Failed to add to Core Data-\(err)")
        }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokeCell", for: indexPath) as! JokeCell
        cell.id.text="\(jokeArr[indexPath.row].id)"
        cell.type.text=jokeArr[indexPath.row].type
        cell.setup.text=jokeArr[indexPath.row].setup
        cell.punchline.text=jokeArr[indexPath.row].punchline
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "NavigateCD" {
                if let destinationVC = segue.destination as? DataFetched {
                    if let jokeId = sender as? Int {
                        destinationVC.jokeId=jokeId
                    }
                }
            }
        }
}

