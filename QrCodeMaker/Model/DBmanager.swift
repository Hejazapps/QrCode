//
//  Database1.swift
//  FinalDocumentScanner
//
//  Created by MacBook Pro Retina on 29/12/19.
//  Copyright © 2019 MacBook Pro Retina. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import SQLite3

class DBmanager: NSObject {
    
    let queue = DispatchQueue(label: "db-queue", qos: .userInitiated)
    var DBpath:String!
    var db : OpaquePointer!
    
    
    static let shared = DBmanager()
    
    private func manageDBLocation () {
        do {
            
            
            let fileManager = FileManager.default

            let DBpath = try fileManager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("qrCode.sqlite")
                .path

            if !fileManager.fileExists(atPath: DBpath) {
                let dbResourcePath = Bundle.main.path(forResource: "qrCode", ofType: "sqlite")!
                try fileManager.copyItem(atPath: dbResourcePath, toPath: DBpath)
            }

            
            var attributes = [FileAttributeKey : Any]()
            attributes[.posixPermissions] = NSNumber(value: 511)
            do {
                try fileManager.setAttributes(attributes, ofItemAtPath: DBpath)
            }catch let error {
                print("Permissions error: ", error)
            }
            
        } catch let e {
            
            print("\(e)")
        }
        
    }
    
    
    func initDB(){
        queue.async { [weak self] in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            let path:Array=NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let directory:String=path[0]
            DBpath = (directory as NSString).appendingPathComponent("qrCode.sqlite")
            
            
            
            
            
            let isSuccess = true
            
            if (!FileManager.default.fileExists(atPath: DBpath as String))
            {
                self.manageDBLocation()
            }
        }
    }
    
