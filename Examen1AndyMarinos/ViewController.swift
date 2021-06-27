//
//  ViewController.swift
//  Examen1AndyMarinos
//
//  Created by Andy on 26/06/21.
//  Copyright © 2021 Andy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var usuarios = [User]()
    
    @IBOutlet weak var TablaUsuarios: UITableView!
    
    func conexion()->NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarInfoDataCore()
        print (usuarios)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func agregarUsuario(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Agregar Usuario", message: "Nuevo Usuario", preferredStyle: .alert)
        
        alert.addTextField{(nameAlert)in
            nameAlert.placeholder = "Nombres"
        }
        
        alert.addTextField{(lastNameAlert)in
            lastNameAlert.placeholder = "Apellidos"
        }
        
        alert.addTextField{(emailAlert)in
            emailAlert.placeholder = "Correo electrónico"
        }
        
        alert.addTextField{(ageAlert)in
            ageAlert.placeholder = "Edad"
        }
        
        
        let actionAceptar=UIAlertAction(title: "Aceptar", style: .default){(_)in
            
            print ("Agregar elemento")
            
            guard let nameAlert = alert.textFields?[0].text else {return}
            guard let lastNameAlert = alert.textFields?[1].text else {return}
            guard let emailAlert = alert.textFields?[2].text else {return}
            guard let ageAlert = alert.textFields?[3].text else {return}
            
            let contexto = self.conexion()
            
            let entidadUsuario = NSEntityDescription.insertNewObject(forEntityName: "User", into: contexto) as! User
            
            entidadUsuario.name = nameAlert
            entidadUsuario.lastName = lastNameAlert
            entidadUsuario.email = emailAlert
            entidadUsuario.age = Int16(ageAlert) ?? 0
            
            do{
                try contexto.save()
                print ("Se guardo correctamente !")
                self.usuarios.append(entidadUsuario)
                
            }catch let error as NSError {
                print("Error al guardar en la BD\(error.localizedDescription)")
            }

            self.TablaUsuarios.reloadData()
            
        }
        
        
        let actionCancelar=UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alert.addAction(actionAceptar)
        alert.addAction(actionCancelar)
        
        present(alert, animated: true, completion: nil)
    }
    
    func cargarInfoDataCore(){
        let contexto = conexion()
        
        let fetchRequest: NSFetchRequest <User> = User.fetchRequest()
        
        do {
            usuarios = try contexto.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error al cargar la informacion de la BD\(error.localizedDescription)")
        }
    }
    
}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda=TablaUsuarios.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        celda.textLabel?.text = usuarios[indexPath.row].name! + " " + usuarios[indexPath.row].lastName! + " - " + String(usuarios[indexPath.row].age) + " años"
        celda.detailTextLabel?.text = usuarios[indexPath.row].email
        return celda
        
    }
}
