//
//  TVC.swift
//  TbalVistaJerarquicaM
//
//  Created by jesus serrano on 09/10/16.
//  Copyright © 2016 gezuzm. All rights reserved.
//

import UIKit

class TVC: UITableViewController {

    
    private var libros : Array<Array<String>> = Array<Array<String>>()
    let tituloSeccion = ["Listado de Libros"]
    var prueba : String?
    var datos_finales : Array<String> = Array<String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Libros encontrados en OpenLibrary.org"
        
        //mostrar el UIBUTtonBAR
        self.navigationController?.toolbarHidden = false;

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    
    @IBAction func AgregarLibroUIButtonBar(sender: UIBarButtonItem) {
        
       // self.libros.append(["libro3","autor","portada","isbn"])
       // self.tableView.reloadData()
        
    }
    
    
    
    @IBAction func fromViewControllerISBN(segue : UIStoryboardSegue!)
    {
        if prueba == "0"
        {
           // self.libros.append(["no lo hizo :(","autor","portada","isbn"])
        }
        else
        {
           // self.libros.append([prueba!,"autor","portada","isbn"])
            var encontro : Bool = false
            
            for dato : [String] in libros
            {
                if dato[0] == datos_finales[0]
                {
                    encontro = true
                }
            }
            
            if encontro == false
            {
                 self.libros.append(datos_finales)
            }
        }
        
        
        self.tableView.reloadData()
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
         return self.tituloSeccion.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < tituloSeccion.count {
            return tituloSeccion[section]
        }
        
        return nil
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
          return self.libros.count // maximo numero de consultas a guardar
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Celda", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = self.libros[indexPath.row][0]
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cc = segue.destinationViewController as! ViewControllerINBS
        
        let ip = self.tableView.indexPathForSelectedRow
        
        if ip != nil
        {
        cc.isbnSeleccionadoTabla = self.libros[ip!.row][3]
        }
        
    }
    

}