    func getMaxIdForRecord(completion: @escaping (Int) -> Void) {
        queue.async { [weak self] in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            var queryStatement: OpaquePointer? = nil
            var getId  = -1
            
            let stmt =  "SELECT MAX(id) FROM record"
            
            if (sqlite3_open(DBpath, &db)==SQLITE_OK)
            {
                
                if sqlite3_prepare_v2(db, stmt, -1, &queryStatement, nil) == SQLITE_OK {
                    // 2
                    while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                        
                        
                        
                        let id = sqlite3_column_text(queryStatement, 0)
                        
                        if((id) != nil)
                        {
                            let str = String(cString: id!) as NSString
                            getId = Int(str.intValue)
                        }
                        
                    }
                    
                }
                else{
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    NSLog(errmsg)
                }
                sqlite3_finalize(queryStatement)
                sqlite3_close(db)
            }
            
            completion(getId)
        }
    }

    func getRecordInfo(indexPath: String, completion: @escaping ([DataInformation]) -> Void) {
        queue.async { [weak self] in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            var mutableArray: [DataInformation] = []
            var queryStatement: OpaquePointer? = nil
            
            let stmt =  "SELECT id,Text,indexPath,codeType,position,shape,logo,folderid FROM record  where indexPath = ('\(indexPath)') order by id DESC"
            if (sqlite3_open(DBpath, &db)==SQLITE_OK)
            {
                
                if sqlite3_prepare_v2(db, stmt, -1, &queryStatement, nil) == SQLITE_OK {
                    
                    while (sqlite3_step(queryStatement) == SQLITE_ROW){
                        
                        let obj : DataInformation = DataInformation()
                        
                        let id = sqlite3_column_text(queryStatement, 0)
                        let Text =  sqlite3_column_text(queryStatement, 1)
                        let indexPath =  sqlite3_column_text(queryStatement, 2)
                        let codeType =  sqlite3_column_text(queryStatement, 3)
                        let position =  sqlite3_column_text(queryStatement, 4)
                        let shape =  sqlite3_column_text(queryStatement, 5)
                        let logo =  sqlite3_column_text(queryStatement, 6)
                        let folderid =  sqlite3_column_text(queryStatement, 7)
                        
                        let str = String(cString: id!)
                        let str1 = String(cString: Text!)
                        let str2 = String(cString: indexPath!)
                        let str3 = String(cString: codeType!)
                        let str4 = String(cString: position!)
                        let str5 = String(cString: shape!)
                        let str6 = String(cString: logo!)
                        let str7 = String(cString: folderid!)
                        
                        
                        
                        obj.id = str
                        obj.Text = str1
                        obj.indexPath = str2
                        obj.codeType =  str3
                        obj.position =  str4
                        obj.shape =  str5
                        obj.logo =  str6
                        obj.folderid = str7
                        
                        if obj.folderid.count < 1 {
                            mutableArray .append(obj)
                        }
                    }
                }
                sqlite3_finalize(queryStatement)
                sqlite3_close(db)
            }
            
            print("\(indexPath) testP  \(mutableArray.count)")
            
            
            completion(mutableArray)
       }
    }
    
    func getFolderElements(folderid: String, completion: @escaping ([DataInformation]) -> Void) {
       queue.async { [weak self] in
           guard let self else {
               print("Can't make self strong!")
               return
           }
           
           var mutableArray: [DataInformation] = []
           var queryStatement: OpaquePointer? = nil
           
           let stmt =  "SELECT id,Text,indexPath,codeType,position,shape,logo,folderid FROM record  where folderid = ('\(folderid)') order by id DESC"
           if (sqlite3_open(DBpath, &db)==SQLITE_OK)
           {
               
               if sqlite3_prepare_v2(db, stmt, -1, &queryStatement, nil) == SQLITE_OK {
                   
                   while (sqlite3_step(queryStatement) == SQLITE_ROW){
                       
                       let obj : DataInformation = DataInformation()
                       
                       let id = sqlite3_column_text(queryStatement, 0)
                       let Text =  sqlite3_column_text(queryStatement, 1)
                       let indexPath =  sqlite3_column_text(queryStatement, 2)
                       let codeType =  sqlite3_column_text(queryStatement, 3)
                       let position =  sqlite3_column_text(queryStatement, 4)
                       let shape =  sqlite3_column_text(queryStatement, 5)
                       let logo =  sqlite3_column_text(queryStatement, 6)
                       let folderid =  sqlite3_column_text(queryStatement, 7)
                       
                       let str = String(cString: id!)
                       let str1 = String(cString: Text!)
                       let str2 = String(cString: indexPath!)
                       let str3 = String(cString: codeType!)
                       let str4 = String(cString: position!)
                       let str5 = String(cString: shape!)
                       let str6 = String(cString: logo!)
                       let str7 = String(cString: folderid!)
                       
                       obj.id = str
                       obj.Text = str1
                       obj.indexPath = str2
                       obj.codeType =  str3
                       obj.position =  str4
                       obj.shape =  str5
                       obj.logo =  str6
                       obj.folderid = str7
                       mutableArray .append(obj)
                   }
                   
               }
               sqlite3_finalize(queryStatement)
               sqlite3_close(db)
           }
           
           completion(mutableArray)
       }
    }
    
    func getFolderInfo(completion: @escaping ([DataInformation]) -> Void) {
        queue.async { [weak self] in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            var mutableArray: [DataInformation] = []
            var queryStatement: OpaquePointer? = nil
            
            let stmt =  "SELECT id,name FROM Folder order by id DESC"
            if (sqlite3_open(DBpath, &db)==SQLITE_OK)
            {
                
                if sqlite3_prepare_v2(db, stmt, -1, &queryStatement, nil) == SQLITE_OK {
                    
                    while (sqlite3_step(queryStatement) == SQLITE_ROW){
                        
                        let obj : DataInformation = DataInformation()
                        
                        let id = sqlite3_column_text(queryStatement, 0)
                        let name =  sqlite3_column_text(queryStatement, 1)
                       
                        
                        let str = String(cString: id!)
                        let str1 = String(cString: name!)
                        

                        obj.folderid = str
                        obj.folderName = str1
                        mutableArray .append(obj)
                        
                    }
                    
                }
                sqlite3_finalize(queryStatement)
                sqlite3_close(db)
            }
            
            completion(mutableArray)
        }
    }
    
    
    func checkUniqueData(name: String, completion: @escaping ([DataInformation]) -> Void) {
        queue.async { [weak self] in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            var mutableArray: [DataInformation] = []
            var queryStatement: OpaquePointer? = nil
            
            let stmt =  "SELECT name FROM Folder where name = ('\(name)')"
            if (sqlite3_open(DBpath, &db)==SQLITE_OK)
            {
                
                if sqlite3_prepare_v2(db, stmt, -1, &queryStatement, nil) == SQLITE_OK {
                    
                    while (sqlite3_step(queryStatement) == SQLITE_ROW){
                        
                        let obj : DataInformation = DataInformation()

                        mutableArray .append(obj)
                        
                    }
                    
                }
                sqlite3_finalize(queryStatement)
                sqlite3_close(db)
            }
            
            completion(mutableArray)
        }
        
    }
    
    
    func getFileData(id:String, completion: @escaping (String?) -> Void) {
        queue.async { [weak self] in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            var queryStatement: OpaquePointer? = nil
            
            let stmt =  "SELECT Text FROM record where id = ('\(id)')"
            if (sqlite3_open(DBpath, &db)==SQLITE_OK) {
                if sqlite3_prepare_v2(db, stmt, -1, &queryStatement, nil) == SQLITE_OK {
                    while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                        
                        let text = sqlite3_column_text(queryStatement, 0)
                        let str = String(cString: text!)
                        sqlite3_close(db)
                        completion(str)
                    }
                }
                sqlite3_finalize(queryStatement)
                sqlite3_close(db)
            }
            
            completion(nil)
        }
    }
    
    
    func deleteFile(id: String, completion: @escaping () -> Void)
    {
        queue.async { [weak self] in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            let stmt = "DELETE FROM  record  where id = ('\(id)')"
            
            let  rc = sqlite3_open_v2(DBpath, &db, SQLITE_OPEN_READWRITE , nil);
            
            
            if (SQLITE_OK != rc)
            {
                sqlite3_close(db);
                NSLog("Failed to open db connection");
            }
            else
                
            {
                if sqlite3_exec(db, stmt, nil, nil, nil)  != SQLITE_OK
                    
                {
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    NSLog(errmsg)
                }
                 
                sqlite3_close(db);
            }
            
            completion()
        }
    }

    
    func updateTableData(id: String,Text: String,position: String,shape:String,logo:String)
    {
        queue.async { [weak self] in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            let createTable = "UPDATE record SET Text ='\(Text)',position ='\(position)',shape ='\(shape)',logo ='\(logo)' WHERE id ='\(id)'"
            if (sqlite3_open(DBpath, &db)==SQLITE_OK)
            {
                
                
                if sqlite3_exec(db, createTable, nil, nil, nil)  != SQLITE_OK
                    
                {
                    print("Erro creating table")
                    
                }
            }
            
            sqlite3_close(db)
        }
    }
    
    
    func updateFolderInfo(id: String,folderid:String)
    {
        let createTable = "UPDATE record SET folderid ='\(folderid)' WHERE id ='\(id)'"
        
        if (sqlite3_open(DBpath, &db)==SQLITE_OK)
        {
            
            
            if sqlite3_exec(db, createTable, nil, nil, nil)  != SQLITE_OK
                
            {
                print("Erro creating table")
                
            }
        }
        
        sqlite3_close(db)
    }
    
    func updateFolderInfoBatch(items: [String], folderid: String, completion: @escaping () -> Void) {
        queue.async { [weak self] in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            print("folderid: \(folderid)")
            for item in items {
                print("item: \(item)")
                updateFolderInfo(id: item, folderid: folderid)
            }
            
            completion()
        }
    }
    
   
    func insertRecordIntoFile(Text: String,codeType:String,indexPath:String,position: String,shape:String,logo:String) {
        queue.async { [weak self] in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            let insertData = "INSERT INTO record (Text,codeType,indexPath,position,shape,logo) VALUES  ('\(Text)','\(codeType)','\(indexPath)','\(position)','\(shape)','\(logo)')"
            let  rc = sqlite3_open_v2(DBpath, &db, SQLITE_OPEN_READWRITE , nil);
            
            
            if (SQLITE_OK != rc)
            {
                sqlite3_close(db);
                NSLog("Failed to open db connection");
            }
            else {
                if sqlite3_exec(db, insertData, nil, nil, nil)  != SQLITE_OK
                    
                {
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    NSLog(errmsg)
                }
                
                sqlite3_close(db);
            }
        }
    }
    
    func insertIntoFolder(name:String) {
        queue.async { [weak self] in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            let insertData = "INSERT INTO Folder (name) VALUES  ('\(name)')"
            let  rc = sqlite3_open_v2(DBpath, &db, SQLITE_OPEN_READWRITE , nil);
            
            
            if (SQLITE_OK != rc)
            {
                sqlite3_close(db);
                NSLog("Failed to open db connection");
            }
            else {
                if sqlite3_exec(db, insertData, nil, nil, nil)  != SQLITE_OK
                    
                {
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    NSLog(errmsg)
                }
                sqlite3_close(db);
            }
        }
    }
}

