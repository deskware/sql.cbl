

      ****************************************
      * Program name: sql.cbl
      * This program demonstrates the use of
      * SQL with CS Professional Edition.
      *
      * Copyright 2000 Deskware, Inc.
      ****************************************                                                             
      * Syntax: OPENDB USING 
      *                       
      *                       
      *                       .
      *
      * Syntax: CLOSEDB USING .
      *
      * Syntax: EXEC SQL
      *           
      *         END-EXEC.
      *
      *
      * Example SQL Syntax
      *
      *
      * CREATE TABLE                                                              
      *     EXEC SQL                                                              
      *        create table customer                                              
      *        ( firstname   varchar(20),                                         
      *          lastname    varchar(20),                                         
      *          description varchar(50))                                         
      *     END-EXEC.                                                             
      *                                                                           
      * INSERT                                                                    
      *     EXEC SQL                                                              
      *        insert into customer                                               
      *        values (:customer_first_name,                                      
      *                :customer_last_name,                                       
      *                :customer_description)                                     
      *     END-EXEC.                                                             
      *                                                                           
      * DELETE                                                                    
      *     EXEC SQL                                                              
      *         delete from customer                                              
      *         where firstname = 'dean6'                                         
      *     END-EXEC.                                                             
      *                                                                           
      * UPDATE                                                                    
      *     EXEC SQL                                                              
      *        update customer                                                    
      *        set description = 'update test again'                              
      *        where firstname = :customer_first_name and                         
      *              lastname  = :customer_last_name                              
      *     END-EXEC.                                                             
      *                                                                           
      * SELECT                                                                    
      *     EXEC SQL                                                              
      *         select firstname,   lastname,   description                       
      *         into :customer_first_name,                                        
      *              :customer_last_name ,                                        
      *              :customer_description                                        
      *         from customer                                                     
      *         where firstname = 'dean8   '                                      
      *     END-EXEC.                                                             
      *                                                                           
      * DECLARE                                                      
      *           EXEC SQL                                                        
      *                declare cust_cursor cursor for                             
      *                select firstname, dollar_amount                            
      *                from customer                                              
      *                order by firstname                                         
      *           END-EXEC.                                                       
      *                                                                           
      * OPEN                                                          
      *           EXEC SQL                                                        
      *                open cust_cursor                                           
      *           END-EXEC.                                                       
      *                                                                           
      * CLOSE                                                        
      *           EXEC SQL                                                        
      *                close cust_cursor                                          
      *           END-EXEC.                                                       
      *                                                                           
      * FETCH                                                                     
      *           EXEC SQL                                                        
      *              fetch relative :row_position  cust_cursor                    
      *              into :customer_first_name, :customer-dollar-amount           
      *           END-EXEC.                                                       
      *                                                                           
      * FETCH Syntax:                                                             
      *       FETCH {NEXT | PRIOR | FIRST | LAST                                  
      *            | ABSOLUTE {int-constant | host-constant }                     
      *            | RELATVIE {int-constant | host-constant }}                    
      *            cursor-name INTO host-variable [,...]                          
      *                                                                           
      * COMMIT                                                                    
      *            EXEC SQL                                                       
      *                commit                                                     
      *            END-EXEC.                                                      
      *                                                                           
      * ROLLBACK                                                                  
      *            EXEC SQL                                                       
      *                rollback                                                   
      *            END-EXEC.                                                      
      * Include the SQL variable copybook.
       COPY `sql.cpy`.

       1 data_source_name       PIC x(50).
       1 user_id                PIC x(10).
       1 password               PIC x(10).
       1 return_code            PIC s9(05).
       1 row_position           PIC s9(05).
       1 formatted_balance      PIC $$$,$$$.99.
       1 customer_table.
          5 customer_first_name    PIC x(20).
          5 customer_last_name     PIC x(20).
          5 customer_description   PIC x(50).
          5 customer_balance       PIC 9(06).99.
       MAIN.
           PERFORM CONNECT_TO_DATABASE.
           PERFORM CREATE_TABLE.
           PERFORM ALTER_TABLE.
           PERFORM CREATE_INDEX.
           PERFORM INSERT_INTO_TABLE.
           PERFORM SELECT_FROM_TABLE.
           PERFORM BUILD_CURSOR.
           PERFORM UPDATE_TABLE.
           PERFORM DELETE_FROM_TABLE.
           PERFORM DROP_INDEX.
           PERFORM DROP_TABLE.
           PERFORM DISCONNECT_FROM_DATABASE.
           GOBACK.

       CONNECT_TO_DATABASE.
           MOVE `myaccess` TO data_source_name.
           MOVE `test`     TO user_id.
           MOVE `testpass` TO password.
           OPENDB USING    data_source_name
                           user_id
                           password
                           return_code.
           IF return_code = 1 
              DISPLAY `Connection to database established`
           ELSE
              DISPLAY `Connection to databse failed`
           END-IF.
       CREATE_TABLE.
           EXEC SQL
              create table customer
              (firstname   varchar(20),
               lastname    varchar(20),
               description varchar(50) )
           END-EXEC.
           IF sqlnativeerror = 0 
              DISPLAY `Create table successful`
           ELSE
              DISPLAY `Create table failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.
       ALTER_TABLE.
           EXEC SQL
              alter table customer add
                balance currency
           END-EXEC.
           IF sqlnativeerror = 0 
              DISPLAY `Alter table successful`
           ELSE
              DISPLAY `Alter table failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.

       CREATE_INDEX.
           EXEC SQL
              create index cust_index on customer (firstname)
           END-EXEC.
           IF sqlnativeerror = 0 
              DISPLAY `Create index successful`
           ELSE
              DISPLAY `Create index failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.

            
       INSERT_INTO_TABLE.
           MOVE `John`  TO customer_first_name.
           MOVE `Doe`   TO customer_last_name.
           MOVE `Senior Director at ACME Software House` TO customer_description.
           MOVE 49.95 TO customer_balance.
           EXEC SQL
              insert into customer
              values (:customer_first_name,
                      :customer_last_name,
                      :customer_description,
                      :customer_balance )
           END-EXEC.

           IF sqlnativeerror = 0 
              DISPLAY `Insert statement #1 successful`
           ELSE
              DISPLAY `Insert statement #1 failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.

           EXEC SQL
              insert into customer
              values ('Jane',
                      'Doe',
                      'Senior Programmer',
                      123.95 )
           END-EXEC.

           IF sqlnativeerror = 0 
              DISPLAY `Insert statement #2 successful`
           ELSE
              DISPLAY `Insert statement #2 failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.


           EXEC SQL
              insert into customer
              values ('Matt',
                      'Doe',
                      'Junior Programmer',
                      23.00 )
           END-EXEC.

           IF sqlnativeerror = 0 
              DISPLAY `Insert statement #3 successful`
           ELSE
              DISPLAY `Insert statement #3 failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.


           EXEC SQL
              insert into customer
              values ('Charles',
                      'Doe',
                      'GEM Programmer',
                      199.99 )
           END-EXEC.

           IF sqlnativeerror = 0 
              DISPLAY `Insert statement #4 successful`
           ELSE
              DISPLAY `Insert statement #4 failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.


           EXEC SQL
              commit
           END-EXEC.

           IF sqlnativeerror = 0 
              DISPLAY `Commit of insert #1,2,3,4 successful`
           ELSE
              DISPLAY `Commit of insert #1,2,3,4 failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.

           EXEC SQL
              insert into customer
              values ('Jason',
                      'Doe',
                      'Programmer',
                      99.00 )
           END-EXEC.

           IF sqlnativeerror = 0 
              DISPLAY `Insert statement #5 successful`
           ELSE
              DISPLAY `Insert statement #5 failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.

           EXEC SQL
              rollback
           END-EXEC.

           IF sqlnativeerror = 0 
              DISPLAY `Rollback of insert #5 successful`
           ELSE
              DISPLAY `Rollback of insert #5 failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.
       SELECT_FROM_TABLE.
           EXEC SQL
               select firstname,   lastname,   description, balance
               into :customer_first_name,
                    :customer_last_name ,
                    :customer_description,
                    :formatted_balance
               from customer
               where lastname = 'Doe' and
                     firstname = 'Charles'
           END-EXEC.
           IF sqlnativeerror = 0 
              DISPLAY `Select into statement successful`
              DISPLAY `firstname: ` & customer_first_name
              DISPLAY `lastname: ` & customer_last_name
              DISPLAY `description: ` & customer_description
              DISPLAY `balance: ` & formatted_balance
           ELSE
              DISPLAY `Select into statement failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.
       BUILD_CURSOR.
           EXEC SQL
                declare cust_cursor cursor for
                select firstname, lastname, balance
                from customer
               order by balance
           END-EXEC.

           IF sqlnativeerror = 0 
              DISPLAY `Declare cursor successful`
           ELSE
              DISPLAY `Declare cursor failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.


           EXEC SQL
                open cust_cursor
           END-EXEC.

           IF sqlnativeerror = 0 
              DISPLAY `Open cursor successful`
           ELSE
              DISPLAY `Open cursor failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.


           DISPLAY ``.
           DISPLAY `firstname            lastname                balance`.
           DISPLAY `----------------------------------------------------`.
      
           DISPLAY `last`.      
           EXEC SQL
              fetch last cust_cursor
              into :customer_first_name, :customer_last_name, :formatted_balance
           END-EXEC.

           IF sqlnativeerror = 0 
              DISPLAY customer_first_name & ` ` & customer_last_name & ` ` & formatted_balance
           ELSE
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.
      
           MOVE -1 to row_position.
           EXEC SQL
              fetch relative :row_position  cust_cursor
              into :customer_first_name,:customer_last_name, :formatted_balance
           END-EXEC.
           IF sqlnativeerror = 0 
              DISPLAY customer_first_name & ` ` & customer_last_name & ` ` & formatted_balance
           ELSE
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.
      
      
           PERFORM FETCH_DATA_FROM_DATABASE
              until sqlnativeerror = 100.
           DISPLAY `----------------------------------------------------`.
           DISPLAY ``.
      
      
           EXEC SQL
                close cust_cursor
           END-EXEC.

           IF sqlnativeerror = 0 
              DISPLAY `Close cursor successful`
           ELSE
              DISPLAY `Close cursor failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.



       FETCH_DATA_FROM_DATABASE.
           EXEC SQL
              fetch next cust_cursor
              into :customer_first_name,:customer_last_name, :formatted_balance
           END-EXEC.
           IF sqlnativeerror = 0 
              DISPLAY customer_first_name & ` ` & customer_last_name & ` ` & formatted_balance
           END-IF.

       UPDATE_TABLE.
           MOVE `Doe` TO customer_last_name.
           EXEC SQL
              update customer
              set lastname = 'Jones'
              where firstname = 'Matt' and
                    lastname  = :customer_last_name
           END-EXEC.
           IF sqlnativeerror = 0 
              DISPLAY `Update statement successful`
           ELSE
              DISPLAY `Update statement failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.


           EXEC SQL
              commit
           END-EXEC.

           IF sqlnativeerror = 0 
              DISPLAY `Commit of update statement successful`
           ELSE
              DISPLAY `Commit of update statement failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.



       DELETE_FROM_TABLE.
           EXEC SQL
               delete from customer
               where firstname = 'Charles' and lastname = 'Doe'
           END-EXEC.
           IF sqlnativeerror = 0 
              DISPLAY `Delete statement successful`
           ELSE
              DISPLAY `Delete statement failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.

           EXEC SQL
              commit
           END-EXEC.

           IF sqlnativeerror = 0 
              DISPLAY `Commit of delete statement successful`
           ELSE
              DISPLAY `Commit of delete statement failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.
       DROP_INDEX.
           EXEC SQL
              drop index cust_index on customer
           END-EXEC.
           IF sqlnativeerror = 0 
              DISPLAY `Drop index successful`
           ELSE
              DISPLAY `Drop index failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.

       DROP_TABLE.
           EXEC SQL
              drop table customer
           END-EXEC.
           IF sqlnativeerror = 0 
              DISPLAY `Drop table successful`
           ELSE
              DISPLAY `Drop table failed`
              DISPLAY `sqlstate: ` &  sqlstate  
              DISPLAY `sqlnativeerror: ` &  sqlnativeerror
              DISPLAY `sqlerrormessage: ` &  sqlerrormessage
           END-IF.

       DISCONNECT_FROM_DATABASE.
           CLOSEDB USING return_code.
           IF return_code = 1 
              DISPLAY `Connection to database closed successfully`
           ELSE
              DISPLAY `Connection to databse failed to close`
           END-IF.




           














