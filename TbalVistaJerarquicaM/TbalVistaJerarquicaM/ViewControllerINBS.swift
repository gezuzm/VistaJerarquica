//
//  ViewControllerINBS.swift
//  TbalVistaJerarquicaM
//
//  Created by jesus serrano on 09/10/16.
//  Copyright © 2016 gezuzm. All rights reserved.
//

import UIKit

class ViewControllerINBS: UIViewController {
    
    @IBOutlet weak var tfISBN: UITextField!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autores: UILabel!
    @IBOutlet weak var imgvPortada: UIImageView!
    @IBOutlet weak var labPortada: UILabel!
    @IBOutlet weak var labError: UILabel!
    @IBOutlet weak var labTitulo: UILabel!
    @IBOutlet weak var labISBN: UILabel!
    @IBOutlet weak var labISBN2: UILabel!
    
    @IBOutlet weak var varBtnRegresar: UIButton!
    @IBOutlet weak var varBtnLimpiar: UIButton!
    @IBOutlet weak var varBtnBuscar: UIButton!
    
    var datos_finales: Array<String> = Array<String>()
    var isbnSeleccionadoTabla: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       // tfISBN.text = "978-84-376-0494-7"
        tfISBN.text = "8425220181"
        
        datos_finales = Array<String>()
        
        
        // quiere decir que viene d ela seleccion de la lista de la tabla
        if isbnSeleccionadoTabla != ""
        {
            self.varBtnBuscar.hidden = true
            self.varBtnLimpiar.hidden = true
            self.varBtnRegresar.hidden = true
            
            self.labTitulo.text = "Resultado de la selección de la Tabla"
            
            tfISBN.text = isbnSeleccionadoTabla
            
            if tfISBN.text != ""
            {
                datos_finales = Array<String>()
              
                self.labISBN.text = tfISBN.text
                self.tfISBN.hidden = true
                
                sincronoJSON()
            }
            else
            {
                muestraMensaje("Es necesario escribir el ISBN")
            }
        }
        else
        {
            self.labISBN.hidden = true
            self.labISBN2.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        let regresarVista = segue.destinationViewController as! TVC
        
        if datos_finales.count > 1
        {
            regresarVista.prueba  = "1"
            regresarVista.datos_finales = datos_finales
        }
        else
        {
              regresarVista.prueba  = "0"
        }
    }
    
    func sincronoJSON()
    {
        
        titulo.text=""
        autores.text=""
        labError.text=""
        
        if labPortada.text == ""
        {
            imgvPortada.hidden = true
        }
        
        labPortada.text=""
        
        let isbn: String = "ISBN:"
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=" + isbn + tfISBN.text!
        // se convierte a URL
        let url = NSURL(string: urls)
        
        // HACE UNA PETCION AL SERVIDOR
        let datos: NSData? = NSData(contentsOfURL: url!)
        
        // para mostrarlo hay qye decirel en que formato esta
        let textoISBN = tfISBN.text!
        // print(  datos)
        var urlImagen : String = ""
        
        if datos != nil
        {
            if datos?.length > 2
            {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    
                    // hacer el recorrido del arbol JSON
                    let dic1 = json as! NSDictionary
                    let dic2 = dic1[isbn + textoISBN] as! NSDictionary
                    
                    // muestra el titulo
                    self.titulo.text = dic2["title"] as! NSString as String
                    
                    var author: String?
                    var authores: String = " "
                    
                    // muestra los autores
                    if let dic3 = dic2["authors"] as? NSArray
                    {
                        for array in dic3
                        {
                            if let obj_array = dic3.lastObject as? NSDictionary
                            {
                                author = obj_array["name"] as? String
                                
                                if author != nil{
                                    authores = authores + " - " + author!
                                }
                            }
                        }
                    }
                    
                    if authores != " "{
                        self.autores.text = authores
                    }
                    else{
                        self.autores.text = "no hay autores"
                    }
                    
                    // muestra la portada si hay
                    do{
                        
                        if  let dic4 = dic2["cover"] as? NSDictionary
                        {
                            
                            let urlImg4 = dic4["small"] as! NSString as String
                            
                            imageFromUrl(urlImg4)
                            
                            urlImagen  = urlImg4
                        }
                        else
                        {
                            self.labPortada.text = "No hay Portada"
                        }
                    }
                        
                    catch {
                        // self.imgvPortada.image = "no tiene portada registrada"
                    }
                }
                catch _
                {
                    
                }
                
                // si todo salio bien, llenar la estructura
                self.datos_finales.append(titulo.text!)
                self.datos_finales.append(autores.text!)
                if urlImagen == ""
                {
                    self.datos_finales.append("No hay Portada")
                    
                }
                else{
                    self.datos_finales.append(urlImagen)
                    
                }
                
                self.datos_finales.append(self.tfISBN.text!)
                
            }
            else
            {
                
                self.labError.text = "ISBN no válido..."
                
                titulo.text=""
                autores.text=""
                
                if labPortada.text == ""
                {
                    
                    // imgvPortada.removeFromSuperview()  // this removes it from your view hierarchy
                    imgvPortada.hidden = true
                    // imgvPortada = nil;
                }
                
                labPortada.text=""
            }
        }
        else
        {
            // tvResultado.text = "Ocurrió un error, no hay conexion..."
            self.labError.text = "Ocurrió un error, no hay conexion..."
            
            titulo.text=""
            autores.text=""
            
            if labPortada.text == ""
            {
                
                // imgvPortada.removeFromSuperview()  // this removes it from your view hierarchy
                imgvPortada.hidden = true
                // imgvPortada = nil;
            }
            
            labPortada.text=""
        }
    }
    
    
    @IBAction func btnLimpiar(sender: UIButton) {
        
        tfISBN.text = ""
        //tvResultado.text = ""
        
        titulo.text=""
        autores.text=""
        labError.text=""
        
        datos_finales = Array<String>()
        
        if labPortada.text == ""
        {
            imgvPortada.hidden = true
        }
        
        labPortada.text=""

    }
    
    
    @IBAction func btnBuscar(sender: UIButton) {
        
        // cerrar teclado
        tfISBN.resignFirstResponder()
        
        if tfISBN.text != ""
        {
            datos_finales = Array<String>()
            
            sincronoJSON()
        }
        else
        {
            muestraMensaje("Es necesario escribir el ISBN")
        }
    }
    
    
    // oculta el teclado cuando presiona enter
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        self.sincronoJSON()
        
        return true
        
    }
    
    // oculta el teclado cuando presiona esoacio vacio
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        tfISBN.resignFirstResponder()
        
    }

    func muestraMensaje(cadena : String)
    {
        let alertController = UIAlertController(title: "Aviso", message:
            cadena, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // codigo descargado de:
    // http://blog.mcnallydevelopers.com/cargar-imagen-desde-un-url-en-un-imageview-de-ios-con-swift-2/
    func imageFromUrl(urlString: String) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                
                self.imgvPortada.hidden = false
                
                
                if data != nil
                {
                    self.imgvPortada.image = UIImage(data: data!)
                    self.labPortada.text = ""
                    self.imgvPortada.contentMode = UIViewContentMode.ScaleAspectFit
                }
                else
                {
                    self.imgvPortada.hidden = true
                    self.labPortada.text = "No hay Portada"
                }
            }
            }.resume()
    }


}
